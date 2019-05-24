USE AP;
DECLARE @InvoiceTotalSum money;
EXEC GetInvoiceTotalSum
	@InvoiceTotalSum OUTPUT, 
	@StartDate = '2016-01-01', 
	@VendorName = 'P%';
PRINT '$' + CONVERT(varchar, @InvoiceTotalSum, 1);
