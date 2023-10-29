--Change Log
--Autor: Ewelina Brach
--nr indeksu: 400444
--Data utworzenia: 27.10.2023
--Modyfikacja: 29.10.2023


USE AdventureWorksDW2019;


CREATE PROCEDURE GetCurrencyRatesByYearsAgo
	@code1 VARCHAR(10),
	@code2 VARCHAR(10),
    @YearsAgo INT
AS
BEGIN
    
    DECLARE @StartDate DATE
    SET @StartDate = DATEADD(YEAR, -@YearsAgo, GETDATE())
    SELECT FCR.CurrencyKey, FCR.AverageRate
    FROM dbo.FactCurrencyRate AS FCR, dbo.DimCurrency AS DC where FCR.CurrencyKey = DC.CurrencyKey
    and  ( DC.CurrencyAlternateKey = @code1 or DC.CurrencyAlternateKey =  @code2)
    AND FCR.Date <= @StartDate;
END

EXEC GetCurrencyRatesByYearsAgo @code1 = 'GBP', @code2 = 'EUR', @YearsAgo = 8;

DROP PROCEDURE GetCurrencyRatesByYearsAgo;


select * from FactCurrencyRate
select * from DimCurrency

select * from FactCurrencyRate where DATEDIFF("year",Date,GETDATE()) = 10;

