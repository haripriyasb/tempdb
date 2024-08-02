
/*VERIFY MEMORY-OPTIMIZED TEMPDB METADATA FEATURE*/
/*NOT ON BY DEFAULT*/
SELECT SERVERPROPERTY('IsTempDBMetadataMemoryOptimized') AS IsTempDBMetadataMemoryOptimized; 
GO


/*ENABLE MEMORY-OPTIMIZED TEMPDB METADATA */
ALTER SERVER CONFIGURATION SET MEMORY_OPTIMIZED TEMPDB_METADATA=ON;
GO

/*WARNING: SERVER RESTART*/

/*THIS CHANGE REQUIRES A SERVER RESTART TO TAKE EFFECT*/
SELECT SERVERPROPERTY('IsTempDBMetadataMemoryOptimized') AS IsTempDBMetadataMemoryOptimized; 
GO

/*CHECK WHICH SYSTEM TABLES HAVE BEEN CONVERTED TO MEMORY-OPTIMIZED*/
USE TEMPDB
GO
SELECT t.[object_id], t.name
  FROM tempdb.sys.all_objects AS t 
  INNER JOIN tempdb.sys.memory_optimized_tables_internal_attributes AS i
  ON t.[object_id] = i.[object_id];
