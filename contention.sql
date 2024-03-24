/*SQL VERSION*/
SELECT @@VERSION AS 'SQL VERSION'

/*NUMBER OF CPUS IN SERVER*/
SELECT CPU_COUNT FROM sys.dm_os_sys_info

/*RAM*/
SELECT physical_memory_kb/(1024) AS 'OS RAM in MB' FROM sys.dm_os_sys_info;


/*NUMBER OF TEMPDB FILES*/
USE tempdb

SELECT NAME,
       type_desc,
       state_desc,
       physical_name
FROM   sys.database_files 

/*STRESS TEST SQLSERVER USING OSTRESS - FREE MS TOOL TO TROUBLESHOOT SQL SERVER UNDER HEAVY LOAD*/

/*GENERATE THE WORKLOAD AGAINST THE SERVER.
RUN 25 SIMULTANEOUS CONNECTIONS AND RUNNING THE QUERY 1000 TIMES ON EACH CONNECTION

ostress.exe -E -S"AV2TESTSQL\SQL2019" -Q"declare @t table (c1 varchar(100)); insert into @t values('x');" -n25 -r1000 -q
*/

/*ENABLE MEMORY-OPTIMIZED TEMPDB METADATA */
ALTER SERVER CONFIGURATION SET MEMORY_OPTIMIZED TEMPDB_METADATA=ON;
GO

/*WARNING: SERVER RESTART*/
/*THIS CHANGE REQUIRES A SERVER RESTART TO TAKE EFFECT*/
SELECT SERVERPROPERTY('IsTempDBMetadataMemoryOptimized') AS IsTempDBMetadataMemoryOptimized; 
GO

ALTER SERVER CONFIGURATION SET MEMORY_OPTIMIZED TEMPDB_METADATA=OFF;
GO


USE master
GO
SELECT 
er.session_id, er.wait_type, er.wait_resource, 
OBJECT_NAME(page_info.[object_id],page_info.database_id) as [object_name],
er.blocking_session_id,er.command, 
    SUBSTRING(st.text, (er.statement_start_offset/2)+1,   
        ((CASE er.statement_end_offset  
          WHEN -1 THEN DATALENGTH(st.text)  
         ELSE er.statement_end_offset  
         END - er.statement_start_offset)/2) + 1) AS statement_text,
page_info.database_id,page_info.[file_id], page_info.page_id, page_info.[object_id], 
page_info.index_id, page_info.page_type_desc,
CASE 
WHEN page_info.page_type_desc IN('SGAM_PAGE','GAM_PAGE') THEN 'ALLOCATION CONTENTION'
WHEN page_info.page_type_desc IN ('DATA_PAGE', 'INDEX_PAGE') THEN 'METADATA CONTENTION'
END AS allocation_type
FROM sys.dm_exec_requests AS er
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS st 
CROSS APPLY sys.fn_PageResCracker (er.page_resource) AS r  
CROSS APPLY sys.dm_db_page_info(r.[db_id], r.[file_id], r.page_id, 'DETAILED') AS page_info
WHERE er.wait_type like '%page%'
GO


/* ADD TEMPDB DATAFILES, THIS REDUCES ALLOCATION CONTENTION*/
USE [master]
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_2.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_3', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_3.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_4', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_4.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_5', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_5.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_6', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_6.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_7', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev7.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_8', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_8.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_9', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_9.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_10', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_10.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_11', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_11.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_12', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_12.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_13', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_13.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_14', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_14.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_15', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_15.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_16', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_16.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_17', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_17.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_18', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_18.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_19', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_19.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_20', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_20.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
