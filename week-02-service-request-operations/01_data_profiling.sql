-- ============================================================
-- WEEK 02: SERVICE REQUEST OPERATIONS
-- File: 01_data_profiling.sql
-- Dataset: NYC 311 - January 2025
-- Database: NYC_311_Analysis
-- ============================================================

USE NYC_311_Analysis;
GO

-- ============================================================
-- PART 1: DATA COMPLETENESS
-- ============================================================

-- 1.1 Missing values by column

SELECT
    COUNT(*) AS Total_Rows,

    SUM(CASE
        WHEN NULLIF(TRIM(UniqueKey), '') IS NULL THEN 1
        ELSE 0
    END) AS Missing_UniqueKey,

    SUM(CASE
        WHEN NULLIF(TRIM(CreatedDate), '') IS NULL THEN 1
        ELSE 0
    END) AS Missing_CreatedDate,

    SUM(CASE
        WHEN NULLIF(TRIM(ClosedDate), '') IS NULL THEN 1
        ELSE 0
    END) AS Missing_ClosedDate,

    SUM(CASE
        WHEN NULLIF(TRIM(Agency), '') IS NULL THEN 1
        ELSE 0
    END) AS Missing_Agency,

    SUM(CASE
        WHEN NULLIF(TRIM(ComplaintType), '') IS NULL THEN 1
        ELSE 0
    END) AS Missing_ComplaintType,

    SUM(CASE
        WHEN NULLIF(TRIM(Descriptor), '') IS NULL THEN 1
        ELSE 0
    END) AS Missing_Descriptor,

    SUM(CASE
        WHEN NULLIF(TRIM(Status), '') IS NULL THEN 1
        ELSE 0
    END) AS Missing_Status,

    SUM(CASE
        WHEN NULLIF(TRIM(Borough), '') IS NULL THEN 1
        ELSE 0
    END) AS Missing_Borough

FROM dbo.NYC_311_Raw;


-- 1.2 Missing closure dates by request status
-- Business question:
-- Are missing closure dates concentrated in particular statuses?

;WITH Status_Values AS (
    SELECT
        Status,
        COUNT(*) AS Total_Requests,

        SUM(CASE
            WHEN NULLIF(TRIM(ClosedDate), '') IS NULL THEN 1
            ELSE 0
        END) AS Missing_ClosedDate

    FROM dbo.NYC_311_Raw
    GROUP BY Status
)

SELECT
    Status,
    Total_Requests,
    Missing_ClosedDate,

    CAST(
        Missing_ClosedDate * 100.0 /
        NULLIF(Total_Requests, 0)
        AS DECIMAL(10,2)
    ) AS Missing_Closure_Rate

FROM Status_Values
ORDER BY Missing_Closure_Rate DESC;


-- 1.3 Distribution of missing closure dates by agency
-- Business question:
-- Which agencies account for the largest share of
-- closed requests with missing closure dates?

SELECT
    Agency,
    COUNT(*) AS Missing_ClosedDate,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS Share_of_Missing_ClosedDate

FROM dbo.NYC_311_Raw
WHERE Status = 'Closed'
  AND NULLIF(TRIM(ClosedDate), '') IS NULL
GROUP BY Agency
ORDER BY Missing_ClosedDate DESC;


-- 1.4 Distribution of missing closure dates by complaint type
-- Business question:
-- Which complaint categories account for the largest share
-- of closed requests with missing closure dates?

SELECT
    ComplaintType,
    COUNT(*) AS Missing_ClosedDate,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS Share_of_Missing_ClosedDate

FROM dbo.NYC_311_Raw
WHERE Status = 'Closed'
  AND NULLIF(TRIM(ClosedDate), '') IS NULL
GROUP BY ComplaintType
ORDER BY Missing_ClosedDate DESC;


-- 1.5 Investigate missing closure dates within DHS
-- Business question:
-- How are DHS requests distributed across statuses?

SELECT
    Agency,
    Status,
    COUNT(*) AS Total_Requests,

    SUM(CASE
        WHEN NULLIF(TRIM(ClosedDate), '') IS NULL THEN 1
        ELSE 0
    END) AS Missing_ClosedDate

FROM dbo.NYC_311_Raw
WHERE Agency = 'DHS'
GROUP BY Agency, Status
ORDER BY Status;


-- 1.6 Investigate creation dates of DHS requests
-- Business question:
-- When were DHS requests with a Closed status but
-- missing closure dates created?

SELECT
    MIN(
        TRY_CONVERT(
            DATETIME2,
            NULLIF(TRIM(CreatedDate), '')
        )
    ) AS First_Request,

    MAX(
        TRY_CONVERT(
            DATETIME2,
            NULLIF(TRIM(CreatedDate), '')
        )
    ) AS Last_Request,

    COUNT(*) AS Total_Requests

FROM dbo.NYC_311_Raw
WHERE Agency = 'DHS'
  AND Status = 'Closed'
  AND ComplaintType = 'Homeless Person Assistance'
  AND NULLIF(TRIM(ClosedDate), '') IS NULL;


-- 1.7 Investigate monthly distribution of DHS
-- Homeless Person Assistance requests

SELECT
    LEFT(CreatedDate, 7) AS Request_Month,
    Status,
    COUNT(*) AS Total_Requests,

    SUM(CASE
        WHEN NULLIF(TRIM(ClosedDate), '') IS NULL THEN 1
        ELSE 0
    END) AS Missing_ClosedDate

FROM dbo.NYC_311_Raw
WHERE Agency = 'DHS'
  AND ComplaintType = 'Homeless Person Assistance'
GROUP BY
    LEFT(CreatedDate, 7),
    Status
ORDER BY
    Request_Month,
    Status;


-- 1.8 Compare closure-date completeness across DHS complaint types
-- Business question:
-- Is missing closure-date information concentrated
-- in a particular DHS complaint category?

;WITH Compare_ClosedDate AS (
    SELECT
        ComplaintType,

        SUM(CASE
            WHEN Status = 'Closed' THEN 1
            ELSE 0
        END) AS Total_Closed_Requests,

        SUM(CASE
            WHEN Status = 'Closed'
             AND NULLIF(TRIM(ClosedDate), '') IS NULL
            THEN 1
            ELSE 0
        END) AS Missing_ClosedDate

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


-- ============================================================
-- PART 2: DUPLICATE VALIDATION
-- ============================================================

-- Business question:
-- Does each service request have a unique identifier?


-- 2.1 Identify duplicate request IDs

SELECT
    UniqueKey,
    COUNT(*) AS Occurrences

FROM dbo.NYC_311_Raw
GROUP BY UniqueKey
HAVING COUNT(*) > 1
ORDER BY Occurrences DESC;


-- 2.2 Quantify duplicate records

;WITH Quantify_UniqueKey AS (
    SELECT
        UniqueKey,
        COUNT(*) AS Occurrences

    FROM dbo.NYC_311_Raw
    GROUP BY UniqueKey
)

SELECT
    COUNT(*) AS Duplicated_Identifiers,

    COALESCE(
        SUM(Occurrences - 1), 0
    ) AS Excess_Records,

    COALESCE(
        SUM(Occurrences), 0
    ) AS Records_In_Duplicate_Groups

FROM Quantify_UniqueKey
WHERE Occurrences > 1;


-- ============================================================
-- PART 3: DATE VALIDATION
-- ============================================================

-- 3.1 Validate date conversions
-- Business question:
-- Can creation and closure dates be converted into
-- valid SQL Server date values?

SELECT
    COUNT(*) AS Total_Records,

    SUM(CASE
        WHEN NULLIF(TRIM(CreatedDate), '') IS NOT NULL
         AND TRY_CONVERT(
             DATETIME2,
             NULLIF(TRIM(CreatedDate), '')
         ) IS NULL
        THEN 1
        ELSE 0
    END) AS Fail_Convert_CreatedDate,

    SUM(CASE
        WHEN NULLIF(TRIM(ClosedDate), '') IS NOT NULL
         AND TRY_CONVERT(
             DATETIME2,
             NULLIF(TRIM(ClosedDate), '')
         ) IS NULL
        THEN 1
        ELSE 0
    END) AS Fail_Convert_ClosedDate,

    SUM(CASE
        WHEN NULLIF(TRIM(CreatedDate), '') IS NULL THEN 1
        ELSE 0
    END) AS Missing_CreatedDate,

    SUM(CASE
        WHEN NULLIF(TRIM(ClosedDate), '') IS NULL THEN 1
        ELSE 0
    END) AS Missing_ClosedDate

FROM dbo.NYC_311_Raw;


-- 3.2 Identify requests with closure dates earlier
-- than their creation dates
-- Business question:
-- Are there chronological inconsistencies in the timestamps?

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
)

SELECT
    UniqueKey,
    Created_Date,
    Closed_Date,

    DATEDIFF(
        SECOND,
        Created_Date,
        Closed_Date
    ) AS Resolution_Seconds

FROM Date_Info
WHERE Created_Date IS NOT NULL
  AND Closed_Date IS NOT NULL
  AND Closed_Date < Created_Date
ORDER BY Resolution_Seconds;


-- 3.3 Inspect original timestamp values behind
-- negative resolution durations

;WITH Date_Info AS (
    SELECT
        UniqueKey,
        CreatedDate,
        ClosedDate,

        TRY_CONVERT(
            DATETIME2,
            NULLIF(TRIM(CreatedDate), '')
        ) AS Created_Date,

        TRY_CONVERT(
            DATETIME2,
            NULLIF(TRIM(ClosedDate), '')
        ) AS Closed_Date

    FROM dbo.NYC_311_Raw
)

SELECT TOP 20
    UniqueKey,
    CreatedDate,
    ClosedDate,
    Created_Date,
    Closed_Date

FROM Date_Info
WHERE Created_Date IS NOT NULL
  AND Closed_Date IS NOT NULL
  AND Closed_Date < Created_Date
ORDER BY Created_Date;


-- 3.4 Quantify negative, zero-second and positive durations
-- Business question:
-- What percentage of parseable date pairs have
-- negative, zero-second or positive resolution durations?

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

        DATEDIFF(
            SECOND,
            Created_Date,
            Closed_Date
        ) AS Resolution_Seconds

    FROM Date_Info
    WHERE Created_Date IS NOT NULL
      AND Closed_Date IS NOT NULL
)

SELECT
    COUNT(*) AS Parseable_Date_Pairs,

    SUM(CASE
        WHEN Resolution_Seconds < 0 THEN 1
        ELSE 0
    END) AS Negative_Durations,

    SUM(CASE
        WHEN Resolution_Seconds = 0 THEN 1
        ELSE 0
    END) AS Zero_Durations,

    SUM(CASE
        WHEN Resolution_Seconds > 0 THEN 1
        ELSE 0
    END) AS Positive_Durations

FROM Date_Validation;


-- 3.5 Distribution of negative resolution durations by agency
-- Business question:
-- Which agencies account for the largest share
-- of negative resolution durations?

;WITH Date_Info AS (
    SELECT
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
        Agency,

        DATEDIFF(
            SECOND,
            Created_Date,
            Closed_Date
        ) AS Resolution_Seconds

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
    ) AS Share_of_Negative_Durations

FROM Date_Validation
WHERE Resolution_Seconds < 0
GROUP BY Agency
ORDER BY Invalid_Requests DESC;


/*
============================================================
DATA PROFILING FINDINGS
============================================================

DATA COMPLETENESS
-----------------
Total records: 348,180
Missing UniqueKey: 0
Missing CreatedDate: 0
Missing ClosedDate: 2,593
Missing Agency: 0
Missing ComplaintType: 0
Missing Descriptor: 1,539
Missing Status: 0
Missing Borough: 0

DUPLICATE VALIDATION
--------------------
Duplicate request identifiers: 0

DATE VALIDATION
---------------
Parseable creation and closure date pairs: 345,587
Negative resolution durations: 99
Zero-second resolution durations: 3,601
Positive resolution durations: 341,887

Negative durations indicate chronological inconsistencies.

Zero-second durations do not necessarily mean identical
timestamps. DATEDIFF(SECOND) counts second boundaries,
so timestamps within the same second may return zero.

Only positive resolution durations were included in
the resolution-time performance calculations.

Total records used in resolution-time analysis: 341,887.

============================================================
*/
