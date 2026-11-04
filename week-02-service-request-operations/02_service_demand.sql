/*
=============================================================
WEEK 02: SERVICE REQUEST OPERATIONS & PERFORMANCE
FILE: 02_service_demand.sql
DATASET: NYC 311 Service Requests - January 2025
DATABASE: NYC_311_Analysis
ENVIRONMENT: Microsoft SQL Server

=============================================================
BUSINESS CONTEXT

The NYC 311 system receives service requests from residents
regarding different public services and urban issues.

The objective of this analysis is to understand service demand
distribution across complaint categories, geographic areas,
and responsible agencies.

The findings will help identify the most frequent service
needs, geographic demand patterns, and agency workload.

=============================================================
ANALYTICAL OBJECTIVES

1. Identify the complaint categories generating the highest
   number of service requests.

2. Identify the boroughs generating the highest service
   request volumes.

3. Analyze the distribution of service requests across
   responsible agencies.

=============================================================
BUSINESS QUESTIONS

Q1. Which complaint types generate the highest number of
    service requests?

Q2. Which boroughs generate the highest number of
    service requests?

Q3. Which agencies handle the largest number of
    service requests?
*/

USE NYC_311_Analysis;
GO

-- ===========================================================
-- Q1. COMPLAINT CATEGORY ANALYSIS
-- Which complaint types generate the highest number of
-- service requests?
-- ===========================================================
;WITH Complaint_Type_Num AS (
SELECT
	ComplaintType,
	COUNT (*) AS Number_Service_Request
FROM dbo.NYC_311_Raw
WHERE NULLIF(TRIM(ComplaintType), '') IS NOT NULL
GROUP BY ComplaintType
)

SELECT TOP 10
	ComplaintType,
	Number_Service_Request,
	CAST(Number_Service_Request*100.0/ SUM (Number_Service_Request) OVER () AS DECIMAL (10,2)) AS Demand_Share_Pct
FROM Complaint_Type_Num
ORDER BY Number_Service_Request DESC;
/*
KEY FINDINGS:

1. Noise - Residential is the largest complaint category,
   representing 20.34% of total requests.

2. HEAT/HOT WATER represents 19.31% of total requests.

3. Together, these two categories account for 39.65%
   of total service request demand.

BUSINESS INSIGHT:

Service demand is concentrated in residential noise and
heating/hot water complaints. These categories represent
the largest areas of reported service needs in January 2025.
*/


-- ===========================================================
-- Q2. GEOGRAPHIC DEMAND ANALYSIS
-- Which boroughs generate the highest number of
-- service requests?
-- ===========================================================
;WITH Borough_Num AS (
SELECT
	Borough,
	COUNT (*) AS Borough_Service_Request
FROM dbo.NYC_311_Raw
WHERE NULLIF(TRIM(Borough), '') IS NOT NULL
GROUP BY Borough
)

SELECT TOP 10
	Borough,
	Borough_Service_Request,
	CAST(Borough_Service_Request*100.0/ SUM (Borough_Service_Request) OVER () AS DECIMAL (10,2)) AS Borough_Demand_Share_Pct
FROM Borough_Num
ORDER BY Borough_Service_Request DESC;
/*
KEY FINDINGS:

1. The Bronx has the highest service request volume,
   representing 33.06% of total demand.

2. Brooklyn ranks second with 26.68%.

3. The Bronx and Brooklyn together account for 59.74%
   of all service requests.

4. Staten Island represents only 2.91% of total demand.

BUSINESS INSIGHT:

Service demand is geographically concentrated in the
Bronx and Brooklyn, which together account for nearly
60% of all requests.

This distribution may help identify areas requiring
greater operational attention.
*/


-- ===========================================================
-- Q3. AGENCY WORKLOAD ANALYSIS
-- Which agencies handle the largest number of
-- service requests?
-- ===========================================================
;WITH Agencies_Num AS (
SELECT
	Agency,
	COUNT (*) AS Agencies_Service_Request
FROM dbo.NYC_311_Raw
WHERE NULLIF(TRIM(Agency), '') IS NOT NULL
GROUP BY Agency
)

SELECT TOP 10
	Agency,
	Agencies_Service_Request,
	CAST(Agencies_Service_Request*100.0/ SUM (Agencies_Service_Request) OVER () AS DECIMAL (10,2)) AS Agencies_Demand_Share_Pct
FROM Agencies_Num
ORDER BY Agencies_Service_Request DESC;

/*
KEY FINDINGS:

1. NYPD handles the highest number of service requests,
   with 153,175 requests, representing 43.99% of total demand.

2. HPD ranks second, handling 110,624 requests,
   representing 31.77% of total demand.

3. Together, NYPD and HPD account for 75.76% of all
   service requests.

4. DSNY ranks third, with 26,370 requests (7.57%).

BUSINESS INSIGHT:

Service request demand is highly concentrated in NYPD
and HPD, which together handle approximately three
quarters of all requests.

This concentration highlights the importance of these
two agencies in NYC's 311 service operations.

Note: Workload volume measures the number of requests
assigned to each agency. It does not necessarily indicate
operational efficiency, resource availability, or service quality.
*/
