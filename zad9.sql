use AdventureWorksDW2019

SELECT * FROM FactInternetSales;

--8a
SELECT OrderDate, COUNT(OrderQuantity) as Orders_cnt  FROM dbo.FactInternetSales GROUP BY OrderDate HAVING COUNT(OrderQuantity) < 100 ORDER BY Orders_cnt DESC;

--8b
WITH sortedProducts AS (
    SELECT
        ProductKey,
        UnitPrice,
		OrderDate,
		OrderQuantity,
        ROW_NUMBER() OVER (PARTITION BY OrderDate ORDER BY UnitPrice DESC) AS RowNum
    FROM
        dbo.FactInternetSales
)
SELECT
	ProductKey,
    OrderDate,
    UnitPrice
FROM
    sortedProducts
WHERE
    RowNum <= 3
ORDER BY OrderDate;

