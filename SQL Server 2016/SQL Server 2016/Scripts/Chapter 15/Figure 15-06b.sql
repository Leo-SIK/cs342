USE AP;

DECLARE @InvCount int;
EXEC @InvCount = spInvCount '2016-02-01', 'P%';
PRINT 'Invoice count: ' + CONVERT(varchar, @InvCount);