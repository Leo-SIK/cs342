USE AP;

-- drop the stored procedure
IF OBJECT_ID('GetTop10Vendors') IS NOT NULL
    DROP PROC GetTop10Vendors;

-- drop the assembly
IF ASSEMBLYPROPERTY('ApExClrObjects', 'SimpleName') IS NOT NULL
    DROP ASSEMBLY ApExClrObjects;