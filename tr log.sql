sp_whoisactive

sp_whoisactive @get_plans=1

select log_reuse_wait_desc ,* from sys.databases where Name = 'CIQCache'

--tr log full due to log_backup
1. add a new log file on other drive
2. if DEV server and no repl or cdc configured, set db recovery to siimple, shrink log file, then change it back to full
ALTER DATABASE <dbname> SET RECOVERY FULL; 
3. check unrestricted file growth on existing log file
4. take full backup, then take log backup


DBCC SQLPERF(LOGSPACE);
GO

declare @LogSpace table
(
DatabaseName varchar(255),
[Log Size (MB)] float,
[Log Space Used (%)] float,
[Status] int)
insert into @LogSpace
execute('dbcc sqlperf(''LogSpace'')')
select * from @LogSpace
where DatabaseName = 'CapitalIQ'

select * from sys.sysprocesses where blocked>0


SELECT log_reuse_wait, log_reuse_wait_desc
FROM master.sys.databases
WHERE name = N'tempdb';

dbcc opentran --run on tempdb or that specific db

exec sp_msforeachdb 'print ''?''; dbcc opentran (0)'

check disk usage by top tables in tempdb reports to find out table 


SELECT sp.spid,st.text,sp.status,sp.login_time,sp.last_batch,
sp.hostname,sp.loginame FROM sys.sysprocesses sp 
CROSS APPLY sys.dm_exec_sql_text(sp.sql_handle) st
WHERE open_tran = 1 and sp.dbid=DB_ID('GroupStrategies')
order by login_time asc

------------------------------------------------------
find long running queries using the script below.

SELECT * FROM sys.dm_tran_active_snapshot_database_transactions
ORDER BY elapsed_time_seconds DESC;


-------------------------------------------------------------------
--find what query is using up tempdb data files
SELECT
st.dbid AS QueryExecutionContextDBID,
DB_NAME(st.dbid) AS QueryExecContextDBNAME,
st.objectid AS ModuleObjectId,
SUBSTRING(st.TEXT,
dmv_er.statement_start_offset/2 + 1,
(CASE WHEN dmv_er.statement_end_offset = -1
THEN LEN(CONVERT(NVARCHAR(MAX),st.TEXT)) * 2
ELSE dmv_er.statement_end_offset
END - dmv_er.statement_start_offset)/2) AS Query_Text,
dmv_tsu.session_id ,
dmv_tsu.request_id,
dmv_tsu.exec_context_id,
(dmv_tsu.user_objects_alloc_page_count - dmv_tsu.user_objects_dealloc_page_count) AS OutStanding_user_objects_page_counts,
(dmv_tsu.internal_objects_alloc_page_count - dmv_tsu.internal_objects_dealloc_page_count) AS OutStanding_internal_objects_page_counts,
dmv_er.start_time,
dmv_er.command,
dmv_er.open_transaction_count,
dmv_er.percent_complete,
dmv_er.estimated_completion_time,
dmv_er.cpu_time,
dmv_er.total_elapsed_time,
dmv_er.reads,dmv_er.writes,
dmv_er.logical_reads,
dmv_er.granted_query_memory,
dmv_es.HOST_NAME,
dmv_es.login_name,
dmv_es.program_name
FROM sys.dm_db_task_space_usage dmv_tsu
INNER JOIN sys.dm_exec_requests dmv_er
ON (dmv_tsu.session_id = dmv_er.session_id AND dmv_tsu.request_id = dmv_er.request_id)
INNER JOIN sys.dm_exec_sessions dmv_es
ON (dmv_tsu.session_id = dmv_es.session_id)
CROSS APPLY sys.dm_exec_sql_text(dmv_er.sql_handle) st
WHERE (dmv_tsu.internal_objects_alloc_page_count + dmv_tsu.user_objects_alloc_page_count) > 0
ORDER BY (dmv_tsu.user_objects_alloc_page_count - dmv_tsu.user_objects_dealloc_page_count) + (dmv_tsu.internal_objects_alloc_page_count - dmv_tsu.internal_objects_dealloc_page_count) DESC

--------------------------------------------------------------------------------------------------------
SELECT t1.session_id,
       t1.request_id,
       task_alloc_GB = CAST((t1.task_alloc_pages * 8. / 1024. / 1024.) 
         AS NUMERIC(10, 1)),
       task_dealloc_GB = CAST((t1.task_dealloc_pages * 
          8. / 1024. / 1024.) 
         AS NUMERIC(10, 1)),
       host = CASE
                  WHEN t1.session_id <= 50 THEN
                      'SYS'
                  ELSE
                      s1.host_name
              END,
       s1.login_name,
       s1.status,
       s1.last_request_start_time,
       s1.last_request_end_time,
       s1.row_count,
       s1.transaction_isolation_level,
       query_text = COALESCE(
                    (
                  SELECT SUBSTRING(
                    text,
                    t2.statement_start_offset / 2 + 1,
                    (CASE
                     WHEN statement_end_offset = -1 THEN
                        LEN(CONVERT(NVARCHAR(MAX), text)) * 2
                     ELSE
                        statement_end_offset
                     END - t2.statement_start_offset
                                            ) / 2
                                        )
                        FROM sys.dm_exec_sql_text(t2.sql_handle)
                    ),
                    'Not currently executing'
                            ),
       query_plan =
       (
           SELECT query_plan FROM sys.dm_exec_query_plan(t2.plan_handle)
       )
FROM
(
    SELECT session_id,
           request_id,
           task_alloc_pages = SUM(internal_objects_alloc_page_count 
               + user_objects_alloc_page_count),
           task_dealloc_pages = SUM(internal_objects_dealloc_page_count 
                + user_objects_dealloc_page_count)
    FROM sys.dm_db_task_space_usage
    GROUP BY session_id,
             request_id
) AS t1
    LEFT JOIN sys.dm_exec_requests AS t2
        ON t1.session_id = t2.session_id
           AND t1.request_id = t2.request_id
    LEFT JOIN sys.dm_exec_sessions AS s1
        ON t1.session_id = s1.session_id
-- ignore system unless you suspect there's a problem there
WHERE t1.session_id > 50 
 -- ignore this request itself 
AND t1.session_id <> @@SPID
ORDER BY t1.task_alloc_pages DESC; 
GO

---------------------------------------------------
--find DB name where tempdb queries are running
use tempdb
go

SELECT
    [owt].[session_id],
    [owt].[exec_context_id],
    [owt].[wait_duration_ms],
    [owt].[wait_type],
    [owt].[blocking_session_id],
    [owt].[resource_description],
    CASE [owt].[wait_type]
        WHEN N'CXPACKET' THEN
            RIGHT ([owt].[resource_description],
            CHARINDEX (N'=', REVERSE ([owt].[resource_description])) - 1)
        ELSE NULL
    END AS [Node ID],
    [es].[program_name],
    [est].text,
    [er].[database_id],
    [eqp].[query_plan],
    [er].[cpu_time]
FROM sys.dm_os_waiting_tasks [owt]
INNER JOIN sys.dm_exec_sessions [es] ON
    [owt].[session_id] = [es].[session_id]
INNER JOIN sys.dm_exec_requests [er] ON
    [es].[session_id] = [er].[session_id]
OUTER APPLY sys.dm_exec_sql_text ([er].[sql_handle]) [est]
OUTER APPLY sys.dm_exec_query_plan ([er].[plan_handle]) [eqp]
WHERE
    [es].[is_user_process] = 1
ORDER BY
    [owt].[session_id],
    [owt].[exec_context_id];
GO


----------------
SELECT  COALESCE(T1.session_id, T2.session_id) [session_id] ,        
        T1.request_id ,
        t1.user_id,
        COALESCE(T1.database_id, T2.database_id) [database_id],
        COALESCE(T1.[Total Allocation User Objects], 0)
        + T2.[Total Allocation User Objects] [Total Allocation User Objects] ,
        COALESCE(T1.[Net Allocation User Objects], 0)
        + T2.[Net Allocation User Objects] [Net Allocation User Objects] ,
        COALESCE(T1.[Total Allocation Internal Objects], 0)
        + T2.[Total Allocation Internal Objects] [Total Allocation Internal Objects] ,
        COALESCE(T1.[Net Allocation Internal Objects], 0)
        + T2.[Net Allocation Internal Objects] [Net Allocation Internal Objects] ,
        COALESCE(T1.[Total Allocation], 0) + T2.[Total Allocation] [Total Allocation] ,
        COALESCE(T1.[Net Allocation], 0) + T2.[Net Allocation] [Net Allocation] ,
        COALESCE(T1.[Query Text], T2.[Query Text]) [Query Text]
FROM    ( SELECT    TS.session_id ,
                    TS.request_id ,
                    ER.user_id,
                    TS.database_id ,
                    CAST(TS.user_objects_alloc_page_count / 128 AS DECIMAL(15,
                                                              2)) [Total Allocation User Objects] ,
                    CAST(( TS.user_objects_alloc_page_count
                           - TS.user_objects_dealloc_page_count ) / 128 AS DECIMAL(15,
                                                              2)) [Net Allocation User Objects] ,
                    CAST(TS.internal_objects_alloc_page_count / 128 AS DECIMAL(15,
                                                              2)) [Total Allocation Internal Objects] ,
                    CAST(( TS.internal_objects_alloc_page_count
                           - TS.internal_objects_dealloc_page_count ) / 128 AS DECIMAL(15,
                                                              2)) [Net Allocation Internal Objects] ,
                    CAST(( TS.user_objects_alloc_page_count
                           + internal_objects_alloc_page_count ) / 128 AS DECIMAL(15,
                                                              2)) [Total Allocation] ,
                    CAST(( TS.user_objects_alloc_page_count
                           + TS.internal_objects_alloc_page_count
                           - TS.internal_objects_dealloc_page_count
                           - TS.user_objects_dealloc_page_count ) / 128 AS DECIMAL(15,
                                                              2)) [Net Allocation] ,
                    T.text [Query Text]
          FROM      sys.dm_db_task_space_usage TS
                    INNER JOIN sys.dm_exec_requests ER ON ER.request_id = TS.request_id
                                                          AND ER.session_id = TS.session_id
                    OUTER APPLY sys.dm_exec_sql_text(ER.sql_handle) T
        ) T1
        RIGHT JOIN ( SELECT SS.session_id ,
                            SS.database_id ,
                            CAST(SS.user_objects_alloc_page_count / 128 AS DECIMAL(15,
                                                              2)) [Total Allocation User Objects] ,
                            CAST(( SS.user_objects_alloc_page_count
                                   - SS.user_objects_dealloc_page_count )
                            / 128 AS DECIMAL(15, 2)) [Net Allocation User Objects] ,
                            CAST(SS.internal_objects_alloc_page_count / 128 AS DECIMAL(15,
                                                              2)) [Total Allocation Internal Objects] ,
                            CAST(( SS.internal_objects_alloc_page_count
                                   - SS.internal_objects_dealloc_page_count )
                            / 128 AS DECIMAL(15, 2)) [Net Allocation Internal Objects] ,
                            CAST(( SS.user_objects_alloc_page_count
                                   + internal_objects_alloc_page_count ) / 128 AS DECIMAL(15,
                                                              2)) [Total Allocation] ,
                            CAST(( SS.user_objects_alloc_page_count
                                   + SS.internal_objects_alloc_page_count
                                   - SS.internal_objects_dealloc_page_count
                                   - SS.user_objects_dealloc_page_count )
                            / 128 AS DECIMAL(15, 2)) [Net Allocation] ,
                            T.text [Query Text]
                     FROM   sys.dm_db_session_space_usage SS
                            LEFT JOIN sys.dm_exec_connections CN ON CN.session_id = SS.session_id
                            OUTER APPLY sys.dm_exec_sql_text(CN.most_recent_sql_handle) T
                   ) T2 ON T1.session_id = T2.session_id
WHERE COALESCE(T1.[Total Allocation], 0) + T2.[Total Allocation] > 0
ORDER BY [Total Allocation] DESC