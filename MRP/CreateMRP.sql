-- Creates a new database: MRP
-- Roy Adams
USE master
GO

IF EXISTS(select * from sys.databases where name='MRP')
DROP DATABASE MRP

CREATE DATABASE MRP;
GO

USE MRP
GO

CREATE TABLE Address (
	AddressID int IDENTITY(1,1) not null PRIMARY KEY,
	StreetAddress varchar(50) not null,
	City varchar(50) not null,
	State varchar(50) not null,
	Country varchar(50) not null,
	PostalCode varchar(10) not null
)
GO

CREATE TABLE Vendors (
	VendorID int IDENTITY(1,1) not null PRIMARY KEY,
	VendorName varchar(50) not null,
	ContactPerson varchar(50) null,
	PhoneNumber varchar(50) null,
	VendorAddressID int not null FOREIGN KEY REFERENCES Address(AddressID),
	VendorRating varchar(5) not null --DEFAULT 'A' 
)
GO

CREATE TABLE Parts (
	PartID int IDENTITY(1,1) not null PRIMARY KEY,
	PartName varchar(50) not null,
	PartDescription varchar(200) null,
	PartType varchar(50) not null,
	PartCost money not null,
	VendorID int null FOREIGN KEY REFERENCES Vendors(VendorID),
	EconomicOrderQty int null,
	SafetyStock int null,
	OnHandMax int null,
	OrderLeadTime int null,
	PartIllustration varbinary(max) null
)
GO

CREATE TABLE Resources (
	ResourceID int IDENTITY(1,1) not null PRIMARY KEY,
	ResourceName varchar(50) not null,
	ResourceStatus varchar(50) not null,
	MaintainanceDescription varchar(200) null,
	ReplacementDate date null
)
GO

CREATE TABLE BillOfMaterials (
	BillOfMaterialsID int IDENTITY(1,1) not null PRIMARY KEY,
	ProductAssemblyID int null FOREIGN KEY REFERENCES Parts(PartID),
	ComponentID int not null FOREIGN KEY REFERENCES Parts(PartID)
)
GO

CREATE INDEX idx_bom
ON BillOfMaterials (ProductAssemblyID, ComponentID);
GO

CREATE TABLE Credit (
	CreditID int IDENTITY(1,1) not null PRIMARY KEY,
	AccountNumber varchar(50) not null,
	CurrentBalance money not null
)
GO

CREATE INDEX idx_accnum
ON Credit (AccountNumber);
GO

CREATE TABLE Customer (
	CustomerID int IDENTITY(1,1) not null PRIMARY KEY,
	CustomerName varchar(50) not null,
	BillingAddressID int not null FOREIGN KEY REFERENCES Address(AddressID),
	ShippingAddressID int not null FOREIGN KEY REFERENCES Address(AddressID),
	CreditID int not null FOREIGN KEY REFERENCES Credit(CreditID)
)
GO

CREATE TABLE CustomerOrders (
	OrderID int IDENTITY(1,1) not null PRIMARY KEY,
	CustomerID int not null FOREIGN KEY REFERENCES Customer(CustomerID),
	ProductID int not null FOREIGN KEY REFERENCES Parts(PartID),
	Quantity int not null,
	DateAvailable date not null,
	OrderDate date not null,
	SplitShipments bit not null,
	Shipped bit not null
)
GO

CREATE INDEX idx_custid
ON CustomerOrders (CustomerID);
GO

CREATE TABLE VendorOrders (
	OrderID int IDENTITY(1,1) not null PRIMARY KEY,
	VendorID int not null FOREIGN KEY REFERENCES Vendors(VendorID),
	ProductID int not null FOREIGN KEY REFERENCES Parts(PartID),
	QuantityOrdered int not null,
	QuantityReceived int not null,
	OrderDate date not null,
	OrderStatus varchar(50) not null
)
GO

CREATE INDEX idx_venid
ON VendorOrders (VendorID);
GO

CREATE TABLE JobOrders (
	OrderID int IDENTITY(1,1) not null PRIMARY KEY,
	ProductID int not null FOREIGN KEY REFERENCES Parts(PartID),
	SerialNumber varchar(50) not null,
	OrderDate date not null,
	Completed bit not null,
	Quantity int not null
)
GO

CREATE TABLE Inventory (
	InventoryID int IDENTITY(1,1) not null PRIMARY KEY,
	ProductID int not null FOREIGN KEY REFERENCES Parts(PartID),
	InventoryLane int not null,
	InventoryRow char not null,
	InventoryBin int not null,
	Quantity int not null
)
GO

CREATE OR ALTER PROCEDURE spInsertVendor
	@VendorName varchar(50),
	@ContactPerson varchar(50),
	@PhoneNumber varchar(50),
	@VendorAddressID int,
	@VendorRating varchar(5)
AS
BEGIN
	INSERT INTO Vendors (VendorName, ContactPerson, PhoneNumber, VendorAddressID, VendorRating)
	VALUES (@VendorName, @ContactPerson, @PhoneNumber, @VendorAddressID, @VendorRating)
END
GO

CREATE OR ALTER PROCEDURE spInsertAddress
	@StreetAddress varchar(50),
	@City varchar(50),
	@State varchar(50),
	@Country varchar(50),
	@PostalCode varchar(10)
AS
BEGIN
	INSERT INTO Address (StreetAddress, City, State, Country, PostalCode)
	VALUES (@StreetAddress, @City, @State, @Country, @PostalCode)
END
GO

CREATE OR ALTER PROCEDURE spChangePartVendor
	@PartID int,
	@VendorID int
AS
BEGIN
	UPDATE Parts
	SET VendorID = @vendorID
	WHERE PartID = @partID
END
GO

CREATE OR ALTER PROCEDURE spSelectAddressID
	@StreetAddress varchar(50),
	@City varchar(50),
	@State varchar(50),
	@Country varchar(50),
	@PostalCode varchar(10)
AS
BEGIN
	select AddressID from address
	where StreetAddress = @StreetAddress and City = @City 
		and State = @State and Country = @Country and PostalCode = @PostalCode
END
GO

CREATE OR ALTER PROCEDURE spSelectVendorID
	@VendorName varchar(50),
	@ContactPerson varchar(50),
	@PhoneNumber varchar(50),
	@VendorAddressID varchar(50),
	@VendorRating varchar(10)
AS
BEGIN
	select VendorID from Vendors
	where VendorName = @VendorName and ContactPerson = @ContactPerson 
		and PhoneNumber = @PhoneNumber and VendorAddressID = @VendorAddressID and VendorRating = @VendorRating
END
GO

CREATE OR ALTER PROCEDURE spSelectParts
AS
BEGIN
	select PartID, PartName from Parts
END
GO

-- TESTS
/*
INSERT INTO Address
VALUES ('22 Main Street', 'New York', 'New York', 'USA', '44444')

EXEC spInsertAddress '23 Burton Street', 'Denver', 'Colorado', 'USA', '12345'

EXEC spSelectAddressID '23 Burton Street', 'Denver', 'Colorado', 'USA', '12345'

INSERT INTO Vendors
VALUES ('Vendor0', 'Phil Collins', '232-232-2323', (SELECT AddressID FROM Address WHERE PostalCode = '44444'), 'A')

DECLARE @addr int
SET @addr = (SELECT AddressID FROM Address WHERE PostalCode = '12345')

EXEC spInsertVendor 'Vendor1', 'Joe Bob', '343-343-3434', @addr, 'AA'

SELECT * FROM Address

SELECT * FROM Vendors
INNER JOIN Address 
	ON Vendors.VendorAddressID = Address.AddressID

DECLARE @vndr1 int
SET @vndr1 = (SELECT VendorID FROM Vendors WHERE VendorName = 'Vendor0')

DECLARE @vndr2 int
SET @vndr2 = (SELECT VendorID FROM Vendors WHERE VendorName = 'Vendor1')

INSERT INTO Parts (PartName, PartDescription, PartType, PartCost, VendorID)
VALUES ('Part1', 'Desc1', 1, 2.3, @vndr1)

DECLARE @prt int
SET @prt = (SELECT PartID FROM Parts)

SELECT * FROM Parts

EXEC spChangePartVendor @prt, @vndr2

SELECT * FROM Parts

DELETE FROM Parts
DELETE FROM Vendors
DELETE FROM Address

*/