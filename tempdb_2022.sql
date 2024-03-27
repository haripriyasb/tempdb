/*SQL VERSION*/
SELECT @@VERSION AS 'SQL VERSION'

/*NUMBER OF CPUS IN SERVER*/
SELECT CPU_COUNT FROM sys.dm_os_sys_info

/*NUMBER OF TEMPDB DATAFILES*/
USE tempdb

SELECT NAME,
       type_desc,
       state_desc,
       physical_name
FROM   sys.database_files WHERE type_desc='ROWS'

/*SP TO CREATE INDEX INSIDE OF TABLE DEFINITION */
USE DBATEST
GO
CREATE OR ALTER PROCEDURE PopulateTempTable
AS
BEGIN
/*CREATE A NEW TEMP TABLE*/
CREATE TABLE #TempTable
(
Col1 INT IDENTITY(1, 1) PRIMARY KEY, /*CREATE INDEX INSIDE OF TABLE DEFINITION*/
Col2 CHAR(4000),
Col3 CHAR(4000)
)
/*INSERT 10 DUMMY RECORDS*/ 
DECLARE @i INT = 0
WHILE (@i < 10)
BEGIN
INSERT INTO #TempTable VALUES ('New Stars Of Data','TempDB Discussion')
SET @i += 1
END
END


/*STRESS TEST SQLSERVER USING OSTRESS - FREE MS TOOL TO TROUBLESHOOT SQL SERVER UNDER HEAVY LOAD*/

/*GENERATE THE WORKLOAD AGAINST THE SERVER.
RUN 25 SIMULTANEOUS CONNECTIONS AND RUNNING THE QUERY 1000 TIMES ON EACH CONNECTION

ostress.exe -S"AV2TESTSQL\SQL2022" -Q"exec dbatest.dbo.PopulateTempTable" -n50 -r1000 -q

*/


/*ENABLE MEMORY-OPTIMIZED TEMPDB METADATA */
ALTER SERVER CONFIGURATION SET MEMORY_OPTIMIZED TEMPDB_METADATA=ON;
GO

/*WARNING: SERVER RESTART*/
/*THIS CHANGE REQUIRES A SERVER RESTART TO TAKE EFFECT*/
SELECT SERVERPROPERTY('IsTempDBMetadataMemoryOptimized') AS IsTempDBMetadataMemoryOptimized; 
GO
