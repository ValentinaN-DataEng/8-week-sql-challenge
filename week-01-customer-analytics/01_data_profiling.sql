/*
Week 1: Customer Analytics
File: 01_data_profiling.sql
Dataset: UCI Online Retail
Purpose: Understand and validate the raw data
*/

USE Portfolio_SQL_Challenges;
GO

-- Exercise 1: Count missing values
SELECT
    SUM(CASE
        WHEN TRIM(CustomerID) = '' OR CustomerID IS NULL
        THEN 1 ELSE 0
    END) AS CustomerID_blank_null,

    SUM(CASE
        WHEN TRIM(Description) = '' OR Description IS NULL
        THEN 1 ELSE 0
    END) AS Description_blank_null,

    SUM(CASE
        WHEN TRIM(InvoiceDate) = '' OR InvoiceDate IS NULL
        THEN 1 ELSE 0
    END) AS InvoiceDate_blank_null

FROM dbo.OnlineRetail_Raw;


-- Exercise 2: Investigate cancellations and quantities
SELECT
	SUM(CASE
        WHEN InvoiceNo LIKE 'C%'
        THEN 1 ELSE 0
    END) AS Cancellation_rows,
	SUM(CASE
        WHEN TRY_CAST (Quantity AS INT) < 0
        THEN 1 ELSE 0
    END) AS Negative_quantity_rows,
	SUM(CASE
        WHEN TRY_CAST (Quantity AS INT) = 0
        THEN 1 ELSE 0
    END) AS Zero_quantity_rows,
	COUNT (*) AS Total_rows
FROM dbo.OnlineRetail_Raw;


-- Exercise 3: Validate data types
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'OnlineRetail_Raw'
	AND TABLE_SCHEMA = 'dbo'
ORDER BY ORDINAL_POSITION;


-- Exercise 4: Diagnose conversion failures
SELECT
	SUM(
		CASE
			WHEN NULLIF(TRIM(Quantity), '') IS NOT NULL
				AND TRY_CAST(Quantity AS INT) IS NULL
			THEN 1
			ELSE 0
		END
	) AS Quantity_Invalid,
	SUM(
		CASE
			WHEN NULLIF(TRIM(UnitPrice), '') IS NOT NULL
				AND TRY_CAST(REPLACE(UnitPrice, ',', '.') AS DECIMAL(10,2)) IS NULL
			THEN 1
			ELSE 0
		END
	)AS UnitPrice_Invalid,
	SUM(
		CASE
			WHEN NULLIF(TRIM(InvoiceDate), '') IS NOT NULL
				AND TRY_CONVERT(DATETIME, InvoiceDate, 103) IS NULL
			THEN 1
			ELSE 0
		END
	)AS InvoiceDate_Invalid
FROM dbo.OnlineRetail_Raw;


-- Exercise 5: Inspect conversion failures.
--(Diagonostic) This Query demonstrates the Decimal-format problem
SELECT TOP (20)
    UnitPrice,
    TRY_CAST(UnitPrice AS DECIMAL(10,2)) AS ConvertedPrice
FROM dbo.OnlineRetail_Raw
WHERE UnitPrice IS NOT NULL
  AND TRY_CAST(UnitPrice AS DECIMAL(10,2)) IS NULL;

 --(Diagonostic) This Query demonstrates the Date-format problem
SELECT TOP (20)
    InvoiceDate,
    TRY_CAST(InvoiceDate AS DATETIME) AS ConvertedDate
FROM dbo.OnlineRetail_Raw
WHERE InvoiceDate IS NOT NULL
  AND TRY_CAST(InvoiceDate AS DATETIME) IS NULL;

 --Tests the corrected conversion on values that failed the original conversion
SELECT TOP (20)
    UnitPrice,
    TRY_CAST(
        REPLACE(UnitPrice, ',', '.') AS DECIMAL(10,2)
    ) AS ConvertedPrice
FROM dbo.OnlineRetail_Raw
WHERE UnitPrice IS NOT NULL
	AND TRY_CAST(UnitPrice AS DECIMAL(10,2)) IS NULL;

 --Tests the corrected conversion on values that failed the original conversion
SELECT TOP (20)
    InvoiceDate,
    TRY_CONVERT(
        DATETIME,
        InvoiceDate,
        103
    ) AS ConvertedDate
FROM dbo.OnlineRetail_Raw
WHERE InvoiceDate IS NOT NULL
	AND TRY_CAST (InvoiceDate AS DATETIME) IS NULL;