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


/*CREATE A STORED PROCEDURE TO EXECUTE ABOVE SP IN A LOOP*/
CREATE OR ALTER PROC LoopProc
AS
  BEGIN
      DECLARE @i INT =0

      WHILE ( @i < 100 )
        BEGIN
            EXEC Populatetemptable

            SET @i+=1
        END
  END


/*STRESS TEST SQLSERVER USING OSTRESS - FREE MS TOOL TO TROUBLESHOOT SQL SERVER UNDER HEAVY LOAD*/

/*GENERATE THE WORKLOAD AGAINST THE SERVER.
RUN 25 SIMULTANEOUS CONNECTIONS AND RUNNING THE QUERY 1000 TIMES ON EACH CONNECTION

ostress.exe -S"AV2TESTSQL\SQL2019" -Q"exec dbatest.dbo.loopproc" -n30 -r1000 -q

*/


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


/*ADD MORE TEMPDB DATA FILES*/
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_9', FILENAME = N'T:\MSSQL15.SQL2019\DATA\tempdev_9.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_10', FILENAME = N'T:\MSSQL15.SQL2019\DATA\tempdev_10.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_11', FILENAME = N'T:\MSSQL15.SQL2019\DATA\tempdev_11.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_12', FILENAME = N'T:\MSSQL15.SQL2019\DATA\tempdev_12.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO


ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_13', FILENAME = N'T:\MSSQL15.SQL2019\DATA\tempdev_13.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_14', FILENAME = N'T:\MSSQL15.SQL2019\DATA\tempdev_14.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_15', FILENAME = N'T:\MSSQL15.SQL2019\DATA\tempdev_15.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_16', FILENAME = N'T:\MSSQL15.SQL2019\DATA\tempdev_16.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
