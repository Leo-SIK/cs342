-- Roy Adams
-- Sheep HW

USE master
GO

CREATE DATABASE sheep
GO

USE sheep
GO

CREATE SCHEMA ActiveHerd
GO

CREATE TABLE [ActiveHerd].[breed]
	(BreedCategory		VARCHAR(50)		NOT NULL PRIMARY KEY,
	BreedDescription	VARCHAR(200)	NULL
	)
GO
CREATE TABLE [ActiveHerd].[shotList]
	(ShotType		VARCHAR(50)		NOT NULL PRIMARY KEY,
	shotDescription	VARCHAR(200)	NULL,
	dayCycle		VARCHAR(50)		NOT NULL
	)
GO
CREATE TABLE [ActiveHerd].[injectionList]
	(InjectionType			VARCHAR(50)		NOT NULL PRIMARY KEY,
	injectionDescription	VARCHAR(200)	NULL
	)
GO
CREATE TABLE [ActiveHerd].[shepherd]
	(ShepherdId				INT			NOT NULL IDENTITY PRIMARY KEY,
	LastName				VARCHAR(50)	NOT NULL,
	FirstName				VARCHAR(50)	NOT NULL,
	ShepherdCertification	VARCHAR(50)	NOT NULL
	)
GO
CREATE TABLE [ActiveHerd].[sheep]
	(IdNumber		INT			NOT NULL IDENTITY PRIMARY KEY,
	SheepName		VARCHAR(50)	NOT NULL,
	BreedCategory	VARCHAR(50)	NOT NULL,
	Gender			VARCHAR(1)	NOT NULL,
	ShepherdId		INT			NOT NULL,
	)
GO
CREATE TABLE [ActiveHerd].[sheepShots]
	(IdNumber		INT			NOT NULL,
	ShotType		VARCHAR(50)	NOT NULL,
	ShotDate		DATETIME	NOT NULL,
	InjectionType	VARCHAR(50)	NOT NULL,
	PRIMARY KEY (IdNumber, ShotType, ShotDate)
	)
GO

ALTER TABLE [ActiveHerd].[sheep]
ADD FOREIGN KEY (BreedCategory) REFERENCES [ActiveHerd].[breed](BreedCategory);
GO
ALTER TABLE [ActiveHerd].[sheep]
ADD FOREIGN KEY (ShepherdId) REFERENCES [ActiveHerd].[shepherd](ShepherdId);
GO
ALTER TABLE [ActiveHerd].[sheepShots]
ADD FOREIGN KEY (IdNumber) REFERENCES [ActiveHerd].[sheep](IdNumber);
GO
ALTER TABLE [ActiveHerd].[sheepShots]
ADD FOREIGN KEY (ShotType) REFERENCES [ActiveHerd].[shotList](ShotType);
GO
ALTER TABLE [ActiveHerd].[sheepShots]
ADD FOREIGN KEY (InjectionType) REFERENCES [ActiveHerd].[injectionList](InjectionType);
GO

INSERT INTO [ActiveHerd].breed
VALUES
	('White', 'The wool on this sheep is white.'),
	('Brown', 'The wool on this sheep is brown.'),
	('Black', 'The wool on this sheep is black.');
GO
INSERT INTO [ActiveHerd].shotList
VALUES
	('A', 'HPV shot', 'Noon'),
	('B', 'HIV shot', 'Midnight'),
	('C', 'Measles shot', '2AM');
GO
INSERT INTO [ActiveHerd].injectionList
VALUES
	('O', 'Oral Injection'),
	('G', 'Gut Injection'),
	('R', 'Rear Injection');
GO
INSERT INTO [ActiveHerd].shepherd
VALUES
	('McDonald', 'Old', 'Certified'),
	('King', 'David', 'Certified'),
	('Coyote', 'Wile E.', 'Not Certified');
GO
INSERT INTO [ActiveHerd].sheep
VALUES
	('Shadrach', 'White', 'M', 2),
	('Meeshach', 'Black', 'M', 2),
	('Abednego', 'Black', 'M', 1);
GO
insert into [ActiveHerd].[sheepShots] (
    idNumber
    , ShotType
    , ShotDate
    , InjectionType)
        SELECT s.idNumber
        , h.ShotType
        ,getdate() 
        ,(SELECT InjectionType From [ActiveHerd].InjectionList 
            Where InjectionDescription = 'Oral Injection')
        FROM [ActiveHerd].sheep s, [ActiveHerd].shotlist h;  
        --Product of only sheep and shotlist
GO

UPDATE [ActiveHerd].sheepShots
SET ShotDate = '2018-02-3'
GO

SELECT * FROM ActiveHerd.breed

SELECT * FROM ActiveHerd.injectionList

SELECT * FROM ActiveHerd.sheep

SELECT * FROM ActiveHerd.sheepShots

SELECT * FROM ActiveHerd.shepherd

SELECT * FROM ActiveHerd.shotList
GO

-- 12. DELETE ActiveHerd.sheep
-- Was unable to delete sheep from sheep table, as foreign key references cannot be deleted.

DELETE ActiveHerd.sheepShots
GO
DELETE ActiveHerd.sheep
GO
DELETE ActiveHerd.shepherd
GO

DROP TABLE [ActiveHerd].[sheepShots]
GO
DROP TABLE [ActiveHerd].[sheep]
GO
DROP TABLE [ActiveHerd].[breed]
GO
DROP TABLE [ActiveHerd].[injectionList]
GO
DROP TABLE [ActiveHerd].[shotList]
GO
DROP TABLE [ActiveHerd].[shepherd]
GO

USE master
GO

DROP DATABASE sheep
GO