-- a) definicja tabeli w bazie Oracle

-- Przyk�ad 1: U�ywaj�c ALL_TAB_COLUMNS
SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH
FROM ALL_TAB_COLUMNS
WHERE TABLE_NAME = 'FactInternetSales';

-- Przyk�ad 2: U�ywaj�c DESCRIBE
DESCRIBE FactInternetSales;

--b) definicja tabeli w bazie PostgreSQL

SELECT * FROM information_schema.columns
WHERE table_name = 'dbo.FactInternetSales';

--c) definicja tabeli w bazie MySQL

DESCRIBE AdventureWorksDW2019.dbo.FactInternetSales;
-- lub
SHOW COLUMNS FROM AdventureWorksDW2019.dbo.FactInternetSales;