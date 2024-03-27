
/*CREATE A NEW STORED PROCEDURE*/
USE DBATEST
GO
CREATE OR ALTER PROCEDURE PopulateTempTable
AS
BEGIN
/*CREATE A NEW TEMP TABLE*/
CREATE TABLE #TempTable
(
Col1 INT IDENTITY(1, 1),
Col2 CHAR(4000),
Col3 CHAR(4000)
)
/*CREATE A UNIQUE CLUSTERED INDEX ON THE TEMP TABLE OUTSIDE OF THE TABLE DEFINITION*/
CREATE UNIQUE CLUSTERED INDEX idx_c1 ON #TempTable(Col1)
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


/*EXECUTE LoopProc SP */
SET NOCOUNT ON
DECLARE @j INT = 0
WHILE (@j < 10)
BEGIN

DECLARE @table_counter_before_test BIGINT;
SELECT @table_counter_before_test = cntr_value FROM sys.dm_os_performance_counters
WHERE counter_name = 'Temp Tables Creation Rate'
DECLARE @i INT = 0
WHILE (@i < 10)
BEGIN
EXEC dbaadmin.dbo.loopproc
SET @i += 1
END
DECLARE @table_counter_after_test BIGINT;
SELECT @table_counter_after_test = cntr_value FROM sys.dm_os_performance_counters
WHERE counter_name = 'Temp Tables Creation Rate'
PRINT 'Temp tables created during the test: ' + CONVERT(VARCHAR(100), @table_counter_after_test - @table_counter_before_test)

SET @j += 1
END


