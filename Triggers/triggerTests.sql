INSERT INTO Person.StateProvince
	(StateProvinceCode, CountryRegionCode, IsOnlyStateProvinceFlag, Name, TerritoryID, rowguid, ModifiedDate)
VALUES ('ABC', 'CA', 0, 'abcland', 1, NEWID(), GETDATE())

UPDATE Person.StateProvince
SET CountryRegionCode = 'US'
WHERE Name = 'abcland'

DELETE Person.StateProvince
WHERE Name = 'abcland'

SELECT * FROM stLog