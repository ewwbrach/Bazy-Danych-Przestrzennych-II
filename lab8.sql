use AdventureWorksDW2019;

CREATE TABLE AdventureWorksDW2019.dbo.AUDIT_TABLE (
    JobID INT,
    startDT DATETIME,
	endDT DATETIME,
	Rowcnt INT
  
);



drop table dbo.AUDIT_TABLE;

truncate table dbo.CSV_Customers;

truncate table dbo.AUDIT_TABLE;

select * from dbo.AUDIT_TABLE;

select * from dbo.CSV_Customers;

INSERT INTO AdventureWorksDW2019.dbo.AUDIT_TABLE (startDT, JobID, endDT, Rowcnt) VALUES (GETDATE(), Package::JobNum, NULL, (select count(1) from dbo.CSV_Customers));