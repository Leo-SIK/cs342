-- Roy Adams
-- SQL Homework (Week 3)

-- Setup
USE AP
GO

-- 1. 
SELECT Invoices.VendorID
	, Vendors.VendorName
	, Vendors.VendorState
	, SUM(Invoices.PaymentTotal) AS PaymentSum
FROM Invoices
INNER JOIN Vendors
	ON Vendors.VendorID = Invoices.VendorID
GROUP BY Invoices.VendorID
	, Vendors.VendorName
	, Vendors.VendorState;

-- 2.
SELECT GLAccounts.AccountDescription
	, COUNT(*) AS LineItemCount
    , SUM(InvoiceLineItemAmount) AS LineItemSum
	, AVG(InvoiceLineItemAmount) AS LineItemAvg
FROM GLAccounts
INNER JOIN InvoiceLineItems
  ON GLAccounts.AccountNo = InvoiceLineItems.AccountNo
GROUP BY GLAccounts.AccountDescription
HAVING COUNT(*) > 1
ORDER BY LineItemCount DESC;

-- Switch to pubs database
USE pubs
GO

-- 3.
SELECT job_lvl
	, COUNT(*) AS "Number of Employees"
FROM employee
GROUP BY job_lvl
ORDER BY COUNT(*) DESC

-- 4. 
SELECT job_lvl
	, MIN(hire_date) AS "Oldest Hire Date"
FROM employee
GROUP BY job_lvl
HAVING COUNT(*) >= 3
ORDER BY MIN(hire_date) ASC