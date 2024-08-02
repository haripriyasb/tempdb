--RESET SCRIPT
USE TEMPDB
GO
declare @count int
select @count=count(*) from sys.database_files where type_desc='ROWS'
print @count
if (@count>8)
begin
print 'running'
DBCC DROPCLEANBUFFERS

DBCC FREEPROCCACHE

DBCC FREESESSIONCACHE

DBCC FREESYSTEMCACHE ( 'ALL')

DBCC SHRINKFILE (tempdev_9, EMPTYFILE);


ALTER DATABASE [tempdb]  REMOVE FILE tempdev_9

DBCC SHRINKFILE (tempdev_10, EMPTYFILE);


ALTER DATABASE [tempdb]  REMOVE FILE tempdev_10

DBCC SHRINKFILE (tempdev_11, EMPTYFILE);

ALTER DATABASE [tempdb]  REMOVE FILE tempdev_11


DBCC SHRINKFILE (tempdev_12, EMPTYFILE);

ALTER DATABASE [tempdb]  REMOVE FILE tempdev_12


DBCC SHRINKFILE (tempdev_13, EMPTYFILE);


ALTER DATABASE [tempdb]  REMOVE FILE tempdev_13


DBCC SHRINKFILE (tempdev_14, EMPTYFILE);


ALTER DATABASE [tempdb]  REMOVE FILE tempdev_14


DBCC SHRINKFILE (tempdev_15, EMPTYFILE);

ALTER DATABASE [tempdb]  REMOVE FILE tempdev_15


DBCC SHRINKFILE (tempdev_16, EMPTYFILE);

ALTER DATABASE [tempdb]  REMOVE FILE tempdev_16

DBCC SHRINKFILE (tempdev_17, EMPTYFILE);

ALTER DATABASE [tempdb]  REMOVE FILE tempdev_17

DBCC SHRINKFILE (tempdev_18, EMPTYFILE);

ALTER DATABASE [tempdb]  REMOVE FILE tempdev_18

DBCC SHRINKFILE (tempdev_19, EMPTYFILE);

ALTER DATABASE [tempdb]  REMOVE FILE tempdev_19

DBCC SHRINKFILE (tempdev_20, EMPTYFILE);

ALTER DATABASE [tempdb]  REMOVE FILE tempdev_20

DBCC SHRINKFILE (tempdev_21, EMPTYFILE);

ALTER DATABASE [tempdb]  REMOVE FILE tempdev_21

DBCC SHRINKFILE (tempdev_22, EMPTYFILE);

ALTER DATABASE [tempdb]  REMOVE FILE tempdev_22

DBCC SHRINKFILE (tempdev_23, EMPTYFILE);

ALTER DATABASE [tempdb]  REMOVE FILE tempdev_23

DBCC SHRINKFILE (tempdev_24, EMPTYFILE);

ALTER DATABASE [tempdb]  REMOVE FILE tempdev_24

SELECT NAME,
       type_desc,
       state_desc,
       physical_name
FROM   tempdb.sys.database_files WHERE type_desc='ROWS'
ORDER BY NAME DESC

end

else 

SELECT NAME,
       type_desc,
       state_desc,
       physical_name
FROM   tempdb.sys.database_files WHERE type_desc='ROWS'
ORDER BY NAME DESC

go 

declare @inmemorytempdb int
set @inmemorytempdb = (SELECT convert(int,SERVERPROPERTY('IsTempDBMetadataMemoryOptimized')))
print @inmemorytempdb
if @inmemorytempdb =1
begin
ALTER SERVER CONFIGURATION SET MEMORY_OPTIMIZED TEMPDB_METADATA=OFF;
print 'restart sql service'
end

SELECT SERVERPROPERTY('IsTempDBMetadataMemoryOptimized') AS IsTempDBMetadataMemoryOptimized; 
GO

/*RESTART SQL SERVICE*/
