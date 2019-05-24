USE AdventureWorks2012
GO

CREATE TRIGGER strga6
ON Person.StateProvince
AFTER
INSERT, UPDATE, DELETE
AS
BEGIN
	IF OBJECT_ID ('stLog') is null
	BEGIN
		CREATE TABLE dbo.stLog(
			changeType char(1),
			timeOfChange datetime,
			changeUser varchar(50),
			[StateProvinceID] [int] NOT NULL,
			[StateProvinceCode] [nchar](3) NOT NULL,
			[CountryRegionCode] [nvarchar](3) NOT NULL,
			[IsOnlyStateProvinceFlag] [dbo].[Flag] NOT NULL,
			[Name] [dbo].[Name] NOT NULL,
			[TerritoryID] [int] NOT NULL,
			[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
			[ModifiedDate] [datetime] NOT NULL
		)
	END

	IF EXISTS(SELECT * FROM DELETED)
	BEGIN
		IF EXISTS(SELECT * FROM INSERTED)
			INSERT INTO stLog SELECT 'U', GETDATE(), SYSTEM_USER, d.* FROM DELETED d
		ELSE
			INSERT INTO stLog SELECT 'D', GETDATE(), SYSTEM_USER, d.* FROM DELETED d
	END
	ELSE
		IF EXISTS(SELECT * FROM INSERTED)
			INSERT INTO stLog SELECT 'I', GETDATE(), SYSTEM_USER, i.* FROM inserted i
END