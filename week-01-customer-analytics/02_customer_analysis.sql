/*
Week 1: Customer Analytics
File: 02_customer_analysis.sql
Dataset: UCI Online Retail
Purpose: ____
*/

USE Portfolio_SQL_Challenges;
GO

--Exercise 1: Customer spending
SELECT
	COUNT (DISTINCT NULLIF(TRIM(CustomerID),' ')) AS Unique_CustomerID
FROM dbo.OnlineRetail_Raw;


;WITH cast_base_data AS (
	SELECT
		CustomerID,
		TRY_CAST (Quantity AS INT) AS Quantity_int,
		TRY_CAST (REPLACE (UnitPrice, ',', '.') AS  DECIMAL (10,2)) AS UnitPrice_dec
	FROM dbo.OnlineRetail_Raw
),
total_revenue AS (
	SELECT
		CustomerID,
		SUM (Quantity_int) AS Total_Quantity,
		SUM (Quantity_int * UnitPrice_dec) AS Total_Revenue
	FROM cast_base_data
	WHERE NULLIF(TRIM(CustomerID), '') IS NOT NULL
	GROUP BY CustomerID
)


--Exercise 2: Identify the top 10 customers by net revenue
SELECT TOP (10)
	CustomerID,
	Total_Quantity AS Total_Net_Quantity,
	Total_Revenue AS Total_Net_Revenue
FROM total_revenue
ORDER BY Total_Net_Revenue DESC;


--Exercise 3: Gross revenue vs. net revenue
SELECT
	SUM(CASE
        WHEN InvoiceNo LIKE 'C%'
        THEN 1 
		ELSE 0
		END
	) AS Cancellation_rows,
	SUM (CASE
		WHEN TRY_CAST (Quantity AS INT) < 0
		THEN 1
		ELSE 0
		END
	) AS Negative_Quantity
FROM dbo.OnlineRetail_Raw;

;WITH cast_base_data AS (
	SELECT
		CustomerID,
		TRY_CAST (Quantity AS INT) AS Quantity_int,
		TRY_CAST (REPLACE (UnitPrice, ',', '.') AS  DECIMAL (10,2)) AS UnitPrice_dec
	FROM dbo.OnlineRetail_Raw
),
transaction_value AS (
	SELECT
		SUM (CASE
			WHEN Quantity_int>0
			THEN Quantity_int * UnitPrice_dec
			ELSE 0
		END) AS Gross_Transaction_value,
		SUM (Quantity_int * UnitPrice_dec) AS Net_Transaction_Value
	FROM cast_base_data
)

SELECT 
	Gross_Transaction_Value,
	Net_Transaction_Value,
	Gross_Transaction_value - Net_Transaction_Value  AS Transaction_Value_Difference,
	(Gross_Transaction_value - Net_Transaction_Value) /NULLIF(Gross_Transaction_value,0) * 100 AS Reduction_Percentage
FROM transaction_value;


--Exercise 4: Customer purchasing behavior

;WITH cast_info AS (
	SELECT
		CustomerID,
		TRY_CAST (Quantity AS INT) AS Quantity_int,
		TRY_CAST (REPLACE (UnitPrice, ',', '.') AS  DECIMAL (10,2)) AS UnitPrice_dec,
		InvoiceNo
	FROM dbo.OnlineRetail_Raw
),
transaction_value AS (
	SELECT 
		CustomerID,
		SUM (Quantity_int) AS Total_Net_Quantity,
		SUM (Quantity_int * UnitPrice_dec) AS Total_Net_Revenue,
		AVG (UnitPrice_dec) AS Average_Unit_Price,
		COUNT (DISTINCT InvoiceNo) AS Total_Orders 
	FROM cast_info
	WHERE NULLIF(TRIM(CustomerID), '') IS NOT NULL
	GROUP BY CustomerID
)

SELECT TOP (10) 
	CustomerID,
	Total_Net_Quantity,
	Total_Net_Revenue,
	Average_Unit_Price,
	1.0 * Total_Net_Revenue / NULLIF (Total_Net_Quantity,0) AS Revenue_per_Net_Unit,
	Total_Orders,
	1.0 * Total_Net_Revenue / NULLIF(Total_Orders,0) AS Average_Net_Revenue_Per_Order
FROM transaction_value
ORDER BY Total_Net_Revenue DESC;


-- Week 1 — Final data quality validation
SELECT
    SUM(CASE
        WHEN NULLIF(TRIM(Quantity), '') IS NOT NULL
         AND TRY_CAST(Quantity AS INT) IS NULL
        THEN 1 ELSE 0
    END) AS Invalid_Quantity,

    SUM(CASE
        WHEN NULLIF(TRIM(UnitPrice), '') IS NOT NULL
         AND TRY_CAST(REPLACE(UnitPrice, ',', '.') AS DECIMAL(10,2)) IS NULL
        THEN 1 ELSE 0
    END) AS Invalid_UnitPrice,

    SUM(CASE
        WHEN NULLIF(TRIM(InvoiceDate), '') IS NOT NULL
         AND TRY_CONVERT(DATETIME, InvoiceDate, 103) IS NULL
        THEN 1 ELSE 0
    END) AS Invalid_InvoiceDate
FROM dbo.OnlineRetail_Raw;
