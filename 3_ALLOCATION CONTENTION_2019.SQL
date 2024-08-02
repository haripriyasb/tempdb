/*VERIFY NUMBER OF TEMPDB DATAFILES*/
USE tempdb
SELECT NAME,
       type_desc,
       state_desc,
       physical_name
FROM   sys.database_files WHERE type_desc='ROWS'


/*ADD MORE TEMPDB DATA FILES*/
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_9', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_9.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_10', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_10.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_11', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_11.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_12', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_12.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO

/*VERIFY NUMBER OF TEMPDB DATAFILES*/
USE tempdb
SELECT NAME,
       type_desc,
       state_desc,
       physical_name
FROM   sys.database_files WHERE type_desc='ROWS'


ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_13', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_13.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_14', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_14.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_15', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_15.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_16', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_16.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO

/*VERIFY NUMBER OF TEMPDB DATAFILES*/
USE tempdb
SELECT NAME,
       type_desc,
       state_desc,
       physical_name
FROM   sys.database_files WHERE type_desc='ROWS'


ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_17', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_17.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_18', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_18.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_19', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_19.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_20', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_20.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO

/*VERIFY NUMBER OF TEMPDB DATAFILES*/
USE tempdb
SELECT NAME,
       type_desc,
       state_desc,
       physical_name
FROM   sys.database_files WHERE type_desc='ROWS'


ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_21', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_21.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_22', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_22.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_23', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_23.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_24', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_24.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO

/*VERIFY NUMBER OF TEMPDB DATAFILES*/
USE tempdb
SELECT NAME,
       type_desc,
       state_desc,
       physical_name
FROM   sys.database_files WHERE type_desc='ROWS'

ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_25', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_25.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_26', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_26.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_27', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_27.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev_28', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\tempdev_28.ndf' , SIZE = 10240MB , FILEGROWTH = 524288KB )
GO
