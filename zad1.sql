-- a) definicja tabeli w bazie Oracle

-- Przyk³ad 1: U¿ywaj¹c ALL_TAB_COLUMNS
SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH
FROM ALL_TAB_COLUMNS
WHERE TABLE_NAME = 'FactInternetSales';

-- Przyk³ad 2: U¿ywaj¹c DESCRIBE
DESCRIBE FactInternetSales;

--b) definicja tabeli w bazie PostgreSQL

SELECT * FROM information_schema.columns
WHERE table_name = 'dbo.FactInternetSales';

--c) definicja tabeli w bazie MySQL

DESCRIBE AdventureWorksDW2019.dbo.FactInternetSales;
-- lub
SHOW COLUMNS FROM AdventureWorksDW2019.dbo.FactInternetSales;