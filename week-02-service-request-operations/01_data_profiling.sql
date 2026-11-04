-- =============================================
-- WEEK 02: SERVICE REQUEST OPERATIONS
-- File: 01_data_profiling.sql
-- Dataset: NYC 311 - January 2025
-- =============================================

USE NYC_311_Analysis;
GO

-- =============================================
-- PART 1: DATA COMPLETENESS
-- =============================================


--1.1 Missing values by column
SELECT
    COUNT(*) AS Total_Rows,

    --Missing UniqueKey
	SUM(CASE WHEN NULLIF(TRIM (UniqueKey), '') is NULL 
		THEN 1
		ELSE 0
		END) AS Missing_UniqueKey,

	-- Missing CreatedDate
	SUM(CASE WHEN NULLIF(TRIM (CreatedDate), '') is NULL 
		THEN 1
		ELSE 0
		END) AS Missing_CreatedDate,
	
	-- Missing ClosedDate
    SUM(CASE WHEN NULLIF(TRIM (ClosedDate), '') is NULL 
		THEN 1
		ELSE 0
		END) AS Missing_ClosedDate,

    -- Missing Agency
	SUM(CASE WHEN NULLIF(TRIM (Agency), '') is NULL 
		THEN 1
		ELSE 0
		END) AS Missing_Agency,

    -- Missing ComplaintType
	SUM(CASE WHEN NULLIF(TRIM (ComplaintType), '') is NULL 
		THEN 1
		ELSE 0
		END) AS Missing_ComplaintType,

    -- Missing Descriptor
	SUM(CASE WHEN NULLIF(TRIM (Descriptor), '') is NULL 
		THEN 1
		ELSE 0
		END) AS Missing_Descriptor,

    -- Missing Status
	SUM(CASE WHEN NULLIF(TRIM (Status), '') is NULL 
		THEN 1
		ELSE 0
		END) AS Missing_Status,

    -- Missing Borough
	SUM(CASE WHEN NULLIF(TRIM (Borough), '') is NULL 
		THEN 1
		ELSE 0
		END) AS Missing_Borough

FROM dbo.NYC_311_Raw;


--1.2 Missing closure dates by status
WITH Status_Values AS (
SELECT
	Status,
	COUNT (*) AS Total_Requests,
	SUM(CASE WHEN NULLIF(TRIM (ClosedDate), '') is NULL 
		THEN 1
		ELSE 0
		END) AS Req_Missing_ClosedDate
FROM dbo.NYC_311_Raw
GROUP BY Status
)

SELECT 
	Status,
    Total_Requests,
    Req_Missing_ClosedDate,
	CAST ((Req_Missing_ClosedDate*100.0/ Total_Requests) AS DECIMAL (10,2)) AS Missing_Closure_Rate 
FROM Status_Values
ORDER BY Missing_Closure_Rate DESC;


--1.3 Missing closure dates by agency
SELECT
	Agency,
	COUNT (*) AS Missing_ClosedDate,
	CAST (COUNT(*)* 100.0 / 1051 AS DECIMAL (10,2)) AS Ptge
FROM dbo.NYC_311_Raw
WHERE Status = 'Closed'
  AND NULLIF(TRIM(ClosedDate), '') IS NULL
GROUP BY Agency
ORDER BY COUNT (*) DESC;

--1.4 Missing closure dates by complaint type
SELECT
	ComplaintType,
	COUNT (*) AS Missing_ClosedDate,
	CAST (COUNT(*)* 100.0 / 1051 AS DECIMAL (10,2)) AS Ptge
FROM dbo.NYC_311_Raw
WHERE Status = 'Closed'
  AND NULLIF(TRIM(ClosedDate), '') IS NULL
GROUP BY ComplaintType
ORDER BY COUNT (*) DESC;

--1.5 DHS closure-date investigation
SELECT
    Agency,
    Status,
    COUNT(*) AS Total_Requests,
    SUM(
        CASE
            WHEN NULLIF(TRIM(ClosedDate), '') IS NULL
            THEN 1
            ELSE 0
        END
    ) AS Missing_ClosedDate
FROM dbo.NYC_311_Raw
WHERE Agency = 'DHS'
GROUP BY Agency, Status
ORDER BY Status;

--Investigate the creation dates
SELECT
    MIN(TRY_CONVERT(DATETIME2, CreatedDate)) AS First_Request,
    MAX(TRY_CONVERT(DATETIME2, CreatedDate)) AS Last_Request,
    COUNT(*) AS Total_Requests
FROM dbo.NYC_311_Raw
WHERE Agency = 'DHS'
    AND Status = 'Closed'
    AND ComplaintType = 'Homeless Person Assistance'
    AND NULLIF(TRIM(ClosedDate), '') IS NULL;

--Investigate the monthly distribution of all DHS Homeless Person Assitance requests
SELECT
    LEFT(CreatedDate, 7) AS Request_Month,
    Status,
    COUNT(*) AS Total_Requests,
    SUM(
        CASE
            WHEN NULLIF(TRIM(ClosedDate), '') IS NULL
            THEN 1
            ELSE 0
        END
    ) AS Missing_ClosedDate
FROM dbo.NYC_311_Raw
WHERE Agency = 'DHS'
    AND ComplaintType = 'Homeless Person Assistance'
GROUP BY LEFT(CreatedDate, 7), Status
ORDER BY Request_Month, Status;


-- Business question:
-- Is missing closure-date information concentrated
-- in a particular DHS complaint category?

WITH Compare_ClosedDate AS (
    SELECT
        ComplaintType,
        SUM(
            CASE
                WHEN Status = 'Closed' THEN 1
                ELSE 0
            END
        ) AS Total_Closed_Requests,
        SUM(
            CASE
                WHEN Status = 'Closed'
                 AND NULLIF(TRIM(ClosedDate), '') IS NULL
                THEN 1
                ELSE 0
            END
        ) AS Missing_ClosedDate
    FROM dbo.NYC_311_Raw
    WHERE Agency = 'DHS'
    GROUP BY ComplaintType
)

SELECT
    ComplaintType,
    Total_Closed_Requests,
    Missing_ClosedDate,
    CAST(
        Missing_ClosedDate * 100.0 /
        NULLIF(Total_Closed_Requests, 0)
        AS DECIMAL(10,2)
    ) AS Missing_Closure_Rate
FROM Compare_ClosedDate
ORDER BY Missing_Closure_Rate DESC;

-- =============================================
-- PART 2: DUPLICATE VALIDATION
-- =============================================

-- Business question: Does each service request have a unique identifier?

--2.1 Identify duplicate request IDs
SELECT
    UniqueKey,
    COUNT(*) AS Occurrences
FROM dbo.NYC_311_Raw
GROUP BY UniqueKey
HAVING COUNT(*) > 1
ORDER BY Occurrences DESC;

--2.2 Quantify duplicate records
WITH Quantify_UniqueKey  AS (
SELECT
    UniqueKey,
    COUNT(*) AS Occurrences
FROM dbo.NYC_311_Raw
GROUP BY UniqueKey
)

SELECT 
	COUNT (*) AS Duplicated_Identifiers,
	COALESCE(SUM(Occurrences - 1), 0) AS Excess_Records,
    COALESCE(SUM(Occurrences), 0) AS Records_In_Duplicate_Groups
FROM Quantify_UniqueKey
WHERE Occurrences > 1;

-- =============================================
-- PART 3: DATE VALIDATION
-- =============================================

--Business question: Can all creation and closure dates be converted into valid SQL Server date values?
SELECT
	COUNT (*) Total_Records,
	SUM (CASE WHEN NULLIF(TRIM(CreatedDate), '') IS NOT NULL AND TRY_CONVERT(DATETIME2, CreatedDate) IS NULL
		THEN 1
		ELSE 0 
		END) AS Fail_Convert_CreatedDate,
		SUM (CASE WHEN NULLIF(TRIM(ClosedDate), '') IS NOT NULL AND TRY_CONVERT(DATETIME2, ClosedDate) IS NULL
		THEN 1
		ELSE 0 
		END) AS Fail_Convert_ClosedDate,
	SUM (CASE WHEN NULLIF(TRIM(CreatedDate), '') IS NULL
		THEN 1
		ELSE 0
		END) AS Missing_CreationDate,
	SUM (CASE WHEN NULLIF(TRIM(ClosedDate), '') IS NULL
		THEN 1
		ELSE 0
		END) AS Missing_ClosedDate
FROM dbo.NYC_311_Raw


--Business question: Are there service requests whose closure date is earlier than their creation date?
;WITH Date_Info AS (
	SELECT
		UniqueKey,
		TRY_CONVERT(DATETIME2,NULLIF(TRIM(CreatedDate),'')) AS Created_Date,
		TRY_CONVERT(DATETIME2,NULLIF(TRIM(ClosedDate),'')) AS Closed_Date
	FROM dbo.NYC_311_Raw
)
SELECT 
	UniqueKey,
	Created_Date,
	Closed_Date,
	DATEDIFF (MINUTE,Created_Date,Closed_Date) AS Resolution_Minutes
FROM Date_Info
WHERE Created_Date IS NOT NULL
    AND Closed_Date IS NOT NULL
    AND Closed_Date < Created_Date
ORDER BY Resolution_Minutes;


--Original values for dates
SELECT TOP 20
    UniqueKey,
    CreatedDate,
    ClosedDate
FROM dbo.NYC_311_Raw
WHERE NULLIF(TRIM(ClosedDate), '') IS NULL;

--Quantify chronological inconsistencies
--What percentage of service requests with valid creation and closure dates have a negative resolution time?

;WITH Date_Info AS (
    SELECT
        UniqueKey,
        TRY_CONVERT(
            DATETIME2,
            NULLIF(TRIM(CreatedDate), '')
        ) AS Created_Date,
        TRY_CONVERT(
            DATETIME2,
            NULLIF(TRIM(ClosedDate), '')
        ) AS Closed_Date
    FROM dbo.NYC_311_Raw
),

Date_Validation AS (
    SELECT
        UniqueKey,
        Created_Date,
        Closed_Date,
        DATEDIFF(
            MINUTE,
            Created_Date,
            Closed_Date
        ) AS Resolution_Minutes
    FROM Date_Info
    WHERE Created_Date IS NOT NULL
      AND Closed_Date IS NOT NULL
)

SELECT
    COUNT(*) AS Valid_Date_Pairs,
    SUM(
        CASE
            WHEN Resolution_Minutes < 0 THEN 1
            ELSE 0
        END
    ) AS Negative_Resolution_Times,
    CAST(
        SUM(
            CASE
                WHEN Resolution_Minutes < 0 THEN 1.0
                ELSE 0.0
            END
        ) * 100.0 / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS Negative_Resolution_Rate
FROM Date_Validation;


-- Negative resolution times by agency

;WITH Date_Info AS (
    SELECT
        UniqueKey,
        Agency,
        TRY_CONVERT(
            DATETIME2,
            NULLIF(TRIM(CreatedDate), '')
        ) AS Created_Date,
        TRY_CONVERT(
            DATETIME2,
            NULLIF(TRIM(ClosedDate), '')
        ) AS Closed_Date
    FROM dbo.NYC_311_Raw
),

Date_Validation AS (
    SELECT
        UniqueKey,
        Agency,
        DATEDIFF(
            MINUTE,
            Created_Date,
            Closed_Date
        ) AS Resolution_Minutes
    FROM Date_Info
    WHERE Created_Date IS NOT NULL
      AND Closed_Date IS NOT NULL
)

SELECT
    Agency,
    COUNT(*) AS Invalid_Requests,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS Percentage

FROM Date_Validation
WHERE Resolution_Minutes < 0
GROUP BY Agency
ORDER BY Invalid_Requests DESC;
