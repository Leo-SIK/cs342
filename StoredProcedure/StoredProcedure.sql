-- Roy Adams
-- CS 342 Script and Stored Procedures

USE AdventureWorks2012
GO

CREATE OR ALTER PROCEDURE dbStats
	@inputRate float,
	@numberOfSigChanges int = 0 OUT
AS
BEGIN
BEGIN TRY
	DECLARE @tableName varchar(50)
	DECLARE @tableRows int
	DECLARE @growthRate float
	DECLARE @oldRows int

	IF NOT EXISTS (SELECT * FROM sys.tables
		WHERE name = N'tableStatus' and type = 'U')
	CREATE TABLE tableStatus (
		tableName varchar(50) NOT NULL,
		checkDate datetime NOT NULL,
		numberOfRows int NOT NULL,
		rateCheckValue float NULL,
		fastGrowth int NOT NULL,
		CONSTRAINT PK_tableStatus PRIMARY KEY (tableName, checkDate)
	)
	
	DECLARE Status_Cursor CURSOR
	FOR
		SELECT Name, SUM(Rows)
		FROM (
			SELECT DISTINCT t.name AS Name
				, i.rows AS Rows
			FROM sys.tables t
			INNER JOIN sys.sysindexes i
				ON t.object_id = i.id ) sub
		GROUP BY Name;

	OPEN Status_Cursor;

	FETCH NEXT FROM Status_Cursor INTO @tableName, @tableRows;
	WHILE @@FETCH_STATUS <> -1
		BEGIN
			-- Check if there is a row for the table yet
			IF EXISTS (SELECT * FROM tableStatus
					WHERE tableName = @tableName)
			BEGIN
				-- Find the growth rate from the previous date to now
				SET @oldRows = (SELECT numberOfRows FROM 
					(SELECT numberOfRows, checkDate FROM tableStatus
						WHERE tableName = @tableName) sub
					WHERE checkDate = (SELECT MAX(checkDate) FROM tableStatus
						WHERE tableName = @tableName))

				IF @tableRows != 0 AND @oldRows != 0
					IF @oldRows = @tableRows
						SET @growthRate = 0;
					ELSE
						SET @growthRate = (1.0 * @tableRows) / (1.0 * @oldRows) - 1;
				ELSE
					IF @oldRows = 0
						SET @growthRate = 0;
					ELSE
						SET @growthRate = -1;

				-- Insert the new status into the table
				INSERT INTO tableStatus
					(tableName, checkDate, numberOfRows, rateCheckValue, fastGrowth)
				VALUES (
					@tableName,
					SYSDATETIME(),
					@tableRows,
					@inputRate,
					(CASE WHEN @growthRate >= @inputRate THEN 1
							WHEN @growthRate <= -1 * @inputRate THEN -1
							ELSE 0 END)
				)

				-- If the growth is significant (above the input rate)
				-- then increase the output variable
				IF (@growthRate >= @inputRate OR @growthRate <= -1 * @inputRate)
					SET @numberOfSigChanges += 1;
			END
			ELSE -- The table has not been entered yet
			BEGIN
				INSERT INTO tableStatus
					(tableName, checkDate, numberOfRows, rateCheckValue, fastGrowth)
				VALUES (
					@tableName,
					SYSDATETIME(),
					@tableRows,
					@inputRate,
					0
				)
			END
			-- Go to next table
			FETCH NEXT FROM Status_Cursor INTO @tableName, @tableRows;
		END
	
	CLOSE Status_Cursor;
	DEALLOCATE Status_Cursor;
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS Number,
		ERROR_SEVERITY() AS Severity,
		ERROR_STATE() AS State,
		ERROR_PROCEDURE() AS procedureName,
		ERROR_LINE() AS Line,
		ERROR_MESSAGE() AS messageText;
		CLOSE Status_Cursor;
		DEALLOCATE Status_Cursor;
END CATCH
END
GO

-- TESTS
-- NOTE: For these tests I inserted into the HumanResources.Department table
--			and left other tables unchanged.

-- First insert into table
EXEC dbo.dbStats 0.10;
GO

-- Insert new value into department table
INSERT INTO HumanResources.Department
	(Name, GroupName, ModifiedDate)
VALUES (
	'Conspiracy Theories', 
	'Research and Development',
	SYSDATETIME()
)

-- Check if insert registered
EXEC dbo.dbStats 0.001;
GO

-- Delete value from department table
DELETE FROM HumanResources.Department
WHERE Name = 'Conspiracy Theories'

-- Check if delete registered
EXEC dbo.dbStats 0.001;
GO

SELECT * FROM tableStatus

