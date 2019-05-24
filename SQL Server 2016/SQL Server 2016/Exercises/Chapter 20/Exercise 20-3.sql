USE AP;
GO

CREATE PROC GetTop10Vendors
AS
EXTERNAL NAME ApExClrObjects.StoredProcedures.GetTop10Vendors;