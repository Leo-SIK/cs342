-- Roy Adams
-- CS 342 Quiz

USE AP
GO


-- Create ALog Table if it does not already exist.
IF NOT EXISTS (SELECT * FROM sys.tables
	WHERE name = N'ALog' AND type = 'U')
CREATE TABLE ALog (
	LogID int not null IDENTITY(1,1) PRIMARY KEY,
	TableName varchar(50) not null,
	ReportDate smalldatetime not null,
	NumberOfUpdates int not null
)
GO

-- Alter the invoices table to allow NULL values
ALTER TABLE Invoices
ALTER COLUMN PaymentTotal MONEY NULL

-- Change all invoices with PaymentTotal = 0 for testing purposes
UPDATE Invoices
SET PaymentTotal = NULL
WHERE PaymentTotal = 0

-- Do the update to fix NULL values.
UPDATE Invoices
SET PaymentTotal = 0
WHERE PaymentTotal IS NULL

-- Log the number of changes made
INSERT INTO ALog VALUES ('Invoices', GETDATE(), @@ROWCOUNT)

SELECT * FROM ALog
