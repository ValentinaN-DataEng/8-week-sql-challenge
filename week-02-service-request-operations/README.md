# Week 2 — NYC 311 Service Request Operations & Performance

## Project Overview

This project analyzes New York City's 311 service requests to understand service demand, geographic distribution, agency workload, and resolution performance.

Using publicly available data from NYC Open Data, the analysis explores how service requests are distributed across complaint categories, boroughs, and agencies, while evaluating resolution times and data-quality limitations.

The project was developed using **Microsoft SQL Server** and focuses on translating operational data into actionable business insights.

## Business Scenario

A municipal operations department wants to understand the demand for public services and evaluate how effectively service requests are being resolved.

The analysis aims to answer three main questions:

1. Which complaint categories and boroughs generate the highest service demand?
2. How is the service request workload distributed across agencies?
3. How long do agencies take to resolve requests, and what data-quality issues affect performance measurement?

## Dataset

**Source:** NYC Open Data — 311 Service Requests from 2020 to Present

[Access the official dataset](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9)

| Attribute | Description |
|---|---|
| Data source | NYC Open Data |
| Extraction period | January 1–31, 2025 |
| Extraction method | Socrata API |
| Imported records | 348,180 |
| Database | SQL Server |
| Raw table | `dbo.NYC_311_Raw` |

### Selected fields

- `UniqueKey`: Unique identifier for each service request.
- `CreatedDate`: Date and time when the request was created.
- `ClosedDate`: Date and time when the request was closed.
- `Agency`: Agency responsible for handling the request.
- `ComplaintType`: Type of reported complaint.
- `Descriptor`: Additional description of the complaint.
- `Status`: Current request status.
- `Borough`: Geographic area associated with the request.

The raw dataset was retained in SQL Server, while date conversion and analytical filtering were performed within the SQL queries.

## Analytical Approach

### Part 1 — Data Profiling & Validation

**Objective:** Assess data completeness, uniqueness, and date consistency before conducting the analysis.

Key checks:

- Missing and blank values.
- Duplicate request identifiers.
- Date conversion failures.
- Missing closure dates.
- Chronological inconsistencies between creation and closure dates.

**Key findings:**

| Data quality check | Result |
|---|---:|
| Total records | 348,180 |
| Duplicate request identifiers | 0 |
| Missing creation dates | 0 |
| Missing closure dates | 2,593 |
| Missing complaint descriptions | 1,539 |
| Invalid creation date conversions | 0 |
| Invalid closure date conversions | 0 |
| Negative resolution durations | 99 |

The analysis identified 99 requests with closure dates earlier than their creation dates.

These records were excluded from positive resolution-duration calculations.

### Part 2 — Service Demand Analysis

**Objective:** Identify the main sources of service demand and understand how requests are distributed across geographic areas and agencies.

Business questions:

1. Which complaint categories generate the highest number of service requests?
2. Which boroughs generate the highest service demand?
3. Which agencies handle the largest number of requests?

**Key findings:**

**Complaint categories**

| Rank | Complaint category | Requests | Demand share |
|---:|---|---:|---:|
| 1 | Noise - Residential | 70,837 | 20.34% |
| 2 | HEAT/HOT WATER | 67,229 | 19.31% |
| 3 | Illegal Parking | 43,139 | 12.39% |
| 4 | Blocked Driveway | 14,661 | 4.21% |
| 5 | UNSANITARY CONDITION | 10,000 | 2.87% |

The three largest complaint categories account for approximately 52% of all requests.

**Geographic distribution**

| Borough | Requests | Demand share |
|---|---:|---:|
| BRONX | 115,111 | 33.06% |
| BROOKLYN | 92,911 | 26.68% |
| QUEENS | 68,525 | 19.68% |
| MANHATTAN | 61,331 | 17.61% |
| STATEN ISLAND | 10,125 | 2.91% |
| Unspecified | 177 | 0.05% |

The Bronx and Brooklyn together account for approximately 59.74% of requests.

**Agency workload**

| Agency | Requests | Demand share |
|---|---:|---:|
| NYPD | 153,175 | 43.99% |
| HPD | 110,624 | 31.77% |
| DSNY | 26,370 | 7.57% |
| DOT | 16,592 | 4.77% |
| DEP | 15,358 | 4.41% |

NYPD and HPD together handle approximately 75.76% of the recorded service request volume.

### Part 3 — Resolution Performance

**Objective:** Evaluate resolution durations, identify requests with missing closure information, and compare resolution times across agencies.

Business questions:

1. How long does it take to resolve service requests?
2. How many requests have missing closure dates, and how are they distributed by status?
3. Which agencies have the longest average and median resolution times?

**Overall resolution time**

| Metric | Result |
|---|---:|
| Valid positive resolution durations | 341,887 |
| Average resolution time | 242.21 hours |
| Median resolution time | 15.65 hours |

The average resolution time is approximately 15.5 times higher than the median.

This indicates a strongly right-skewed distribution, suggesting that a relatively small number of long-running requests substantially increase the average.

**Closure-date completeness by status**

| Status | Total requests | Missing closure dates | Missing closure % |
|---|---:|---:|---:|
| In Progress | 858 | 857 | 99.88% |
| Open | 399 | 341 | 85.46% |
| Assigned | 263 | 184 | 69.96% |
| Pending | 183 | 85 | 46.45% |
| Started | 78 | 74 | 94.87% |
| Unspecified | 36 | 1 | 2.78% |
| Closed | 346,363 | 1,051 | 0.30% |

The analysis identified inconsistencies between request status and closure-date availability.

For example, 1,051 requests marked as Closed have no closure date, while 275 requests with a non-closed status already have a closure date.

Therefore, missing closure dates cannot automatically be interpreted as unresolved requests.

**Agency resolution performance**

The results identified substantial differences in resolution times across agencies.

Examples from the analysis:

- EDC presented the longest average and median resolution times among the agencies shown.
- DOB had a considerably higher average than median, suggesting a concentration of long-running requests.
- HPD handled the largest number of valid resolved requests among the agencies shown.

These differences should not be interpreted as direct measures of agency efficiency because agencies handle different complaint categories, operational responsibilities, and levels of complexity.

## SQL Skills Demonstrated

- Data profiling and quality validation.
- `TRY_CONVERT()` and `NULLIF()` for data cleaning.
- `TRIM()` for whitespace handling.
- `CASE WHEN` for conditional aggregation.
- `GROUP BY` and `HAVING`.
- Common Table Expressions (CTEs).
- `COUNT()`, `SUM()`, and `AVG()`.
- `DATEDIFF()` for resolution-time calculations.
- `PERCENTILE_CONT()` for median calculations.
- Window functions with `PARTITION BY`.
- Joining aggregated results.
- Percentage calculations and ranking.

## Repository Structure

```text
week-02-service-request-operations/
│
├── README.md
├── 01_data_profiling.sql
├── 02_service_demand.sql
└── 03_resolution_performance.sql
```

## Limitations

- The analysis covers requests created during January 2025 only.
- The dataset is a snapshot extracted from a public source and may be updated or revised.
- Requests without valid positive resolution durations were excluded from resolution-time calculations.
- Agency comparisons do not account for differences in complaint complexity or service-level targets.
- Missing closure dates do not necessarily indicate unresolved requests.
- Resolution duration is not, by itself, a complete measure of operational efficiency.

## Conclusion

This project demonstrates how SQL can be used to transform a large operational dataset into structured business insights.

The analysis identified the main sources of service demand, highlighted geographic and agency workload concentration, measured resolution-time distributions, and uncovered inconsistencies in request status and closure-date information.

The findings illustrate the importance of combining business analysis with data-quality validation before drawing conclusions from operational performance metrics.

---

**Tools:** Microsoft SQL Server, SQL Server Management Studio, Python (`requests`), NYC Open Data API

**Project:** 8-Week SQL Challenge — Week 2
