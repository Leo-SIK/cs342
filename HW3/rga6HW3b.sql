-- Roy Adams
-- SQL Homework03b

-- Setup
USE AP
GO

-- 1a.
SELECT DISTINCT VendorContactLName + ', ' + VendorContactFName AS VendorName
FROM Vendors
INNER JOIN Invoices
	ON Vendors.VendorID = Invoices.VendorID

SELECT DISTINCT VendorContactLName + ', ' + VendorContactFName AS VendorName
FROM Vendors
FULL OUTER JOIN Invoices
	ON Vendors.VendorID = Invoices.VendorID
WHERE Invoices.VendorID IS NOT NULL

SELECT VendorName
FROM Vendors
WHERE VendorID IN
	(SELECT VendorID FROM Invoices)

SELECT v.VendorName
FROM Vendors v
WHERE EXISTS (SELECT 1
		     FROM Invoices i
			 WHERE i.VendorID = v.VendorID)

SELECT DISTINCT
	CASE
		WHEN i.InvoiceID IS NOT NULL THEN v.VendorName
		ELSE ''
	END
	FROM Vendors v 
	LEFT JOIN Invoices i
		ON v.VendorID = i.VendorID

-- 1b.
SELECT InvoiceNumber
	, InvoiceTotal
FROM Invoices
WHERE PaymentTotal >
     (SELECT (AVG(PaymentTotal) + MIN(PaymentTotal)) / 2
      FROM Invoices
      WHERE PaymentTotal != 0)

-- 1c.
SELECT i.InvoiceNumber
	, i.InvoiceTotal
	, i.VendorID
	, s_i.InvCnt
FROM Invoices i
INNER JOIN
	(SELECT VendorID
		, COUNT(*) AS InvCnt
	FROM Invoices
	GROUP BY VendorID) AS s_i
	ON s_i.vendorID = i.VendorID
WHERE PaymentTotal >
     (SELECT (AVG(PaymentTotal) + MIN(PaymentTotal)) / 2
      FROM Invoices
      WHERE PaymentTotal != 0)

-- 2.
USE AdventureWorks2012
GO

WITH ProductCTE AS
(
		SELECT BillOfMaterialsID
			, BOMLevel AS BLevel
			, ProductAssemblyID
			, ComponentID
			, PerAssemblyQty
		FROM Production.BillOfMaterials
		WHERE ProductAssemblyID = 728
	UNION ALL
		SELECT bom.BillOfMaterialsID
			, bom.BOMLevel
			, bom.ProductAssemblyID
			, bom.ComponentID
			, bom.PerAssemblyQty
		FROM Production.BillOfMaterials as bom
		JOIN ProductCTE
			ON bom.ProductAssemblyID = ProductCTE.ComponentID
)
SELECT *
FROM ProductCTE;

-- Extra Credit
WITH ProductCTE AS
(
		SELECT BillOfMaterialsID
			, BOMLevel AS BLevel
			, ProductAssemblyID
			, ComponentID
			, PerAssemblyQty
		FROM Production.BillOfMaterials
		WHERE ProductAssemblyID = 728
	UNION ALL
		SELECT bom.BillOfMaterialsID
			, bom.BOMLevel
			, bom.ProductAssemblyID
			, bom.ComponentID
			, bom.PerAssemblyQty
		FROM Production.BillOfMaterials as bom
		JOIN ProductCTE
			ON bom.ProductAssemblyID = ProductCTE.ComponentID
)
SELECT BLevel
	, assembly.Name as "Assembly"
	, component.Name as "Component Needed"
	, PerAssemblyQty
FROM ProductCTE
INNER JOIN Production.Product AS assembly
	ON assembly.ProductID = ProductCTE.ProductAssemblyID
INNER JOIN Production.Product AS component
	ON component.ProductID = ProductCTE.ComponentID;