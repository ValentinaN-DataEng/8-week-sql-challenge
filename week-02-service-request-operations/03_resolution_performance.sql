
/*
=============================================================
WEEK 02: SERVICE REQUEST OPERATIONS & PERFORMANCE
FILE: 03_resolution_performance.sql
DATASET: NYC 311 Service Requests - January 2025
DATABASE: NYC_311_Analysis
ENVIRONMENT: Microsoft SQL Server
=============================================================

BUSINESS CONTEXT

This section evaluates resolution times, 
identifies requests that remain open, 
and compares resolution patterns across agencies.

=============================================================
ANALYTICAL OBJECTIVES

1. Measure the time required to resolve service requests.
2. Identify requests that remain unresolved.
3. Compare resolution times across agencies.

=============================================================
BUSINESS QUESTIONS

Q1. How long does it take to resolve service requests?
    Analyze average and median resolution times.

Q2. How many service requests remain unresolved?
    Analyze requests by their current status.

Q3. Which agencies have the longest resolution times?
    Compare average and median resolution times by agency.

=============================================================
SQL CONCEPTS

- DATEDIFF()
- AVG()
- PERCENTILE_CONT()
- CASE WHEN
- GROUP BY
- Common Table Expressions (CTEs)
- Window functions

=============================================================

IMPORTANT METHODOLOGY

- Exclude requests without valid creation or closure dates
  from resolution-time calculations.
- Exclude negative resolution times from duration metrics.
- Report excluded records transparently.
- Do not interpret request volume as operational efficiency.

=============================================================
*/

USE NYC_311_Analysis;
GO


-- ===========================================================
-- Q1. OVERALL RESOLUTION TIME
-- How long does it take to resolve service requests?
-- Calculate average and median resolution time.
-- ===========================================================
WITH Date_Convertion AS (
SELECT
	UniqueKey,
	TRY_CONVERT (DATETIME2,NULLIF(TRIM(CreatedDate), '')) AS Created_Date,
	TRY_CONVERT	(DATETIME2,NULLIF(TRIM(ClosedDate), '')) AS Closed_Date
FROM dbo.NYC_311_Raw
),

Duration_hours AS (
SELECT
	Created_Date,
	Closed_Date,
	DATEDIFF (SECOND,Created_Date,Closed_Date)/3600.0 AS Duration
FROM Date_Convertion
WHERE Created_Date IS NOT NULL
      AND Closed_Date IS NOT NULL
      AND Closed_Date > Created_Date
),

Median_Calculation AS (
    SELECT
        MAX(Median_Resolution_Hours) AS Median_Resolution_Hours
    FROM (
        SELECT
            PERCENTILE_CONT(0.5)
            WITHIN GROUP (
                ORDER BY Duration
            ) OVER () AS Median_Resolution_Hours
        FROM Duration_Hours
    ) AS Median_Values
)

SELECT
	COUNT (*) AS Valid_Resolved_Requests,
	CAST (AVG (Duration) AS DECIMAL (10,2)) AS Average_Resolution_Hours,
	CAST(MAX(Median_Resolution_Hours) AS DECIMAL(10,2)) AS Median_Resolution_Hours
FROM Duration_hours
CROSS JOIN Median_Calculation;
/*
KEY FINDINGS:

1. 341,887 requests have valid positive resolution durations.

2. Average resolution time: 242.21 hours (10.09 days).

3. Median resolution time: 15.65 hours (0.65 days).

4. The average is approximately 15.5 times higher than
   the median, suggesting a strongly right-skewed
   resolution-time distribution.

BUSINESS INSIGHT:

The median indicates that the typical resolved request
takes considerably less time than the average suggests.

The substantial difference between these metrics indicates
that some requests take much longer to resolve and increase
the overall average.

Further analysis by agency can help identify where these
longer resolution times are concentrated.
*/


-- ===========================================================
-- Q2. SERVICE REQUEST STATUS & CLOSURE COMPLETENESS
-- How are service requests distributed by status?
-- How often is the closure date missing within each status?
-- ===========================================================
WITH Num_Request_Unresolved AS (	
	SELECT
		Status,
		COUNT (*) AS Total_Requests,
		SUM (CASE WHEN NULLIF(TRIM(ClosedDate),'') IS NULL
			THEN 1
			ELSE 0
		END) AS Missing_ClosedDate
	FROM dbo.NYC_311_Raw
	GROUP BY Status
)

SELECT
	Status,
	Total_Requests,
	Missing_ClosedDate,
	CAST (Missing_ClosedDate*100.0 / Total_Requests AS DECIMAL (10,2)) AS Missing_Closure_Pct
FROM Num_Request_Unresolved
ORDER BY Missing_ClosedDate DESC;
/*
KEY FINDINGS:

1. 1,817 requests have a status different from 'Closed'.

2. 1,542 of these requests have missing closure dates.

3. 275 requests have a non-closed status despite having
   a closure date.

4. 1,051 requests are marked as 'Closed' but have no
   closure date (0.30% of closed requests).

BUSINESS INSIGHT:

The status and closure-date fields are not fully consistent.

Missing closure dates cannot automatically be interpreted
as unresolved requests. Both fields should be considered
when evaluating operational performance.

DATA QUALITY CONSIDERATION:

Further investigation would be necessary to determine
whether these inconsistencies result from reporting delays,
administrative practices, or incomplete records.
*/


-- ===========================================================
-- Q3. AGENCY RESOLUTION PERFORMANCE
-- Which agencies have the longest resolution times?
-- Compare average and median resolution times.
-- ===========================================================
WITH Date_Convertion AS (
SELECT
	Agency,
	TRY_CONVERT (DATETIME2,NULLIF(TRIM(CreatedDate), '')) AS Created_Date,
	TRY_CONVERT	(DATETIME2,NULLIF(TRIM(ClosedDate), '')) AS Closed_Date
FROM dbo.NYC_311_Raw
),

Duration_hours AS (
SELECT
	Agency,
	Created_Date,
	Closed_Date,
	DATEDIFF (SECOND,Created_Date,Closed_Date)/3600.0 AS Duration_Hours
FROM Date_Convertion
WHERE Created_Date IS NOT NULL
      AND Closed_Date IS NOT NULL
      AND Closed_Date > Created_Date
),

Median_Calculation AS (
SELECT
	Agency,
	MAX(Median_Resolution_Hours) AS Median_Resolution_Hours
FROM (
	SELECT
		Agency,
		PERCENTILE_CONT(0.5)
		WITHIN GROUP (
			ORDER BY Duration_Hours
			) OVER (PARTITION BY Agency) AS Median_Resolution_Hours
		FROM Duration_hours
	) AS Median_Values
GROUP BY Agency
),

Average_Calculation AS (
SELECT
	Agency,
	COUNT (*) AS Valid_Resolved_Requests,
	AVG (Duration_Hours) AS Resolution_Average
FROM Duration_hours
GROUP BY Agency
)

SELECT
	a.Agency,
	a.Valid_Resolved_Requests,
	CAST(a.Resolution_Average AS DECIMAL(10,2)) AS Average_Resolution_Hours,
    CAST(m.Median_Resolution_Hours AS DECIMAL(10,2)) AS Median_Resolution_Hours
FROM Median_Calculation AS m
INNER JOIN Average_Calculation AS a
	ON m.Agency = a.Agency
ORDER BY Resolution_Average DESC;
/*
KEY FINDINGS:

1. EDC presents the longest average and median resolution
   times among the agencies analyzed.

2. DOB shows a substantial difference between its average
   and median resolution times, suggesting a right-skewed
   distribution.

3. HPD handles the largest volume of valid resolved
   requests among the agencies shown.

BUSINESS INSIGHT:

Resolution performance varies considerably across agencies.

The difference between average and median resolution times
suggests that some agencies experience a concentration of
particularly long-running requests.

However, resolution time alone does not establish agency
efficiency. Differences in complaint complexity, service
responsibilities and operational processes should be
considered before drawing performance conclusions.

METHODOLOGICAL LIMITATION:

The analysis compares resolution durations for requests
created in January 2025 that have valid closure dates.
It does not account for differences in request complexity
or agency-specific service targets.
*/
