USE master
GO

IF EXISTS(SELECT * FROM master.sys.databases 
          WHERE name='NewDB')
BEGIN
	DROP DATABASE NewDB
END
CREATE DATABASE NewDB
GO

EXEC sp_addlogin NewUser1, pa7$$wordabvvK, NewDB
EXEC sp_addlogin NewUser2, pa7$$wordabvvK, NewDB
GO

EXEC sp_helplogins
GO

USE NewDB
GO

CREATE USER NewUser1
WITH DEFAULT_SCHEMA = DemoSchema
GO

CREATE USER NewUser2
GO

CREATE ROLE DemoUsers
GO
CREATE SCHEMA DemoUsers AUTHORIZATION DemoUsers
GO
EXEC sp_addrolemember DemoUsers, NewUser1
EXEC sp_addrolemember DemoUsers, NewUser2
EXEC sp_addrolemember db_datareader, DemoUsers
GO

CREATE SCHEMA DemoSchema AUTHORIZATION DemoUsers
GO
SELECT * FROM sys.schemas
GO

CREATE TABLE DemoSchema.DemoTable
	(version varchar(20))
GO

INSERT INTO DemoSchema.DemoTable SELECT 'DemoSchema schema'
GO

CREATE TABLE dbo.DemoTable
	(version varchar(20))
GO

INSERT INTO dbo.DemoTable SELECT 'DBO schema'
GO

GRANT CREATE TABLE TO DemoUsers
GO

