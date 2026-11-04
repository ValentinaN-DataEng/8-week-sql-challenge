# 🏙️ Week 2 — NYC 311 Service Request Operations & Performance

> **8-Week SQL Challenge · Case Study 02**  
> Analyzing public service demand and resolution patterns with Microsoft SQL Server.

[![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-CC2927?logo=microsoftsqlserver&logoColor=white)](https://learn.microsoft.com/en-us/sql/sql-server/)
[![Dataset](https://img.shields.io/badge/Dataset-NYC%20311-blue)](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9)
![Status](https://img.shields.io/badge/Status-Analysis%20completed-success)

---

## 📚 Table of Contents

- [Business Scenario](#-business-scenario)
- [Dataset Overview](#-dataset-overview)
- [Business Questions](#-business-questions)
- [SQL Solutions](#-sql-solutions)
- [Key Findings](#-key-findings)
- [Data Quality and Limitations](#-data-quality-and-limitations)
- [Skills Practiced](#-skills-practiced)
- [Project Structure](#-project-structure)
- [Future Improvements](#-future-improvements)

---

## 🎯 Business Scenario

A municipal operations department wants to better understand the demand for public services and how service requests are distributed across government agencies.

The department has access to NYC 311 service request records, but raw records alone do not reveal which complaint categories generate the highest demand, where requests are concentrated, or how resolution times vary across agencies.

**Mission:** Transform raw service request data into operational insights by analyzing service demand, geographic distribution, agency workload, and resolution patterns using SQL.

## 🗂️ Dataset Overview

| Attribute | Details |
|---|---|
| Dataset | NYC 311 Service Requests from 2020 to Present |
| Source | [NYC Open Data](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9) |
| Extraction period | January 1–31, 2025 |
| Extraction method | Socrata API |
| Raw records | 348,180 rows |
| Database | Microsoft SQL Server |
| Raw table | `dbo.NYC_311_Raw` |
| SQL dialect | T-SQL |

The dataset contains public service requests submitted through NYC's 311 system, including complaint categories, responsible agencies, geographic information, request statuses, and creation and closure timestamps.

The data was retrieved through the Socrata API using Python and imported into SQL Server with the source columns initially stored as text.

Date conversions and data validation were performed within the analysis queries, leaving the original raw table unchanged.

## 🔎 Business Questions

Expand each section to explore the analytical questions addressed in this case study.

<details>
<summary><strong>01 — Data Profiling and Quality</strong></summary>

**Business objective:** Assess data completeness, consistency, and date reliability before performing operational analysis.

Questions investigated:

- Which columns contain missing or blank values?
- Are service request identifiers unique?
- Can creation and closure dates be converted successfully?
- Are there requests with closure dates earlier than their creation dates?
- How many requests have zero-second or positive resolution durations?
- How are missing closure dates distributed across agencies and complaint types?

**SQL file:** [`01_data_profiling.sql`](01_data_profiling.sql)

</details>

<details>
<summary><strong>02 — Service Demand Analysis</strong></summary>

**Business objective:** Identify where service demand is concentrated and which agencies handle the largest request volumes.

Questions investigated:

- Which complaint categories generate the highest number of service requests?
- What percentage of total demand does each complaint category represent?
- How are service requests distributed across NYC boroughs?
- Which agencies handle the largest share of service requests?

**SQL file:** [`02_service_demand.sql`](02_service_demand.sql)

</details>

<details>
<summary><strong>03 — Resolution Performance</strong></summary>

**Business objective:** Evaluate resolution-time patterns and investigate inconsistencies between request statuses and closure dates.

Questions investigated:

- What are the average and median resolution times?
- How does closure-date completeness vary across request statuses?
- Which agencies have the longest average and median resolution times?
- How does the difference between average and median resolution times vary across agencies?

**SQL file:** [`03_resolution_performance.sql`](03_resolution_performance.sql)

</details>

## 💻 SQL Solutions

The analysis is organized into three SQL scripts:

| File | Purpose |
|---|---|
| [`01_data_profiling.sql`](01_data_profiling.sql) | Data profiling, missing-value checks, duplicate identification, date conversion, and chronological validation |
| [`02_service_demand.sql`](02_service_demand.sql) | Complaint category ranking, geographic demand distribution, and agency workload analysis |
| [`03_resolution_performance.sql`](03_resolution_performance.sql) | Average and median resolution times, closure-date completeness by status, and agency-level resolution comparisons |

The project applies SQL Server techniques including:

- `CASE WHEN` and conditional aggregation
- `SUM`, `AVG`, and `COUNT`
- `GROUP BY` and `ORDER BY`
- Common Table Expressions (CTEs)
- `TRY_CONVERT`, `TRIM`, and `NULLIF`
- Window functions
- `PERCENTILE_CONT` for median calculation
- `DATEDIFF` for resolution-time calculations
- Percentage calculations and analytical metrics

## 📊 Key Findings

The findings below are based on the query results obtained during this case study. Demand shares represent the proportion of service requests within the corresponding analysis.

### 1. Data completeness and validation

A total of **348,180 service request records** were imported into SQL Server.

| Validation metric | Result |
|---|---:|
| Total records | 348,180 |
| Missing `UniqueKey` | 0 |
| Missing `CreatedDate` | 0 |
| Missing `ClosedDate` | 2,593 |
| Missing `ComplaintType` | 0 |
| Missing `Descriptor` | 1,539 |
| Duplicate request identifiers | 0 |

Date validation identified the following results:

| Date validation metric | Records |
|---|---:|
| Valid creation and closure date pairs | 345,587 |
| Negative resolution durations | 99 |
| Zero-second resolution durations | 3,601 |
| Positive resolution durations | 341,887 |

These results established the criteria used for resolution-time calculations. Negative and zero-second durations were excluded from positive-duration metrics.

### 2. Service demand by complaint category

The three complaint categories generating the highest request volumes were:

| Complaint category | Requests | Demand share |
|---|---:|---:|
| Noise - Residential | 70,837 | 20.34% |
| HEAT/HOT WATER | 67,229 | 19.31% |
| Illegal Parking | 43,139 | 12.39% |

Together, these three categories account for approximately **52.04% of all service requests**.

This indicates that a substantial proportion of reported service demand is concentrated in a relatively small number of complaint categories.

### 3. Geographic distribution of service demand

The distribution of requests across NYC boroughs was:

| Borough | Requests | Demand share |
|---|---:|---:|
| Bronx | 115,111 | 33.06% |
| Brooklyn | 92,911 | 26.68% |
| Queens | 68,525 | 19.68% |
| Manhattan | 61,331 | 17.61% |
| Staten Island | 10,125 | 2.91% |
| Unspecified | 177 | 0.05% |

The Bronx and Brooklyn together account for approximately **59.74% of all requests**.

This highlights a concentration of reported service demand in these two boroughs. However, request volume alone does not measure demand relative to population size.

### 4. Agency workload distribution

The agencies receiving the highest request volumes were:

| Agency | Requests | Demand share |
|---|---:|---:|
| NYPD | 153,175 | 43.99% |
| HPD | 110,624 | 31.77% |
| DSNY | 26,370 | 7.57% |
| DOT | 16,592 | 4.77% |
| DEP | 15,358 | 4.41% |

NYPD and HPD together handle approximately **75.76% of all service requests**.

This indicates a highly concentrated distribution of operational workload across agencies. Request volume, however, does not independently establish agency efficiency or service quality.

### 5. Overall resolution time

The analysis identified **341,887 requests with positive resolution durations**.

| Performance metric | Result |
|---|---:|
| Valid resolved requests | 341,887 |
| Average resolution time | 242.21 hours |
| Median resolution time | 15.65 hours |

The average resolution time is approximately **15.5 times higher than the median**.

This suggests a strongly right-skewed distribution in which a smaller number of long-running requests substantially increase the overall average.

The median therefore provides an additional perspective on typical resolution duration and complements the average when evaluating resolution patterns.

### 6. Request status and closure-date completeness

Missing closure dates were not distributed equally across request statuses.

| Status | Total requests | Missing closure dates | Missing closure rate |
|---|---:|---:|---:|
| In Progress | 858 | 857 | 99.88% |
| Open | 399 | 341 | 85.46% |
| Assigned | 263 | 184 | 69.96% |
| Pending | 183 | 85 | 46.45% |
| Started | 78 | 74 | 94.87% |
| Unspecified | 36 | 1 | 2.78% |
| Closed | 346,363 | 1,051 | 0.30% |

The analysis also identified inconsistencies between status and closure-date fields:

- 1,542 requests with a status other than `Closed` have no closure date.
- 275 requests with a status other than `Closed` nevertheless have a closure date.
- 1,051 requests marked `Closed` have no closure date.

These results demonstrate why status and closure-date completeness should be evaluated together. A missing closure date does not automatically mean that a request is unresolved.

### 7. Agency resolution-time comparison

The agency-level analysis compared average and median resolution durations for requests with valid positive durations.

Examples from the highest-average results:

| Agency | Valid requests | Average (hours) | Median (hours) |
|---|---:|---:|---:|
| EDC | 1,815 | 3,749.59 | 3,410.94 |
| DOE | 289 | 1,680.52 | 839.06 |
| TLC | 2,498 | 1,640.89 | 1,651.94 |
| DOB | 6,692 | 1,590.21 | 294.95 |
| DPR | 3,558 | 1,040.08 | 144.12 |

EDC has the highest average and median resolution durations in the agency comparison.

DOB shows a substantial difference between its average and median, suggesting that a subset of requests has particularly long resolution durations.

HPD handles the largest volume of valid resolved requests among the agencies analyzed.

These comparisons reveal differences in resolution patterns, but they should not be interpreted as direct measures of agency efficiency because request complexity, service responsibilities, and agency-specific targets are not accounted for.

## 🧹 Data Quality and Limitations

### Date validation and resolution-time calculations

The analysis identified:

- 2,593 records with missing closure dates.
- 99 records with negative resolution durations.
- 3,601 records with zero-second resolution durations.

Only requests with valid creation dates, valid closure dates, and positive durations were included in resolution-time calculations.

### Remaining limitations

- Missing closure dates prevent those records from being included in completed-request resolution-time calculations.
- Negative resolution durations may indicate inconsistencies in source timestamps and were excluded from positive-duration analysis.
- `DATEDIFF(SECOND, ...)` counts second boundaries. Therefore, a zero-second result does not necessarily mean the original timestamps are identical.
- Average resolution time is sensitive to unusually long durations, making the median an important complementary metric.
- Request volume by borough is not adjusted for population size.
- Agency workload comparisons do not independently measure efficiency or service quality.
- Differences in request complexity, agency responsibilities, and service targets are not accounted for.
- The resolution-time analysis includes only requests with valid creation and closure dates available in the extracted dataset. Requests without valid closure dates are excluded, so the results should not be interpreted as the eventual resolution times of every request created during January 2025.

## 🧠 Skills Practiced

- Data profiling and quality validation
- NULL and blank-value handling
- Duplicate identification
- Data type conversion and error handling
- Conditional aggregation using `CASE WHEN`
- Grouping and aggregation with `GROUP BY`
- Common Table Expressions (CTEs)
- Window functions and partitioning
- Median calculation using `PERCENTILE_CONT`
- Date calculations using `DATEDIFF`
- Percentage calculations and analytical metrics
- Geographic and operational demand analysis
- Business-oriented interpretation of analytical results
- Documenting data-quality limitations

## 🗃️ Project Structure

```text
8-week-sql-challenge/
├── README.md
├── week-01-customer-analytics/
│   ├── README.md
│   ├── 01_data_profiling.sql
│   └── 02_customer_analysis.sql
└── week-02-service-request-operations/
    ├── README.md
    ├── 01_data_profiling.sql
    ├── 02_service_demand.sql
    └── 03_resolution_performance.sql
```

The root README provides the roadmap for the full eight-week challenge. Each weekly folder contains its own case-study documentation and SQL scripts.

## 🚀 Future Improvements

The core Week 2 analysis is complete. Potential extensions include:

- [ ] Analyze service demand relative to borough population.
- [ ] Investigate resolution-time distributions by complaint category.
- [ ] Compare agency resolution times while accounting for complaint mix.
- [ ] Investigate requests with inconsistent status and closure-date combinations.
- [ ] Explore additional time periods to identify seasonal and monthly demand patterns.
- [ ] Connect the analysis to Power BI to develop an operational dashboard.

---

*Part of an original, self-directed eight-week SQL portfolio challenge using Microsoft SQL Server and real-world datasets.*
