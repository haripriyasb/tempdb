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
WHEN page_info.page_type_desc IN('SGAM_PAGE','GAM_PAGE', 'PFS_PAGE') 
AND WAIT_TYPE IN ('PAGELATCH_SH','PAGELATCH_UP','PAGELATCH_EX')THEN 'ALLOCATION CONTENTION'
WHEN page_info.page_type_desc IN ('DATA_PAGE', 'INDEX_PAGE') 
AND WAIT_TYPE IN ('PAGELATCH_SH','PAGELATCH_UP','PAGELATCH_EX')THEN 'METADATA CONTENTION'
END AS allocation_type
FROM sys.dm_exec_requests AS er
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS st 
CROSS APPLY sys.fn_PageResCracker (er.page_resource) AS r  
CROSS APPLY sys.dm_db_page_info(r.[db_id], r.[file_id], r.page_id, 'DETAILED') AS page_info
WHERE er.wait_type like '%page%'
GO