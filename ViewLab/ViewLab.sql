-- Roy Adams
-- CS 342 Views Lab

-- 1. 
/*
The CASCADE keyword is used to assist in deleting or updating tables. If it is used ON DELETE, then whenever
the specified key is deleted any references on a different table is also deleted. If it is used ON UPDATE, then
if the key is updated any references on another table is also updated.
*/

-- Setup
USE AP
GO

-- 2.
CREATE TABLE InvoiceLineItemArchive(
	InvoiceID int NOT NULL,
	InvoiceSequence smallint NOT NULL,
	AccountNo int NOT NULL,
	InvoiceLineItemAmount money NOT NULL,
	InvoiceLineItemDescription varchar(100) NOT NULL,
CONSTRAINT PK_InvoiceLineItemArchive PRIMARY KEY CLUSTERED (
	InvoiceID ASC,
	InvoiceSequence ASC
 ) 
)

ALTER TABLE InvoiceArchive
WITH NOCHECK ADD CONSTRAINT PK_InvoiceArchive
PRIMARY KEY (InvoiceID)
GO

ALTER TABLE InvoiceLineItemArchive  
WITH NOCHECK ADD  CONSTRAINT FK_InvoiceLineItemArchive_GLAccounts 
FOREIGN KEY(AccountNo)
REFERENCES GLAccounts (AccountNo)
ON UPDATE CASCADE
GO

ALTER TABLE InvoiceLineItemArchive
CHECK CONSTRAINT FK_InvoiceLineItemArchive_GLAccounts
GO

ALTER TABLE InvoiceLineItemArchive  
WITH NOCHECK 
ADD CONSTRAINT FK_InvoiceLineItemArchive_Invoices 
FOREIGN KEY(InvoiceID)
REFERENCES InvoiceArchive (InvoiceID)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE InvoiceLineItemArchive 
CHECK CONSTRAINT FK_InvoiceLineItemArchive_Invoices
GO

INSERT INTO InvoiceArchive
SELECT *
FROM Invoices i
WHERE i.InvoiceTotal - i.PaymentTotal = 0

INSERT INTO InvoiceLineItemArchive
SELECT ili.*
FROM Invoices i
INNER JOIN InvoiceLineItems ili
	ON i.InvoiceID = ili.InvoiceID
WHERE i.InvoiceTotal - i.PaymentTotal = 0

DELETE i
FROM Invoices i
WHERE i.InvoiceTotal - i.PaymentTotal = 0
GO

-- 3.
CREATE VIEW vAllInvoices AS
SELECT 'A' AS 'Invoice Status'
	, i.InvoiceID
	, ili.InvoiceSequence AS 'Item Number'
	, v.VendorName
	, i.InvoiceTotal
	, i.InvoiceDueDate
	, t.TermsDescription
	, ili.InvoiceLineItemDescription
FROM Invoices i
INNER JOIN Vendors v
	ON v.VendorID = i.VendorID
INNER JOIN InvoiceLineItems ili
	ON i.InvoiceID = ili.InvoiceID
INNER JOIN Terms t
	ON v.DefaultTermsID = t.TermsID
UNION
SELECT 'C' AS 'Invoice Status'
	, ia.InvoiceID
	, ilia.InvoiceSequence AS 'Item Number'
	, v.VendorName
	, ia.InvoiceTotal
	, ia.InvoiceDueDate
	, t.TermsDescription
	, ilia.InvoiceLineItemDescription
FROM InvoiceArchive ia
INNER JOIN Vendors v
	ON v.VendorID = ia.VendorID
INNER JOIN InvoiceLineItemArchive ilia
	ON ia.InvoiceID = ilia.InvoiceID
INNER JOIN Terms t
	ON v.DefaultTermsID = t.TermsID
GO

-- 3 (b?).
/* DELETE FROM vAllInvoices
Delete does not work because it requires the view to have only one base table.
INSERT INTO vAllInvoices
VALUES ('C', 1111, 1, 'SQL', 22, '2008-11-11', 'Terms', 'LI Description');
Update or insert failed because it contains a derived or constant field.
*/

-- 4.
USE AdventureWorks2012
GO

-- 5.
CREATE VIEW vRetirement AS
SELECT COUNT(*) AS 'Number of Qualified'
	, 120000 * COUNT(*) AS 'Total Cost'
FROM HumanResources.Employee e
WHERE DATEDIFF(year, e.BirthDate, GETDATE()) >= 52
GO

-- 6.
CREATE VIEW vPayHistMore AS
SELECT e.BusinessEntityID
	, e.LoginID
	, MAX(eph.Rate) AS 'Highest Pay Rate'
	, COUNT(*) AS 'Pay Changes'
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeePayHistory eph
	ON e.BusinessEntityID = eph.BusinessEntityID
GROUP BY e.BusinessEntityID, e.LoginID
GO

-- 7.
CREATE VIEW vHRempList AS
SELECT e.LoginID
	, a.AddressLine1 + ', ' + a.City + ', ' + sp.StateProvinceCode AS 'Address'
FROM HumanResources.Employee e
INNER JOIN Person.BusinessEntityAddress bea
	ON e.BusinessEntityID = bea.BusinessEntityID
INNER JOIN Person.Address a
	ON bea.AddressID = a.AddressID
INNER JOIN PERSON.StateProvince sp
	ON a.StateProvinceID = sp.StateProvinceID
GO

-- 8.
CREATE VIEW VMultipleAddresses AS
SELECT COUNT(*) AS 'Number of Employees'
	, a.City
	, sp.StateProvinceCode
FROM HumanResources.Employee e
INNER JOIN Person.BusinessEntityAddress bea
	ON e.BusinessEntityID = bea.BusinessEntityID
INNER JOIN Person.Address a
	ON bea.AddressID = a.AddressID
INNER JOIN PERSON.StateProvince sp
	ON a.StateProvinceID = sp.StateProvinceID
GROUP BY a.City, sp.StateProvinceCode
GO

-- 9. CLEAN UP
DROP VIEW vPayHistMore
DROP VIEW vHRempList
DROP VIEW vRetirement
DROP VIEW VMultipleAddresses

USE master
GO

DROP DATABASE AP

USE master
GO

/****** Object:  Database AP     ******/
IF DB_ID('AP') IS NOT NULL
	DROP DATABASE AP
GO

CREATE DATABASE AP
GO 

USE AP
GO

/****** Object:  Table ContactUpdates  ******/   
CREATE TABLE ContactUpdates(
	VendorID int IDENTITY(1,1) NOT NULL,
	LastName varchar(50) NULL,
	FirstName varchar(50) NULL
)
GO

/****** Object:  Table GLAccounts     ******/
CREATE TABLE GLAccounts(
	AccountNo int NOT NULL,
	AccountDescription varchar(50) NOT NULL,
 CONSTRAINT PK_GLAccounts PRIMARY KEY CLUSTERED (
	AccountNo ASC
 )
)
GO

/****** Object:  Table InvoiceArchive     ******/
CREATE TABLE InvoiceArchive(
	InvoiceID int NOT NULL,
	VendorID int NOT NULL,
	InvoiceNumber varchar(50) NOT NULL,
	InvoiceDate smalldatetime NOT NULL,
	InvoiceTotal money NOT NULL,
	PaymentTotal money NOT NULL,
	CreditTotal money NOT NULL,
	TermsID int NOT NULL,
	InvoiceDueDate smalldatetime NOT NULL,
	PaymentDate smalldatetime NULL
) 
GO

/****** Object:  Table InvoiceLineItems     ******/
CREATE TABLE InvoiceLineItems(
	InvoiceID int NOT NULL,
	InvoiceSequence smallint NOT NULL,
	AccountNo int NOT NULL,
	InvoiceLineItemAmount money NOT NULL,
	InvoiceLineItemDescription varchar(100) NOT NULL,
CONSTRAINT PK_InvoiceLineItems PRIMARY KEY CLUSTERED (
	InvoiceID ASC,
	InvoiceSequence ASC
 ) 
)
GO

/****** Object:  Table Invoices     ******/
CREATE TABLE Invoices(
	InvoiceID int IDENTITY(1,1) NOT NULL,
	VendorID int NOT NULL,
	InvoiceNumber varchar(50) NOT NULL,
	InvoiceDate smalldatetime NOT NULL,
	InvoiceTotal money NOT NULL,
	PaymentTotal money NOT NULL,
	CreditTotal money NOT NULL,
	TermsID int NOT NULL,
	InvoiceDueDate smalldatetime NOT NULL,
	PaymentDate smalldatetime NULL,
 CONSTRAINT PK_Invoices PRIMARY KEY CLUSTERED (
	InvoiceID ASC
 )
)
GO

/****** Object:  Table Terms    ******/
CREATE TABLE Terms(
	TermsID int IDENTITY(1,1) NOT NULL,
	TermsDescription varchar(50) NOT NULL,
	TermsDueDays smallint NOT NULL,
 CONSTRAINT PK_Terms PRIMARY KEY CLUSTERED (
	TermsID ASC
 )
) 
GO

/****** Object:  Table Vendors    ******/
CREATE TABLE Vendors(
	VendorID int IDENTITY(1,1) NOT NULL,
	VendorName varchar(50) NOT NULL,
	VendorAddress1 varchar(50) NULL,
	VendorAddress2 varchar(50) NULL,
	VendorCity varchar(50) NOT NULL,
	VendorState char(2) NOT NULL,
	VendorZipCode varchar(20) NOT NULL,
	VendorPhone varchar(50) NULL,
	VendorContactLName varchar(50) NULL,
	VendorContactFName varchar(50) NULL,
	DefaultTermsID int NOT NULL,
	DefaultAccountNo int NOT NULL,
 CONSTRAINT PK_Vendors PRIMARY KEY CLUSTERED(
	VendorID ASC
 )
) 
GO

SET IDENTITY_INSERT ContactUpdates ON 
INSERT ContactUpdates (VendorID, LastName, FirstName) VALUES 
(5, 'Davison', 'Michelle'),
(12, 'Mayteh', 'Kendall'),
(17, 'Onandonga', 'Bruce'),
(44, 'Antavius', 'Anthony'),
(76, 'Bradlee', 'Danny'),
(94, 'Suscipe', 'Reynaldo'),
(101, 'O''Sullivan', 'Geraldine'),
(123, 'Bucket', 'Charles')
SET IDENTITY_INSERT ContactUpdates OFF
GO

INSERT GLAccounts (AccountNo, AccountDescription) VALUES
(100, 'Cash'),
(110, 'Accounts Receivable'),
(120, 'Book Inventory'),
(150, 'Furniture'),
(160, 'Computer Equipment'),
(162, 'Capitalized Lease'),
(167, 'Software'),
(170, 'Other Equipment'),
(181, 'Book Development'),
(200, 'Accounts Payable'),
(205, 'Royalties Payable'),
(221, '401K Employee Contributions'),
(230, 'Sales Taxes Payable'),
(234, 'Medicare Taxes Payable'),
(235, 'Income Taxes Payable'),
(237, 'State Payroll Taxes Payable'),
(238, 'Employee FICA Taxes Payable'),
(239, 'Employer FICA Taxes Payable'),
(241, 'Employer FUTA Taxes Payable'),
(242, 'Employee SDI Taxes Payable'),
(243, 'Employer UCI Taxes Payable'),
(251, 'IBM Credit Corporation Payable'),
(280, 'Capital Stock'),
(290, 'Retained Earnings'),
(300, 'Retail Sales'),
(301, 'College Sales'),
(302, 'Trade Sales'),
(306, 'Consignment Sales'),
(310, 'Compositing Revenue'),
(394, 'Book Club Royalties'),
(400, 'Book Printing Costs'),
(403, 'Book Production Costs'),
(500, 'Salaries and Wages'),
(505, 'FICA'),
(506, 'FUTA'),
(507, 'UCI'),
(508, 'Medicare'),
(510, 'Group Insurance'),
(520, 'Building Lease'),
(521, 'Utilities'),
(522, 'Telephone'),
(523, 'Building Maintenance'),
(527, 'Computer Equipment Maintenance'),
(528, 'IBM Lease'),
(532, 'Equipment Rental'),
(536, 'Card Deck Advertising'),
(540, 'Direct Mail Advertising'),
(541, 'Space Advertising'),
(546, 'Exhibits and Shows'),
(548, 'Web Site Production and Fees'),
(550, 'Packaging Materials'),
(551, 'Business Forms'),
(552, 'Postage'),
(553, 'Freight'),
(555, 'Collection Agency Fees'),
(556, 'Credit Card Handling'),
(565, 'Bank Fees'),
(568, 'Auto License Fee'),
(569, 'Auto Expense'),
(570, 'Office Supplies'),
(572, 'Books, Dues, and Subscriptions'),
(574, 'Business Licenses and Taxes'),
(576, 'PC Software'),
(580, 'Meals'),
(582, 'Travel and Accomodations'),
(589, 'Outside Services'),
(590, 'Business Insurance'),
(591, 'Accounting'),
(610, 'Charitable Contributions'),
(611, 'Profit Sharing Contributions'),
(620, 'Interest Paid to Banks'),
(621, 'Other Interest'),
(630, 'Federal Corporation Income Taxes'),
(631, 'State Corporation Income Taxes'),
(632, 'Sales Tax')
GO

INSERT InvoiceLineItems (InvoiceID, InvoiceSequence, AccountNo, InvoiceLineItemAmount, InvoiceLineItemDescription) VALUES 
(1, 1, 553, 3813.3300, 'Freight'),
(2, 1, 553, 40.2000, 'Freight'),
(3, 1, 553, 138.7500, 'Freight'),
(4, 1, 553, 144.7000, 'Int''l shipment'),
(5, 1, 553, 15.5000, 'Freight'),
(6, 1, 553, 42.7500, 'Freight'),
(7, 1, 553, 172.5000, 'Freight'),
(8, 1, 522, 95.0000, 'Telephone service'),
(9, 1, 403, 601.9500, 'Cover design'),
(10, 1, 553, 42.6700, 'Freight'),
(11, 1, 553, 42.5000, 'Freight'),
(12, 1, 580, 50.0000, 'DiCicco''s'),
(12, 2, 570, 75.6000, 'Kinko''s'),
(12, 3, 570, 58.4000, 'Office Max'),
(12, 4, 540, 478.0000, 'Publishers Marketing'),
(13, 1, 522, 16.3300, 'Telephone (line 5)'),
(14, 1, 553, 6.0000, 'Freight out'),
(15, 1, 574, 856.9200, 'Property Taxes'),
(16, 1, 572, 9.9500, 'Monthly access fee'),
(17, 1, 553, 10.0000, 'Address correction'),
(18, 1, 553, 104.0000, 'Freight'),
(19, 1, 160, 116.5400, 'MVS Online Library'),
(20, 1, 553, 6.0000, 'Freight out'),
(21, 1, 589, 4901.2600, 'Office lease'),
(22, 1, 553, 108.2500, 'Freight'),
(23, 1, 572, 9.9500, 'Monthly access fee'),
(24, 1, 520, 1750.0000, 'Warehouse lease'),
(25, 1, 553, 129.0000, 'Freight'),
(26, 1, 553, 10.0000, 'Freight'),
(27, 1, 540, 207.7800, 'Prospect list'),
(28, 1, 553, 109.5000, 'Freight'),
(29, 1, 523, 450.0000, 'Back office additions'),
(30, 1, 553, 63.4000, 'Freight'),
(31, 1, 589, 7125.3400, 'Web site design'),
(32, 1, 403, 953.1000, 'Crash Course revision'),
(33, 1, 591, 220.0000, 'Form 571-L'),
(34, 1, 553, 127.7500, 'Freight'),
(35, 1, 507, 1600.0000, 'Income Tax'),
(36, 1, 403, 565.1500, 'Crash Course Ad'),
(37, 1, 553, 36.0000, 'Freight'),
(38, 1, 553, 61.5000, 'Freight'),
(39, 1, 400, 37966.1900, 'CICS Desk Reference'),
(40, 1, 403, 639.7700, 'Card deck'),
(41, 1, 553, 53.7500, 'Freight'),
(42, 1, 553, 400.0000, 'Freight'),
(43, 1, 400, 21842.0000, 'Book repro'),
(44, 1, 522, 19.6700, 'Telephone (Line 3)'),
(45, 1, 553, 2765.3600, 'Freight'),
(46, 1, 510, 224.0000, 'Health Insurance'),
(47, 1, 572, 1575.0000, 'Catalog ad'),
(48, 1, 553, 33.0000, 'Freight'),
(49, 1, 522, 16.3300, 'Telephone (line 6)'),
(50, 1, 510, 116.0000, 'Health Insurance'),
(51, 1, 553, 2184.1100, 'Freight'),
(52, 1, 160, 1083.5800, 'MSDN'),
(53, 1, 522, 46.2100, 'Telephone (Line 1)'),
(54, 1, 403, 313.5500, 'Card revision'),
(55, 1, 553, 40.7500, 'Freight'),
(56, 1, 572, 2433.0000, 'Card deck'),
(57, 1, 589, 1367.5000, '401K Contributions'),
(58, 1, 553, 53.2500, 'Freight'),
(59, 1, 553, 13.7500, 'Freight'),
(60, 1, 553, 2312.2000, 'Freight'),
(61, 1, 553, 25.6700, 'Freight out'),
(62, 1, 553, 26.7500, 'Freight'),
(63, 1, 553, 2115.8100, 'Freight'),
(64, 1, 553, 23.5000, 'Freight'),
(65, 1, 400, 6940.2500, 'OS Utilities'),
(66, 1, 553, 31.9500, 'Freight'),
(67, 1, 553, 1927.5400, 'Freight'),
(68, 1, 160, 936.9300, 'Quarterly Maintenance'),
(69, 1, 540, 175.0000, 'Card deck advertising'),
(70, 1, 553, 6.0000, 'Freight'),
(71, 1, 553, 108.5000, 'Freight'),
(72, 1, 553, 10.0000, 'Address correction'),
(73, 1, 552, 290.0000, 'International pkg.'),
(74, 1, 570, 41.8000, 'Coffee'),
(75, 1, 553, 27.0000, 'Freight'),
(76, 1, 553, 241.0000, 'Int''l shipment'),
(77, 1, 403, 904.1400, 'Cover design'),
(78, 1, 403, 1197.0000, 'Cover design'),
(78, 2, 540, 765.1300, 'Catalog design'),
(79, 1, 540, 2184.5000, 'PC card deck'),
(80, 1, 553, 2318.0300, 'Freight'),
(81, 1, 553, 26.2500, 'Freight'),
(82, 1, 150, 17.5000, 'Supplies'),
(83, 1, 522, 39.7700, 'Telephone (Line 2)'),
(84, 1, 553, 111.0000, 'Freight'),
(85, 1, 553, 158.0000, 'Int''l shipment'),
(86, 1, 553, 739.2000, 'Freight'),
(87, 1, 553, 60.0000, 'Freight'),
(88, 1, 553, 147.2500, 'Freight'),
(89, 1, 400, 85.3100, 'Book copy'),
(90, 1, 553, 38.7500, 'Freight'),
(91, 1, 522, 32.7000, 'Telephone (line 4)'),
(92, 1, 521, 16.6200, 'Propane-forklift'),
(93, 1, 553, 162.7500, 'International shipment'),
(94, 1, 553, 52.2500, 'Freight'),
(95, 1, 572, 600.0000, 'Books for research'),
(96, 1, 400, 26881.4000, 'MVS JCL'),
(97, 1, 170, 356.4800, 'Network wiring'),
(98, 1, 572, 579.4200, 'Catalog ad'),
(99, 1, 553, 59.9700, 'Freight'),
(100, 1, 553, 67.9200, 'Freight'),
(101, 1, 553, 30.7500, 'Freight'),
(102, 1, 400, 20551.1800, 'CICS book printing'),
(103, 1, 553, 2051.5900, 'Freight'),
(104, 1, 553, 44.4400, 'Freight'),
(105, 1, 582, 503.2000, 'Bronco lease'),
(106, 1, 400, 23517.5800, 'DB2 book printing'),
(107, 1, 553, 3689.9900, 'Freight'),
(108, 1, 553, 67.0000, 'Freight'),
(109, 1, 403, 1000.4600, 'Crash Course covers'),
(110, 1, 540, 90.3600, 'Card deck advertising'),
(111, 1, 553, 22.5700, 'Freight'),
(112, 1, 400, 10976.0600, 'VSAM book printing'),
(113, 1, 510, 224.0000, 'Health Insurance'),
(114, 1, 553, 127.7500, 'Freight')
GO

SET IDENTITY_INSERT Invoices ON 
INSERT Invoices (InvoiceID, VendorID, InvoiceNumber, InvoiceDate, InvoiceTotal, PaymentTotal, CreditTotal, TermsID, InvoiceDueDate, PaymentDate) VALUES 
(1, 122, '989319-457', CAST('2015-12-08 00:00:00' AS SmallDateTime), 3813.3300, 3813.3300, 0.0000, 3, CAST('2016-01-08 00:00:00' AS SmallDateTime), CAST('2016-01-07 00:00:00' AS SmallDateTime)),
(2, 123, '263253241', CAST('2015-12-10 00:00:00' AS SmallDateTime), 40.2000, 40.2000, 0.0000, 3, CAST('2016-01-10 00:00:00' AS SmallDateTime), CAST('2016-01-14 00:00:00' AS SmallDateTime)),
(3, 123, '963253234', CAST('2015-12-13 00:00:00' AS SmallDateTime), 138.7500, 138.7500, 0.0000, 3, CAST('2016-01-13 00:00:00' AS SmallDateTime), CAST('2016-01-09 00:00:00' AS SmallDateTime)),
(4, 123, '2-000-2993', CAST('2015-12-16 00:00:00' AS SmallDateTime), 144.7000, 144.7000, 0.0000, 3, CAST('2016-01-16 00:00:00' AS SmallDateTime), CAST('2016-01-12 00:00:00' AS SmallDateTime)),
(5, 123, '963253251', CAST('2015-12-16 00:00:00' AS SmallDateTime), 15.5000, 15.5000, 0.0000, 3, CAST('2016-01-16 00:00:00' AS SmallDateTime), CAST('2016-01-11 00:00:00' AS SmallDateTime)),
(6, 123, '963253261', CAST('2015-12-16 00:00:00' AS SmallDateTime), 42.7500, 42.7500, 0.0000, 3, CAST('2016-01-16 00:00:00' AS SmallDateTime), CAST('2016-01-21 00:00:00' AS SmallDateTime)),
(7, 123, '963253237', CAST('2015-12-21 00:00:00' AS SmallDateTime), 172.5000, 172.5000, 0.0000, 3, CAST('2016-01-21 00:00:00' AS SmallDateTime), CAST('2016-01-22 00:00:00' AS SmallDateTime)),
(8, 89, '125520-1', CAST('2015-12-24 00:00:00' AS SmallDateTime), 95.0000, 95.0000, 0.0000, 1, CAST('2016-01-04 00:00:00' AS SmallDateTime), CAST('2016-01-01 00:00:00' AS SmallDateTime)),
(9, 121, '97/488', CAST('2015-12-24 00:00:00' AS SmallDateTime), 601.9500, 601.9500, 0.0000, 3, CAST('2016-01-24 00:00:00' AS SmallDateTime), CAST('2016-01-21 00:00:00' AS SmallDateTime)),
(10, 123, '263253250', CAST('2015-12-24 00:00:00' AS SmallDateTime), 42.6700, 42.6700, 0.0000, 3, CAST('2016-01-24 00:00:00' AS SmallDateTime), CAST('2016-01-22 00:00:00' AS SmallDateTime)),
(11, 123, '963253262', CAST('2015-12-25 00:00:00' AS SmallDateTime), 42.5000, 42.5000, 0.0000, 3, CAST('2016-01-25 00:00:00' AS SmallDateTime), CAST('2016-01-20 00:00:00' AS SmallDateTime)),
(12, 96, 'I77271-O01', CAST('2015-12-26 00:00:00' AS SmallDateTime), 662.0000, 662.0000, 0.0000, 2, CAST('2016-01-16 00:00:00' AS SmallDateTime), CAST('2016-01-13 00:00:00' AS SmallDateTime)),
(13, 95, '111-92R-10096', CAST('2015-12-30 00:00:00' AS SmallDateTime), 16.3300, 16.3300, 0.0000, 2, CAST('2016-01-20 00:00:00' AS SmallDateTime), CAST('2016-01-23 00:00:00' AS SmallDateTime)),
(14, 115, '25022117', CAST('2016-01-01 00:00:00' AS SmallDateTime), 6.0000, 6.0000, 0.0000, 4, CAST('2016-02-10 00:00:00' AS SmallDateTime), CAST('2016-02-10 00:00:00' AS SmallDateTime)),
(15, 48, 'P02-88D77S7', CAST('2016-01-03 00:00:00' AS SmallDateTime), 856.9200, 856.9200, 0.0000, 3, CAST('2016-02-02 00:00:00' AS SmallDateTime), CAST('2016-01-30 00:00:00' AS SmallDateTime)),
(16, 97, '21-4748363', CAST('2016-01-03 00:00:00' AS SmallDateTime), 9.9500, 9.9500, 0.0000, 2, CAST('2016-01-23 00:00:00' AS SmallDateTime), CAST('2016-01-22 00:00:00' AS SmallDateTime)),
(17, 123, '4-321-2596', CAST('2016-01-05 00:00:00' AS SmallDateTime), 10.0000, 10.0000, 0.0000, 3, CAST('2016-02-04 00:00:00' AS SmallDateTime), CAST('2016-02-05 00:00:00' AS SmallDateTime)),
(18, 123, '963253242', CAST('2016-01-06 00:00:00' AS SmallDateTime), 104.0000, 104.0000, 0.0000, 3, CAST('2016-02-05 00:00:00' AS SmallDateTime), CAST('2016-02-05 00:00:00' AS SmallDateTime)),
(19, 34, 'QP58872', CAST('2016-01-07 00:00:00' AS SmallDateTime), 116.5400, 116.5400, 0.0000, 1, CAST('2016-01-17 00:00:00' AS SmallDateTime), CAST('2016-01-19 00:00:00' AS SmallDateTime)),
(20, 115, '24863706', CAST('2016-01-10 00:00:00' AS SmallDateTime), 6.0000, 6.0000, 0.0000, 4, CAST('2016-02-19 00:00:00' AS SmallDateTime), CAST('2016-02-15 00:00:00' AS SmallDateTime)),
(21, 119, '10843', CAST('2016-01-11 00:00:00' AS SmallDateTime), 4901.2600, 4901.2600, 0.0000, 2, CAST('2016-01-31 00:00:00' AS SmallDateTime), CAST('2016-01-29 00:00:00' AS SmallDateTime)),
(22, 123, '963253235', CAST('2016-01-11 00:00:00' AS SmallDateTime), 108.2500, 108.2500, 0.0000, 3, CAST('2016-02-10 00:00:00' AS SmallDateTime), CAST('2016-02-09 00:00:00' AS SmallDateTime)),
(23, 97, '21-4923721', CAST('2016-01-13 00:00:00' AS SmallDateTime), 9.9500, 9.9500, 0.0000, 2, CAST('2016-02-02 00:00:00' AS SmallDateTime), CAST('2016-01-28 00:00:00' AS SmallDateTime)),
(24, 113, '77290', CAST('2016-01-13 00:00:00' AS SmallDateTime), 1750.0000, 1750.0000, 0.0000, 5, CAST('2016-03-02 00:00:00' AS SmallDateTime), CAST('2016-03-05 00:00:00' AS SmallDateTime)),
(25, 123, '963253246', CAST('2016-01-13 00:00:00' AS SmallDateTime), 129.0000, 129.0000, 0.0000, 3, CAST('2016-02-12 00:00:00' AS SmallDateTime), CAST('2016-02-09 00:00:00' AS SmallDateTime)),
(26, 123, '4-342-8069', CAST('2016-01-14 00:00:00' AS SmallDateTime), 10.0000, 10.0000, 0.0000, 3, CAST('2016-02-13 00:00:00' AS SmallDateTime), CAST('2016-02-13 00:00:00' AS SmallDateTime)),
(27, 88, '972110', CAST('2016-01-15 00:00:00' AS SmallDateTime), 207.7800, 207.7800, 0.0000, 1, CAST('2016-01-25 00:00:00' AS SmallDateTime), CAST('2016-01-27 00:00:00' AS SmallDateTime)),
(28, 123, '963253263', CAST('2016-01-16 00:00:00' AS SmallDateTime), 109.5000, 109.5000, 0.0000, 3, CAST('2016-02-15 00:00:00' AS SmallDateTime), CAST('2016-02-10 00:00:00' AS SmallDateTime)),
(29, 108, '121897', CAST('2016-01-19 00:00:00' AS SmallDateTime), 450.0000, 450.0000, 0.0000, 4, CAST('2016-02-28 00:00:00' AS SmallDateTime), CAST('2016-03-03 00:00:00' AS SmallDateTime)),
(30, 123, '1-200-5164', CAST('2016-01-20 00:00:00' AS SmallDateTime), 63.4000, 63.4000, 0.0000, 3, CAST('2016-02-19 00:00:00' AS SmallDateTime), CAST('2016-02-24 00:00:00' AS SmallDateTime)),
(31, 104, 'P02-3772', CAST('2016-01-21 00:00:00' AS SmallDateTime), 7125.3400, 7125.3400, 0.0000, 3, CAST('2016-02-20 00:00:00' AS SmallDateTime), CAST('2016-02-24 00:00:00' AS SmallDateTime)),
(32, 121, '97/486', CAST('2016-01-21 00:00:00' AS SmallDateTime), 953.1000, 953.1000, 0.0000, 3, CAST('2016-02-20 00:00:00' AS SmallDateTime), CAST('2016-02-22 00:00:00' AS SmallDateTime)),
(33, 105, '94007005', CAST('2016-01-23 00:00:00' AS SmallDateTime), 220.0000, 220.0000, 0.0000, 3, CAST('2016-02-22 00:00:00' AS SmallDateTime), CAST('2016-02-26 00:00:00' AS SmallDateTime)),
(34, 123, '963253232', CAST('2016-01-23 00:00:00' AS SmallDateTime), 127.7500, 127.7500, 0.0000, 3, CAST('2016-02-22 00:00:00' AS SmallDateTime), CAST('2016-02-18 00:00:00' AS SmallDateTime)),
(35, 107, 'RTR-72-3662-X', CAST('2016-01-25 00:00:00' AS SmallDateTime), 1600.0000, 1600.0000, 0.0000, 4, CAST('2016-03-04 00:00:00' AS SmallDateTime), CAST('2016-03-09 00:00:00' AS SmallDateTime)),
(36, 121, '97/465', CAST('2016-01-25 00:00:00' AS SmallDateTime), 565.1500, 565.1500, 0.0000, 3, CAST('2016-02-24 00:00:00' AS SmallDateTime), CAST('2016-02-24 00:00:00' AS SmallDateTime)),
(37, 123, '963253260', CAST('2016-01-25 00:00:00' AS SmallDateTime), 36.0000, 36.0000, 0.0000, 3, CAST('2016-02-24 00:00:00' AS SmallDateTime), CAST('2016-02-26 00:00:00' AS SmallDateTime)),
(38, 123, '963253272', CAST('2016-01-26 00:00:00' AS SmallDateTime), 61.5000, 61.5000, 0.0000, 3, CAST('2016-02-25 00:00:00' AS SmallDateTime), CAST('2016-02-28 00:00:00' AS SmallDateTime)),
(39, 110, '0-2058', CAST('2016-01-28 00:00:00' AS SmallDateTime), 37966.1900, 37966.1900, 0.0000, 3, CAST('2016-02-27 00:00:00' AS SmallDateTime), CAST('2016-02-28 00:00:00' AS SmallDateTime)),
(40, 121, '97/503', CAST('2016-01-30 00:00:00' AS SmallDateTime), 639.7700, 639.7700, 0.0000, 3, CAST('2016-02-28 00:00:00' AS SmallDateTime), CAST('2016-02-25 00:00:00' AS SmallDateTime)),
(41, 123, '963253255', CAST('2016-01-31 00:00:00' AS SmallDateTime), 53.7500, 53.7500, 0.0000, 3, CAST('2016-02-28 00:00:00' AS SmallDateTime), CAST('2016-02-27 00:00:00' AS SmallDateTime)),
(42, 123, '94007069', CAST('2016-01-31 00:00:00' AS SmallDateTime), 400.0000, 400.0000, 0.0000, 3, CAST('2016-02-28 00:00:00' AS SmallDateTime), CAST('2016-03-01 00:00:00' AS SmallDateTime)),
(43, 72, '40318', CAST('2016-02-01 00:00:00' AS SmallDateTime), 21842.0000, 21842.0000, 0.0000, 3, CAST('2016-03-01 00:00:00' AS SmallDateTime), CAST('2016-02-28 00:00:00' AS SmallDateTime)),
(44, 95, '111-92R-10094', CAST('2016-02-01 00:00:00' AS SmallDateTime), 19.6700, 19.6700, 0.0000, 2, CAST('2016-02-21 00:00:00' AS SmallDateTime), CAST('2016-02-24 00:00:00' AS SmallDateTime)),
(45, 122, '989319-437', CAST('2016-02-01 00:00:00' AS SmallDateTime), 2765.3600, 2765.3600, 0.0000, 3, CAST('2016-03-01 00:00:00' AS SmallDateTime), CAST('2016-02-28 00:00:00' AS SmallDateTime)),
(46, 37, '547481328', CAST('2016-02-03 00:00:00' AS SmallDateTime), 224.0000, 224.0000, 0.0000, 3, CAST('2016-03-03 00:00:00' AS SmallDateTime), CAST('2016-03-04 00:00:00' AS SmallDateTime)),
(47, 83, '31359783', CAST('2016-02-03 00:00:00' AS SmallDateTime), 1575.0000, 1575.0000, 0.0000, 2, CAST('2016-02-23 00:00:00' AS SmallDateTime), CAST('2016-02-21 00:00:00' AS SmallDateTime)),
(48, 123, '1-202-2978', CAST('2016-02-03 00:00:00' AS SmallDateTime), 33.0000, 33.0000, 0.0000, 3, CAST('2016-03-03 00:00:00' AS SmallDateTime), CAST('2016-03-05 00:00:00' AS SmallDateTime)),
(49, 95, '111-92R-10097', CAST('2016-02-04 00:00:00' AS SmallDateTime), 16.3300, 16.3300, 0.0000, 2, CAST('2016-02-24 00:00:00' AS SmallDateTime), CAST('2016-02-26 00:00:00' AS SmallDateTime)),
(50, 37, '547479217', CAST('2016-02-07 00:00:00' AS SmallDateTime), 116.0000, 116.0000, 0.0000, 3, CAST('2016-03-07 00:00:00' AS SmallDateTime), CAST('2016-03-07 00:00:00' AS SmallDateTime)),
(51, 122, '989319-477', CAST('2016-02-08 00:00:00' AS SmallDateTime), 2184.1100, 2184.1100, 0.0000, 3, CAST('2016-03-08 00:00:00' AS SmallDateTime), CAST('2016-03-08 00:00:00' AS SmallDateTime)),
(52, 34, 'Q545443', CAST('2016-02-09 00:00:00' AS SmallDateTime), 1083.5800, 1083.5800, 0.0000, 1, CAST('2016-02-19 00:00:00' AS SmallDateTime), CAST('2016-02-23 00:00:00' AS SmallDateTime)),
(53, 95, '111-92R-10092', CAST('2016-02-09 00:00:00' AS SmallDateTime), 46.2100, 46.2100, 0.0000, 2, CAST('2016-02-28 00:00:00' AS SmallDateTime), CAST('2016-03-02 00:00:00' AS SmallDateTime)),
(54, 121, '97/553B', CAST('2016-02-10 00:00:00' AS SmallDateTime), 313.5500, 313.5500, 0.0000, 3, CAST('2016-03-10 00:00:00' AS SmallDateTime), CAST('2016-03-09 00:00:00' AS SmallDateTime)),
(55, 123, '963253245', CAST('2016-02-10 00:00:00' AS SmallDateTime), 40.7500, 40.7500, 0.0000, 3, CAST('2016-03-10 00:00:00' AS SmallDateTime), CAST('2016-03-12 00:00:00' AS SmallDateTime)),
(56, 86, '367447', CAST('2016-02-11 00:00:00' AS SmallDateTime), 2433.0000, 2433.0000, 0.0000, 1, CAST('2016-02-21 00:00:00' AS SmallDateTime), CAST('2016-02-17 00:00:00' AS SmallDateTime)),
(57, 103, '75C-90227', CAST('2016-02-11 00:00:00' AS SmallDateTime), 1367.5000, 1367.5000, 0.0000, 5, CAST('2016-03-31 00:00:00' AS SmallDateTime), CAST('2016-03-31 00:00:00' AS SmallDateTime)),
(58, 123, '963253256', CAST('2016-02-11 00:00:00' AS SmallDateTime), 53.2500, 53.2500, 0.0000, 3, CAST('2016-03-11 00:00:00' AS SmallDateTime), CAST('2016-03-07 00:00:00' AS SmallDateTime)),
(59, 123, '4-314-3057', CAST('2016-02-11 00:00:00' AS SmallDateTime), 13.7500, 13.7500, 0.0000, 3, CAST('2016-03-11 00:00:00' AS SmallDateTime), CAST('2016-03-15 00:00:00' AS SmallDateTime)),
(60, 122, '989319-497', CAST('2016-02-12 00:00:00' AS SmallDateTime), 2312.2000, 2312.2000, 0.0000, 3, CAST('2016-03-12 00:00:00' AS SmallDateTime), CAST('2016-03-09 00:00:00' AS SmallDateTime)),
(61, 115, '24946731', CAST('2016-02-15 00:00:00' AS SmallDateTime), 25.6700, 25.6700, 0.0000, 4, CAST('2016-03-25 00:00:00' AS SmallDateTime), CAST('2016-03-26 00:00:00' AS SmallDateTime)),
(62, 123, '963253269', CAST('2016-02-15 00:00:00' AS SmallDateTime), 26.7500, 26.7500, 0.0000, 3, CAST('2016-03-15 00:00:00' AS SmallDateTime), CAST('2016-03-11 00:00:00' AS SmallDateTime)),
(63, 122, '989319-427', CAST('2016-02-16 00:00:00' AS SmallDateTime), 2115.8100, 2115.8100, 0.0000, 3, CAST('2016-03-16 00:00:00' AS SmallDateTime), CAST('2016-03-19 00:00:00' AS SmallDateTime)),
(64, 123, '963253267', CAST('2016-02-17 00:00:00' AS SmallDateTime), 23.5000, 23.5000, 0.0000, 3, CAST('2016-03-17 00:00:00' AS SmallDateTime), CAST('2016-03-19 00:00:00' AS SmallDateTime)),
(65, 99, '509786', CAST('2016-02-18 00:00:00' AS SmallDateTime), 6940.2500, 6940.2500, 0.0000, 3, CAST('2016-03-18 00:00:00' AS SmallDateTime), CAST('2016-03-15 00:00:00' AS SmallDateTime)),
(66, 123, '263253253', CAST('2016-02-18 00:00:00' AS SmallDateTime), 31.9500, 31.9500, 0.0000, 3, CAST('2016-03-18 00:00:00' AS SmallDateTime), CAST('2016-03-21 00:00:00' AS SmallDateTime)),
(67, 122, '989319-487', CAST('2016-02-20 00:00:00' AS SmallDateTime), 1927.5400, 1927.5400, 0.0000, 3, CAST('2016-03-20 00:00:00' AS SmallDateTime), CAST('2016-03-18 00:00:00' AS SmallDateTime)),
(68, 81, 'MABO1489', CAST('2016-02-21 00:00:00' AS SmallDateTime), 936.9300, 936.9300, 0.0000, 2, CAST('2016-03-11 00:00:00' AS SmallDateTime), CAST('2016-03-10 00:00:00' AS SmallDateTime)),
(69, 80, '133560', CAST('2016-02-22 00:00:00' AS SmallDateTime), 175.0000, 175.0000, 0.0000, 2, CAST('2016-03-12 00:00:00' AS SmallDateTime), CAST('2016-03-16 00:00:00' AS SmallDateTime)),
(70, 115, '24780512', CAST('2016-02-22 00:00:00' AS SmallDateTime), 6.0000, 6.0000, 0.0000, 4, CAST('2016-04-01 00:00:00' AS SmallDateTime), CAST('2016-03-29 00:00:00' AS SmallDateTime)),
(71, 123, '963253254', CAST('2016-02-22 00:00:00' AS SmallDateTime), 108.5000, 108.5000, 0.0000, 3, CAST('2016-03-22 00:00:00' AS SmallDateTime), CAST('2016-03-20 00:00:00' AS SmallDateTime)),
(72, 123, '43966316', CAST('2016-02-22 00:00:00' AS SmallDateTime), 10.0000, 10.0000, 0.0000, 3, CAST('2016-03-22 00:00:00' AS SmallDateTime), CAST('2016-03-17 00:00:00' AS SmallDateTime)),
(73, 114, 'CBM9920-M-T77109', CAST('2016-02-23 00:00:00' AS SmallDateTime), 290.0000, 290.0000, 0.0000, 1, CAST('2016-03-03 00:00:00' AS SmallDateTime), CAST('2016-02-28 00:00:00' AS SmallDateTime)),
(74, 102, '109596', CAST('2016-02-24 00:00:00' AS SmallDateTime), 41.8000, 41.8000, 0.0000, 4, CAST('2016-04-03 00:00:00' AS SmallDateTime), CAST('2016-04-04 00:00:00' AS SmallDateTime)),
(75, 123, '7548906-20', CAST('2016-02-24 00:00:00' AS SmallDateTime), 27.0000, 27.0000, 0.0000, 3, CAST('2016-03-24 00:00:00' AS SmallDateTime), CAST('2016-03-24 00:00:00' AS SmallDateTime)),
(76, 123, '963253248', CAST('2016-02-24 00:00:00' AS SmallDateTime), 241.0000, 241.0000, 0.0000, 3, CAST('2016-03-24 00:00:00' AS SmallDateTime), CAST('2016-03-25 00:00:00' AS SmallDateTime)),
(77, 121, '97/553', CAST('2016-02-25 00:00:00' AS SmallDateTime), 904.1400, 904.1400, 0.0000, 3, CAST('2016-03-25 00:00:00' AS SmallDateTime), CAST('2016-03-25 00:00:00' AS SmallDateTime)),
(78, 121, '97/522', CAST('2016-02-28 00:00:00' AS SmallDateTime), 1962.1300, 1762.1300, 200.0000, 3, CAST('2016-03-28 00:00:00' AS SmallDateTime), CAST('2016-03-30 00:00:00' AS SmallDateTime)),
(79, 100, '587056', CAST('2016-02-28 00:00:00' AS SmallDateTime), 2184.5000, 2184.5000, 0.0000, 4, CAST('2016-04-09 00:00:00' AS SmallDateTime), CAST('2016-04-07 00:00:00' AS SmallDateTime)),
(80, 122, '989319-467', CAST('2016-03-01 00:00:00' AS SmallDateTime), 2318.0300, 2318.0300, 0.0000, 3, CAST('2016-03-31 00:00:00' AS SmallDateTime), CAST('2016-03-29 00:00:00' AS SmallDateTime)),
(81, 123, '263253265', CAST('2016-03-02 00:00:00' AS SmallDateTime), 26.2500, 26.2500, 0.0000, 3, CAST('2016-04-01 00:00:00' AS SmallDateTime), CAST('2016-03-28 00:00:00' AS SmallDateTime)),
(82, 94, '203339-13', CAST('2016-03-05 00:00:00' AS SmallDateTime), 17.5000, 17.5000, 0.0000, 2, CAST('2016-03-25 00:00:00' AS SmallDateTime), CAST('2016-03-27 00:00:00' AS SmallDateTime)),
(83, 95, '111-92R-10093', CAST('2016-03-06 00:00:00' AS SmallDateTime), 39.7700, 39.7700, 0.0000, 2, CAST('2016-03-26 00:00:00' AS SmallDateTime), CAST('2016-03-22 00:00:00' AS SmallDateTime)),
(84, 123, '963253258', CAST('2016-03-06 00:00:00' AS SmallDateTime), 111.0000, 111.0000, 0.0000, 3, CAST('2016-04-05 00:00:00' AS SmallDateTime), CAST('2016-04-05 00:00:00' AS SmallDateTime)),
(85, 123, '963253271', CAST('2016-03-07 00:00:00' AS SmallDateTime), 158.0000, 158.0000, 0.0000, 3, CAST('2016-04-06 00:00:00' AS SmallDateTime), CAST('2016-04-11 00:00:00' AS SmallDateTime)),
(86, 123, '963253230', CAST('2016-03-07 00:00:00' AS SmallDateTime), 739.2000, 739.2000, 0.0000, 3, CAST('2016-04-06 00:00:00' AS SmallDateTime), CAST('2016-04-06 00:00:00' AS SmallDateTime)),
(87, 123, '963253244', CAST('2016-03-08 00:00:00' AS SmallDateTime), 60.0000, 60.0000, 0.0000, 3, CAST('2016-04-07 00:00:00' AS SmallDateTime), CAST('2016-04-09 00:00:00' AS SmallDateTime)),
(88, 123, '963253239', CAST('2016-03-08 00:00:00' AS SmallDateTime), 147.2500, 147.2500, 0.0000, 3, CAST('2016-04-07 00:00:00' AS SmallDateTime), CAST('2016-04-11 00:00:00' AS SmallDateTime)),
(89, 72, '39104', CAST('2016-03-10 00:00:00' AS SmallDateTime), 85.3100, 0.0000, 0.0000, 3, CAST('2016-04-09 00:00:00' AS SmallDateTime), NULL),
(90, 123, '963253252', CAST('2016-03-12 00:00:00' AS SmallDateTime), 38.7500, 38.7500, 0.0000, 3, CAST('2016-04-11 00:00:00' AS SmallDateTime), CAST('2016-04-11 00:00:00' AS SmallDateTime)),
(91, 95, '111-92R-10095', CAST('2016-03-15 00:00:00' AS SmallDateTime), 32.7000, 32.7000, 0.0000, 2, CAST('2016-04-04 00:00:00' AS SmallDateTime), CAST('2016-04-06 00:00:00' AS SmallDateTime)),
(92, 117, '111897', CAST('2016-03-15 00:00:00' AS SmallDateTime), 16.6200, 16.6200, 0.0000, 3, CAST('2016-04-14 00:00:00' AS SmallDateTime), CAST('2016-04-14 00:00:00' AS SmallDateTime)),
(93, 123, '4-327-7357', CAST('2016-03-16 00:00:00' AS SmallDateTime), 162.7500, 162.7500, 0.0000, 3, CAST('2016-04-15 00:00:00' AS SmallDateTime), CAST('2016-04-11 00:00:00' AS SmallDateTime)),
(94, 123, '963253264', CAST('2016-03-18 00:00:00' AS SmallDateTime), 52.2500, 0.0000, 0.0000, 3, CAST('2016-04-17 00:00:00' AS SmallDateTime), NULL),
(95, 82, 'C73-24', CAST('2016-03-19 00:00:00' AS SmallDateTime), 600.0000, 600.0000, 0.0000, 2, CAST('2016-04-08 00:00:00' AS SmallDateTime), CAST('2016-04-13 00:00:00' AS SmallDateTime)),
(96, 110, 'P-0259', CAST('2016-03-19 00:00:00' AS SmallDateTime), 26881.4000, 26881.4000, 0.0000, 3, CAST('2016-04-18 00:00:00' AS SmallDateTime), CAST('2016-04-20 00:00:00' AS SmallDateTime)),
(97, 90, '97-1024A', CAST('2016-03-20 00:00:00' AS SmallDateTime), 356.4800, 356.4800, 0.0000, 2, CAST('2016-04-09 00:00:00' AS SmallDateTime), CAST('2016-04-07 00:00:00' AS SmallDateTime)),
(98, 83, '31361833', CAST('2016-03-21 00:00:00' AS SmallDateTime), 579.4200, 0.0000, 0.0000, 2, CAST('2016-04-10 00:00:00' AS SmallDateTime), NULL),
(99, 123, '263253268', CAST('2016-03-21 00:00:00' AS SmallDateTime), 59.9700, 0.0000, 0.0000, 3, CAST('2016-04-20 00:00:00' AS SmallDateTime), NULL),
(100, 123, '263253270', CAST('2016-03-22 00:00:00' AS SmallDateTime), 67.9200, 0.0000, 0.0000, 3, CAST('2016-04-21 00:00:00' AS SmallDateTime), NULL),
(101, 123, '263253273', CAST('2016-03-22 00:00:00' AS SmallDateTime), 30.7500, 0.0000, 0.0000, 3, CAST('2016-04-21 00:00:00' AS SmallDateTime), NULL),
(102, 110, 'P-0608', CAST('2016-03-23 00:00:00' AS SmallDateTime), 20551.1800, 0.0000, 1200.0000, 3, CAST('2016-04-22 00:00:00' AS SmallDateTime), NULL),
(103, 122, '989319-417', CAST('2016-03-23 00:00:00' AS SmallDateTime), 2051.5900, 2051.5900, 0.0000, 3, CAST('2016-04-22 00:00:00' AS SmallDateTime), CAST('2016-04-24 00:00:00' AS SmallDateTime)),
(104, 123, '263253243', CAST('2016-03-23 00:00:00' AS SmallDateTime), 44.4400, 44.4400, 0.0000, 3, CAST('2016-04-22 00:00:00' AS SmallDateTime), CAST('2016-04-24 00:00:00' AS SmallDateTime)),
(105, 106, '9982771', CAST('2016-03-24 00:00:00' AS SmallDateTime), 503.2000, 0.0000, 0.0000, 3, CAST('2016-04-23 00:00:00' AS SmallDateTime), NULL),
(106, 110, '0-2060', CAST('2016-03-24 00:00:00' AS SmallDateTime), 23517.5800, 21221.6300, 2295.9500, 3, CAST('2016-04-23 00:00:00' AS SmallDateTime), CAST('2016-04-27 00:00:00' AS SmallDateTime)),
(107, 122, '989319-447', CAST('2016-03-24 00:00:00' AS SmallDateTime), 3689.9900, 3689.9900, 0.0000, 3, CAST('2016-04-23 00:00:00' AS SmallDateTime), CAST('2016-04-19 00:00:00' AS SmallDateTime)),
(108, 123, '963253240', CAST('2016-03-24 00:00:00' AS SmallDateTime), 67.0000, 67.0000, 0.0000, 3, CAST('2016-04-23 00:00:00' AS SmallDateTime), CAST('2016-04-23 00:00:00' AS SmallDateTime)),
(109, 121, '97/222', CAST('2016-03-25 00:00:00' AS SmallDateTime), 1000.4600, 1000.4600, 0.0000, 3, CAST('2016-04-24 00:00:00' AS SmallDateTime), CAST('2016-04-22 00:00:00' AS SmallDateTime)),
(110, 80, '134116', CAST('2016-03-28 00:00:00' AS SmallDateTime), 90.3600, 0.0000, 0.0000, 2, CAST('2016-04-17 00:00:00' AS SmallDateTime), NULL),
(111, 123, '263253257', CAST('2016-03-30 00:00:00' AS SmallDateTime), 22.5700, 22.5700, 0.0000, 3, CAST('2016-04-29 00:00:00' AS SmallDateTime), CAST('2016-05-03 00:00:00' AS SmallDateTime)),
(112, 110, '0-2436', CAST('2016-03-31 00:00:00' AS SmallDateTime), 10976.0600, 0.0000, 0.0000, 3, CAST('2016-04-30 00:00:00' AS SmallDateTime), NULL),
(113, 37, '547480102', CAST('2016-04-01 00:00:00' AS SmallDateTime), 224.0000, 0.0000, 0.0000, 3, CAST('2016-04-30 00:00:00' AS SmallDateTime), NULL),
(114, 123, '963253249', CAST('2016-04-02 00:00:00' AS SmallDateTime), 127.7500, 127.7500, 0.0000, 3, CAST('2016-05-01 00:00:00' AS SmallDateTime), CAST('2016-05-04 00:00:00' AS SmallDateTime))
SET IDENTITY_INSERT Invoices OFF
GO

SET IDENTITY_INSERT Terms ON 
INSERT Terms (TermsID, TermsDescription, TermsDueDays) VALUES
(1, 'Net due 10 days', 10),
(2, 'Net due 20 days', 20),
(3, 'Net due 30 days', 30),
(4, 'Net due 60 days', 60),
(5, 'Net due 90 days', 90)
SET IDENTITY_INSERT Terms OFF
GO

SET IDENTITY_INSERT Vendors ON 
INSERT Vendors (VendorID, VendorName, VendorAddress1, VendorAddress2, VendorCity, VendorState, VendorZipCode, VendorPhone, VendorContactLName, VendorContactFName, DefaultTermsID, DefaultAccountNo) VALUES 
(1, 'US Postal Service', 'Attn:  Supt. Window Services', 'PO Box 7005', 'Madison', 'WI', '53707', '(800) 555-1205', 'Alberto', 'Francesco', 1, 552),
(2, 'National Information Data Ctr', 'PO Box 96621', NULL, 'Washington', 'DC', '20090', '(301) 555-8950', 'Irvin', 'Ania', 3, 540),
(3, 'Register of Copyrights', 'Library Of Congress', NULL, 'Washington', 'DC', '20559', NULL, 'Liana', 'Lukas', 3, 403),
(4, 'Jobtrak', '1990 Westwood Blvd Ste 260', NULL, 'Los Angeles', 'CA', '90025', '(800) 555-8725', 'Quinn', 'Kenzie', 3, 572),
(5, 'Newbrige Book Clubs', '3000 Cindel Drive', NULL, 'Washington', 'NJ', '07882', '(800) 555-9980', 'Marks', 'Michelle', 4, 394),
(6, 'California Chamber Of Commerce', '3255 Ramos Cir', NULL, 'Sacramento', 'CA', '95827', '(916) 555-6670', 'Mauro', 'Anton', 3, 572),
(7, 'Towne Advertiser''s Mailing Svcs', 'Kevin Minder', '3441 W Macarthur Blvd', 'Santa Ana', 'CA', '92704', NULL, 'Maegen', 'Ted', 3, 540),
(8, 'BFI Industries', 'PO Box 9369', NULL, 'Fresno', 'CA', '93792', '(559) 555-1551', 'Kaleigh', 'Erick', 3, 521),
(9, 'Pacific Gas & Electric', 'Box 52001', NULL, 'San Francisco', 'CA', '94152', '(800) 555-6081', 'Anthoni', 'Kaitlyn', 3, 521),
(10, 'Robbins Mobile Lock And Key', '4669 N Fresno', NULL, 'Fresno', 'CA', '93726', '(559) 555-9375', 'Leigh', 'Bill', 2, 523),
(11, 'Bill Marvin Electric Inc', '4583 E Home', NULL, 'Fresno', 'CA', '93703', '(559) 555-5106', 'Hostlery', 'Kaitlin', 2, 523),
(12, 'City Of Fresno', 'PO Box 2069', NULL, 'Fresno', 'CA', '93718', '(559) 555-9999', 'Mayte', 'Kendall', 3, 574),
(13, 'Golden Eagle Insurance Co', 'PO Box 85826', NULL, 'San Diego', 'CA', '92186', NULL, 'Blanca', 'Korah', 3, 590),
(14, 'Expedata Inc', '4420 N. First Street, Suite 108', NULL, 'Fresno', 'CA', '93726', '(559) 555-9586', 'Quintin', 'Marvin', 3, 589),
(15, 'ASC Signs', '1528 N Sierra Vista', NULL, 'Fresno', 'CA', '93703', NULL, 'Darien', 'Elisabeth', 1, 546),
(16, 'Internal Revenue Service', NULL, NULL, 'Fresno', 'CA', '93888', NULL, 'Aileen', 'Joan', 1, 235),
(17, 'Blanchard & Johnson Associates', '27371 Valderas', NULL, 'Mission Viejo', 'CA', '92691', '(214) 555-3647', 'Keeton', 'Gonzalo', 3, 540),
(18, 'Fresno Photoengraving Company', '1952 "H" Street', 'P.O. Box 1952', 'Fresno', 'CA', '93718', '(559) 555-3005', 'Chaddick', 'Derek', 3, 403),
(19, 'Crown Printing', '1730 "H" St', NULL, 'Fresno', 'CA', '93721', '(559) 555-7473', 'Randrup', 'Leann', 2, 400),
(20, 'Diversified Printing & Pub', '2632 Saturn St', NULL, 'Brea', 'CA', '92621', '(714) 555-4541', 'Lane', 'Vanesa', 3, 400),
(21, 'The Library Ltd', '7700 Forsyth', NULL, 'St Louis', 'MO', '63105', '(314) 555-8834', 'Marques', 'Malia', 3, 540),
(22, 'Micro Center', '1555 W Lane Ave', NULL, 'Columbus', 'OH', '43221', '(614) 555-4435', 'Evan', 'Emily', 2, 160),
(23, 'Yale Industrial Trucks-Fresno', '3711 W Franklin', NULL, 'Fresno', 'CA', '93706', '(559) 555-2993', 'Alexis', 'Alexandro', 3, 532),
(24, 'Zee Medical Service Co', '4221 W Sierra Madre #104', NULL, 'Washington', 'IA', '52353', NULL, 'Hallie', 'Juliana', 3, 570),
(25, 'California Data Marketing', '2818 E Hamilton', NULL, 'Fresno', 'CA', '93721', '(559) 555-3801', 'Jonessen', 'Moises', 4, 540),
(26, 'Small Press', '121 E Front St - 4th Floor', NULL, 'Traverse City', 'MI', '49684', NULL, 'Colette', 'Dusty', 3, 540),
(27, 'Rich Advertising', '12 Daniel Road', NULL, 'Fairfield', 'NJ', '07004', '(201) 555-9742', 'Neil', 'Ingrid', 3, 540),
(29, 'Vision Envelope & Printing', 'PO Box 3100', NULL, 'Gardena', 'CA', '90247', '(310) 555-7062', 'Raven', 'Jamari', 3, 551),
(30, 'Costco', 'Fresno Warehouse', '4500 W Shaw', 'Fresno', 'CA', '93711', NULL, 'Jaquan', 'Aaron', 3, 570),
(31, 'Enterprise Communications Inc', '1483 Chain Bridge Rd, Ste 202', NULL, 'Mclean', 'VA', '22101', '(770) 555-9558', 'Lawrence', 'Eileen', 2, 536),
(32, 'RR Bowker', 'PO Box 31', NULL, 'East Brunswick', 'NJ', '08810', '(800) 555-8110', 'Essence', 'Marjorie', 3, 532),
(33, 'Nielson', 'Ohio Valley Litho Division', 'Location #0470', 'Cincinnati', 'OH', '45264', NULL, 'Brooklynn', 'Keely', 2, 541),
(34, 'IBM', 'PO Box 61000', NULL, 'San Francisco', 'CA', '94161', '(800) 555-4426', 'Camron', 'Trentin', 1, 160),
(35, 'Cal State Termite', 'PO Box 956', NULL, 'Selma', 'CA', '93662', '(559) 555-1534', 'Hunter', 'Demetrius', 2, 523),
(36, 'Graylift', 'PO Box 2808', NULL, 'Fresno', 'CA', '93745', '(559) 555-6621', 'Sydney', 'Deangelo', 3, 532),
(37, 'Blue Cross', 'PO Box 9061', NULL, 'Oxnard', 'CA', '93031', '(800) 555-0912', 'Eliana', 'Nikolas', 3, 510),
(38, 'Venture Communications Int''l', '60 Madison Ave', NULL, 'New York', 'NY', '10010', '(212) 555-4800', 'Neftaly', 'Thalia', 3, 540),
(39, 'Custom Printing Company', 'PO Box 7028', NULL, 'St Louis', 'MO', '63177', '(301) 555-1494', 'Myles', 'Harley', 3, 540),
(40, 'Nat Assoc of College Stores', '500 East Lorain Street', NULL, 'Oberlin', 'OH', '44074', NULL, 'Bernard', 'Lucy', 3, 572),
(41, 'Shields Design', '415 E Olive Ave', NULL, 'Fresno', 'CA', '93728', '(559) 555-8060', 'Kerry', 'Rowan', 2, 403),
(42, 'Opamp Technical Books', '1033 N Sycamore Ave.', NULL, 'Los Angeles', 'CA', '90038', '(213) 555-4322', 'Paris', 'Gideon', 3, 572),
(43, 'Capital Resource Credit', 'PO Box 39046', NULL, 'Minneapolis', 'MN', '55439', '(612) 555-0057', 'Maxwell', 'Jayda', 3, 589),
(44, 'Courier Companies, Inc', 'PO Box 5317', NULL, 'Boston', 'MA', '02206', '(508) 555-6351', 'Antavius', 'Troy', 4, 400),
(45, 'Naylor Publications Inc', 'PO Box 40513', NULL, 'Jacksonville', 'FL', '32231', '(800) 555-6041', 'Gerald', 'Kristofer', 3, 572),
(46, 'Open Horizons Publishing', 'Book Marketing Update', 'PO Box 205', 'Fairfield', 'IA', '52556', '(515) 555-6130', 'Damien', 'Deborah', 2, 540),
(47, 'Baker & Taylor Books', 'Five Lakepointe Plaza, Ste 500', '2709 Water Ridge Parkway', 'Charlotte', 'NC', '28217', '(704) 555-3500', 'Bernardo', 'Brittnee', 3, 572),
(48, 'Fresno County Tax Collector', 'PO Box 1192', NULL, 'Fresno', 'CA', '93715', '(559) 555-3482', 'Brenton', 'Kila', 3, 574),
(49, 'Mcgraw Hill Companies', 'PO Box 87373', NULL, 'Chicago', 'IL', '60680', '(614) 555-3663', 'Holbrooke', 'Rashad', 3, 572),
(50, 'Publishers Weekly', 'Box 1979', NULL, 'Marion', 'OH', '43305', '(800) 555-1669', 'Carrollton', 'Priscilla', 3, 572),
(51, 'Blue Shield of California', 'PO Box 7021', NULL, 'Anaheim', 'CA', '92850', '(415) 555-5103', 'Smith', 'Kylie', 3, 510),
(52, 'Aztek Label', 'Accounts Payable', '1150 N Tustin Ave', 'Anaheim', 'CA', '92807', '(714) 555-9000', 'Griffin', 'Brian', 3, 551),
(53, 'Gary McKeighan Insurance', '3649 W Beechwood Ave #101', NULL, 'Fresno', 'CA', '93711', '(559) 555-2420', 'Jair', 'Caitlin', 3, 590),
(54, 'Ph Photographic Services', '2384 E Gettysburg', NULL, 'Fresno', 'CA', '93726', '(559) 555-0765', 'Cheyenne', 'Kaylea', 3, 540),
(55, 'Quality Education Data', 'PO Box 95857', NULL, 'Chicago', 'IL', '60694', '(800) 555-5811', 'Misael', 'Kayle', 2, 540),
(56, 'Springhouse Corp', 'PO Box 7247-7051', NULL, 'Philadelphia', 'PA', '19170', '(215) 555-8700', 'Maeve', 'Clarence', 3, 523),
(57, 'The Windows Deck', '117 W Micheltorena Top Floor', NULL, 'Santa Barbara', 'CA', '93101', '(800) 555-3353', 'Wood', 'Liam', 3, 536),
(58, 'Fresno Rack & Shelving Inc', '4718 N Bendel Ave', NULL, 'Fresno', 'CA', '93722', NULL, 'Baylee', 'Dakota', 2, 523),
(59, 'Publishers Marketing Assoc', '627 Aviation Way', NULL, 'Manhatttan Beach', 'CA', '90266', '(310) 555-2732', 'Walker', 'Jovon', 3, 572),
(60, 'The Mailers Guide Co', 'PO Box 1550', NULL, 'New Rochelle', 'NY', '10802', NULL, 'Lacy', 'Karina', 3, 540),
(61, 'American Booksellers Assoc', '828 S Broadway', NULL, 'Tarrytown', 'NY', '10591', '(800) 555-0037', 'Angelica', 'Nashalie', 3, 574),
(62, 'Cmg Information Services', 'PO Box 2283', NULL, 'Boston', 'MA', '02107', '(508) 555-7000', 'Randall', 'Yash', 3, 540),
(63, 'Lou Gentile''s Flower Basket', '722 E Olive Ave', NULL, 'Fresno', 'CA', '93728', '(559) 555-6643', 'Anum', 'Trisha', 1, 570),
(64, 'Texaco', 'PO Box 6070', NULL, 'Inglewood', 'CA', '90312', NULL, 'Oren', 'Grace', 3, 582),
(65, 'The Drawing Board', 'PO Box 4758', NULL, 'Carol Stream', 'IL', '60197', NULL, 'Mckayla', 'Jeffery', 2, 551),
(66, 'Ascom Hasler Mailing Systems', 'PO Box 895', NULL, 'Shelton', 'CT', '06484', NULL, 'Lewis', 'Darnell', 3, 532),
(67, 'Bill Jones', 'Secretary Of State', 'PO Box 944230', 'Sacramento', 'CA', '94244', NULL, 'Deasia', 'Tristin', 3, 589),
(68, 'Computer Library', '3502 W Greenway #7', NULL, 'Phoenix', 'AZ', '85023', '(602) 547-0331', 'Aryn', 'Leroy', 3, 540),
(69, 'Frank E Wilber Co', '2437 N Sunnyside', NULL, 'Fresno', 'CA', '93727', '(559) 555-1881', 'Millerton', 'Johnathon', 3, 532),
(70, 'Fresno Credit Bureau', 'PO Box 942', NULL, 'Fresno', 'CA', '93714', '(559) 555-7900', 'Braydon', 'Anne', 2, 555),
(71, 'The Fresno Bee', '1626 E Street', NULL, 'Fresno', 'CA', '93786', '(559) 555-4442', 'Colton', 'Leah', 2, 572),
(72, 'Data Reproductions Corp', '4545 Glenmeade Lane', NULL, 'Auburn Hills', 'MI', '48326', '(810) 555-3700', 'Arodondo', 'Cesar', 3, 400),
(73, 'Executive Office Products', '353 E Shaw Ave', NULL, 'Fresno', 'CA', '93710', '(559) 555-1704', 'Danielson', 'Rachael', 2, 570),
(74, 'Leslie Company', 'PO Box 610', NULL, 'Olathe', 'KS', '66061', '(800) 255-6210', 'Alondra', 'Zev', 3, 570),
(75, 'Retirement Plan Consultants', '6435 North Palm Ave, Ste 101', NULL, 'Fresno', 'CA', '93704', '(559) 555-7070', 'Edgardo', 'Salina', 3, 589),
(76, 'Simon Direct Inc', '4 Cornwall Dr Ste 102', NULL, 'East Brunswick', 'NJ', '08816', '(908) 555-7222', 'Bradlee', 'Daniel', 2, 540),
(77, 'State Board Of Equalization', 'PO Box 942808', NULL, 'Sacramento', 'CA', '94208', '(916) 555-4911', 'Dean', 'Julissa', 1, 631),
(78, 'The Presort Center', '1627 "E" Street', NULL, 'Fresno', 'CA', '93706', '(559) 555-6151', 'Marissa', 'Kyle', 3, 540),
(79, 'Valprint', 'PO Box 12332', NULL, 'Fresno', 'CA', '93777', '(559) 555-3112', 'Warren', 'Quentin', 3, 551),
(80, 'Cardinal Business Media, Inc.', 'P O Box 7247-7844', NULL, 'Philadelphia', 'PA', '19170', '(215) 555-1500', 'Eulalia', 'Kelsey', 2, 540),
(81, 'Wang Laboratories, Inc.', 'P.O. Box 21209', NULL, 'Pasadena', 'CA', '91185', '(800) 555-0344', 'Kapil', 'Robert', 2, 160),
(82, 'Reiter''s Scientific & Pro Books', '2021 K Street Nw', NULL, 'Washington', 'DC', '20006', '(202) 555-5561', 'Rodolfo', 'Carlee', 2, 572),
(83, 'Ingram', 'PO Box 845361', NULL, 'Dallas', 'TX', '75284', NULL, 'Yobani', 'Trey', 2, 541),
(84, 'Boucher Communications Inc', '1300 Virginia Dr. Ste 400', NULL, 'Fort Washington', 'PA', '19034', '(215) 555-8000', 'Carson', 'Julian', 3, 540),
(85, 'Champion Printing Company', '3250 Spring Grove Ave', NULL, 'Cincinnati', 'OH', '45225', '(800) 555-1957', 'Clifford', 'Jillian', 3, 540),
(86, 'Computerworld', 'Department #1872', 'PO Box 61000', 'San Francisco', 'CA', '94161', '(617) 555-0700', 'Lloyd', 'Angel', 1, 572),
(87, 'DMV Renewal', 'PO Box 942894', NULL, 'Sacramento', 'CA', '94294', NULL, 'Josey', 'Lorena', 4, 568),
(88, 'Edward Data Services', '4775 E Miami River Rd', NULL, 'Cleves', 'OH', '45002', '(513) 555-3043', 'Helena', 'Jeanette', 1, 540),
(89, 'Evans Executone Inc', '4918 Taylor Ct', NULL, 'Turlock', 'CA', '95380', NULL, 'Royce', 'Hannah', 1, 522),
(90, 'Wakefield Co', '295 W Cromwell Ave Ste 106', NULL, 'Fresno', 'CA', '93711', '(559) 555-4744', 'Rothman', 'Nathanael', 2, 170),
(91, 'McKesson Water Products', 'P O Box 7126', NULL, 'Pasadena', 'CA', '91109', '(800) 555-7009', 'Destin', 'Luciano', 2, 570),
(92, 'Zip Print & Copy Center', 'PO Box 12332', NULL, 'Fresno', 'CA', '93777', '(233) 555-6400', 'Javen', 'Justin', 2, 540),
(93, 'AT&T', 'PO Box 78225', NULL, 'Phoenix', 'AZ', '85062', NULL, 'Wesley', 'Alisha', 3, 522),
(94, 'Abbey Office Furnishings', '4150 W Shaw Ave', NULL, 'Fresno', 'CA', '93722', '(559) 555-8300', 'Francis', 'Kyra', 2, 150),
(95, 'Pacific Bell', NULL, NULL, 'Sacramento', 'CA', '95887', '(209) 555-7500', 'Nickalus', 'Kurt', 2, 522),
(96, 'Wells Fargo Bank', 'Business Mastercard', 'P.O. Box 29479', 'Phoenix', 'AZ', '85038', '(947) 555-3900', 'Damion', 'Mikayla', 2, 160),
(97, 'Compuserve', 'Dept L-742', NULL, 'Columbus', 'OH', '43260', '(614) 555-8600', 'Armando', 'Jan', 2, 572),
(98, 'American Express', 'Box 0001', NULL, 'Los Angeles', 'CA', '90096', '(800) 555-3344', 'Story', 'Kirsten', 2, 160),
(99, 'Bertelsmann Industry Svcs. Inc', '28210 N Avenue Stanford', NULL, 'Valencia', 'CA', '91355', '(805) 555-0584', 'Potter', 'Lance', 3, 400),
(100, 'Cahners Publishing Company', 'Citibank Lock Box 4026', '8725 W Sahara Zone 1127', 'The Lake', 'NV', '89163', '(301) 555-2162', 'Jacobsen', 'Samuel', 4, 540),
(101, 'California Business Machines', 'Gallery Plz', '5091 N Fresno', 'Fresno', 'CA', '93710', '(559) 555-5570', 'Rohansen', 'Anders', 2, 170),
(102, 'Coffee Break Service', 'PO Box 1091', NULL, 'Fresno', 'CA', '93714', '(559) 555-8700', 'Smitzen', 'Jeffrey', 4, 570),
(103, 'Dean Witter Reynolds', '9 River Pk Pl E 400', NULL, 'Boston', 'MA', '02134', '(508) 555-8737', 'Johnson', 'Vance', 5, 589),
(104, 'Digital Dreamworks', '5070 N Sixth Ste. 71', NULL, 'Fresno', 'CA', '93711', NULL, 'Elmert', 'Ron', 3, 589),
(105, 'Dristas Groom & McCormick', '7112 N Fresno St Ste 200', NULL, 'Fresno', 'CA', '93720', '(559) 555-8484', 'Aaronsen', 'Thom', 3, 591),
(106, 'Ford Motor Credit Company', 'Dept 0419', NULL, 'Los Angeles', 'CA', '90084', '(800) 555-7000', 'Snyder', 'Karen', 3, 582),
(107, 'Franchise Tax Board', 'PO Box 942857', NULL, 'Sacramento', 'CA', '94257', NULL, 'Prado', 'Anita', 4, 507),
(108, 'Gostanian General Building', '427 W Bedford #102', NULL, 'Fresno', 'CA', '93711', '(559) 555-5100', 'Bragg', 'Walter', 4, 523),
(109, 'Kent H Landsberg Co', 'File No 72686', 'PO Box 61000', 'San Francisco', 'CA', '94160', '(916) 555-8100', 'Stevens', 'Wendy', 3, 540),
(110, 'Malloy Lithographing Inc', '5411 Jackson Road', 'PO Box 1124', 'Ann Arbor', 'MI', '48106', '(313) 555-6113', 'Regging', 'Abe', 3, 400),
(111, 'Net Asset, Llc', '1315 Van Ness Ave Ste. 103', NULL, 'Fresno', 'CA', '93721', NULL, 'Kraggin', 'Laura', 1, 572),
(112, 'Office Depot', 'File No 81901', NULL, 'Los Angeles', 'CA', '90074', '(800) 555-1711', 'Pinsippi', 'Val', 3, 570),
(113, 'Pollstar', '4697 W Jacquelyn Ave', NULL, 'Fresno', 'CA', '93722', '(559) 555-2631', 'Aranovitch', 'Robert', 5, 520),
(114, 'Postmaster', 'Postage Due Technician', '1900 E Street', 'Fresno', 'CA', '93706', '(559) 555-7785', 'Finklestein', 'Fyodor', 1, 552),
(115, 'Roadway Package System, Inc', 'Dept La 21095', NULL, 'Pasadena', 'CA', '91185', NULL, 'Smith', 'Sam', 4, 553),
(116, 'State of California', 'Employment Development Dept', 'PO Box 826276', 'Sacramento', 'CA', '94230', '(209) 555-5132', 'Articunia', 'Mercedez', 1, 631),
(117, 'Suburban Propane', '2874 S Cherry Ave', NULL, 'Fresno', 'CA', '93706', '(559) 555-2770', 'Spivak', 'Harold', 3, 521),
(118, 'Unocal', 'P.O. Box 860070', NULL, 'Pasadena', 'CA', '91186', '(415) 555-7600', 'Bluzinski', 'Rachael', 3, 582),
(119, 'Yesmed, Inc', 'PO Box 2061', NULL, 'Fresno', 'CA', '93718', '(559) 555-0600', 'Hernandez', 'Reba', 2, 589),
(120, 'Dataforms/West', '1617 W. Shaw Avenue', 'Suite F', 'Fresno', 'CA', '93711', NULL, 'Church', 'Charlie', 3, 551),
(121, 'Zylka Design', '3467 W Shaw Ave #103', NULL, 'Fresno', 'CA', '93711', '(559) 555-8625', 'Ronaldsen', 'Jaime', 3, 403),
(122, 'United Parcel Service', 'P.O. Box 505820', NULL, 'Reno', 'NV', '88905', '(800) 555-0855', 'Beauregard', 'Violet', 3, 553),
(123, 'Federal Express Corporation', 'P.O. Box 1140', 'Dept A', 'Memphis', 'TN', '38101', '(800) 555-4091', 'Bucket', 'Charlie', 3, 553)
SET IDENTITY_INSERT Vendors OFF
GO

/****** Object:  Index IX_InvoiceLineItems_AccountNo  ******/
CREATE NONCLUSTERED INDEX IX_InvoiceLineItems_AccountNo ON InvoiceLineItems(
	AccountNo ASC
) 
GO

/****** Object:  Index IX_InvoiceDate ******/
CREATE NONCLUSTERED INDEX IX_InvoiceDate ON Invoices(
	InvoiceDate DESC
)
GO

/****** Object:  Index IX_Invoices_TermsID ******/
CREATE NONCLUSTERED INDEX IX_Invoices_TermsID ON Invoices(
	TermsID ASC
)
GO

/****** Object:  Index IX_Invoices_VendorID ******/
CREATE NONCLUSTERED INDEX IX_Invoices_VendorID ON Invoices(
	VendorID ASC
)
GO

/****** Object:  Index IX_VendorName ******/
CREATE NONCLUSTERED INDEX IX_VendorName ON Vendors(
	VendorName ASC
)
GO

/****** Object:  Index IX_Vendors_AccountNo ******/
CREATE NONCLUSTERED INDEX IX_Vendors_AccountNo ON Vendors(
	DefaultAccountNo ASC
)
GO

/****** Object:  Index IX_Vendors_TermsID ******/
CREATE NONCLUSTERED INDEX IX_Vendors_TermsID ON Vendors(
	DefaultTermsID ASC
)
GO

ALTER TABLE Invoices 
ADD  CONSTRAINT DF_Invoices_PaymentTotal  DEFAULT (0) FOR PaymentTotal
GO

ALTER TABLE Invoices 
ADD  CONSTRAINT DF_Invoices_CreditTotal  DEFAULT (0) FOR CreditTotal
GO

ALTER TABLE Vendors 
ADD  CONSTRAINT DF_Vendors_TermsID  DEFAULT (3) FOR DefaultTermsID
GO

ALTER TABLE Vendors 
ADD  CONSTRAINT DF_Vendors_AccountNo  DEFAULT (570) FOR DefaultAccountNo
GO

ALTER TABLE InvoiceLineItems  
WITH NOCHECK ADD  CONSTRAINT FK_InvoiceLineItems_GLAccounts 
FOREIGN KEY(AccountNo)
REFERENCES GLAccounts (AccountNo)
ON UPDATE CASCADE
GO

ALTER TABLE InvoiceLineItems 
CHECK CONSTRAINT FK_InvoiceLineItems_GLAccounts
GO

ALTER TABLE InvoiceLineItems  
WITH NOCHECK 
ADD CONSTRAINT FK_InvoiceLineItems_Invoices 
FOREIGN KEY(InvoiceID)
REFERENCES Invoices (InvoiceID)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE InvoiceLineItems 
CHECK CONSTRAINT FK_InvoiceLineItems_Invoices
GO

ALTER TABLE Invoices  
WITH NOCHECK 
ADD CONSTRAINT FK_Invoices_Terms 
FOREIGN KEY(TermsID)
REFERENCES Terms (TermsID)
GO

ALTER TABLE Invoices CHECK CONSTRAINT FK_Invoices_Terms
GO

ALTER TABLE Invoices 
WITH NOCHECK 
ADD CONSTRAINT FK_Invoices_Vendors
FOREIGN KEY(VendorID)
REFERENCES Vendors (VendorID)
GO

ALTER TABLE Invoices CHECK CONSTRAINT FK_Invoices_Vendors
GO

ALTER TABLE Vendors 
WITH NOCHECK 
ADD CONSTRAINT FK_Vendors_GLAccounts 
FOREIGN KEY(DefaultAccountNo)
REFERENCES GLAccounts (AccountNo)
GO

ALTER TABLE Vendors
CHECK CONSTRAINT FK_Vendors_GLAccounts
GO

ALTER TABLE Vendors
WITH NOCHECK 
ADD CONSTRAINT FK_Vendors_Terms FOREIGN KEY(DefaultTermsID)
REFERENCES Terms (TermsID)
GO

ALTER TABLE Vendors CHECK CONSTRAINT FK_Vendors_Terms
GO

USE master
GO

ALTER DATABASE AP SET  READ_WRITE 
GO