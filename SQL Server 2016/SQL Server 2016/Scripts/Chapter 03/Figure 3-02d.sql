USE AP;

SELECT InvoiceNumber, InvoiceDate, InvoiceTotal
FROM Invoices
WHERE InvoiceDate BETWEEN '2016-01-01' AND '2016-05-31'
ORDER BY InvoiceDate;

