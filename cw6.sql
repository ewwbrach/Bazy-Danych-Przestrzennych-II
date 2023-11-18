use AdventureWorksDW2019;

--2a, 2b

IF OBJECT_ID('dbo.stg_dimemp', 'U') IS NOT NULL
    PRINT 'Tabela ju¿ istnieje';
ELSE
	select EmployeeKey, FirstName, LastName, Title into AdventureWorksDW2019.dbo.stg_dimemp from dbo.DimEmployee
	where EmployeeKey between 270 and 275;
    


select * from dbo.stg_dimemp;

--drop table stg_dimemp

--2c

IF OBJECT_ID('dbo.scd_dimemp', 'U') IS NOT NULL
    PRINT 'Tabela ju¿ istnieje';
ELSE
	CREATE TABLE AdventureWorksDW2019.dbo.scd_dimemp (
	EmployeeKey int ,
	FirstName nvarchar(50) not null,
	LastName nvarchar(50) not null,
	Title nvarchar(50),
	StartDate datetime,
	EndDate datetime,
	PRIMARY KEY(EmployeeKey)
	);



IF OBJECT_ID('dbo.scd_dimemp', 'U') IS NOT NULL
    PRINT 'Tabela ju¿ istnieje';
ELSE
	select EmployeeKey, FirstName, LastName, Title into AdventureWorksDW2019.dbo.scd_dimemp from dbo.DimEmployee
	where EmployeeKey between 270 and 275;

select * from dbo.scd_dimemp;

drop table dbo.scd_dimemp;

--5b
update STG_DimEmp
set LastName = 'Nowak'
where EmployeeKey = 270;

update STG_DimEmp
set TITLE = 'Senior Design Engineer'
where EmployeeKey = 274;

update STG_DimEmp
set FIRSTNAME = 'Ryszard'
where EmployeeKey = 275


-- 6
-- zadanie 5b LastName to SCD 1 
-- zadanie 5b Title to SCD 2 
-- zadanie 5c FirstName to SCD 0 

-- 7
-- z powodu ustawienia Fail the transformation if changes are detected in a fixed attribute, po wykonaniu UPDATE, 
-- proces zakoñczyl sie niepoodzeniem.