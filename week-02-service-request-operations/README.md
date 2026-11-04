# Week 2 — NYC 311 Service Request Operations & Performance

## 1. Project Overview

This project analyzes New York City's 311 service requests to understand service demand, geographic distribution, agency workload, and resolution patterns.

Using publicly available data from NYC Open Data, the analysis explores how service requests are distributed across complaint categories, boroughs, and agencies, while evaluating resolution times and data-quality limitations.

The project was developed using **Microsoft SQL Server**, focusing on translating operational data into actionable business insights.

## 2. Business Scenario

A municipal operations department wants to understand demand for public services, how operational workload is distributed, and how service request resolution patterns vary.

The analysis addresses three main business questions:

1. Which complaint categories and boroughs generate the highest service demand?
2. How is the service request workload distributed across agencies?
3. How long do service requests take to resolve, and what data-quality issues affect resolution-time analysis?

## 3. Dataset

**Source:** NYC Open Data — 311 Service Requests from 2020 to Present

[Access the official dataset](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9)

| Attribute | Description |
|---|---|
| Data source | NYC Open Data |
| Extraction period | January 1–31, 2025 |
| Extraction method | Socrata API |
| Imported records | 348,180 |
| Database | Microsoft SQL Server |
| Raw table | `dbo.NYC_311_Raw` |
| Analysis environment | SQL Server Management Studio |

### Selected fields

| Column | Description |
|---|---|
| UniqueKey | Unique service request identifier |
| CreatedDate | Date and time when the request was created |
| ClosedDate | Date and time when the request was closed |
| Agency | Agency responsible for the request |
| ComplaintType | Type of reported problem |
| Descriptor | More specific description of the problem |
| Status | Current request status |
| Borough | NYC borough associated with the request |

## 4. Analysis Structure

The project is organized into three SQL files.

| File | Purpose |
|---|---|
| `01_data_profiling.sql` | Data quality, missing values, duplicate identifiers, date validation, and chronological inconsistencies |
| `02_service_demand.sql` | Complaint category, geographic demand, and agency workload analysis |
| `03_resolution_performance.sql` | Request status and closure completeness, overall resolution times, and agency-level resolution comparisons |

## 5. Key Findings

### 5.1 Data Quality and Validation

A total of **348,180 records** were imported into SQL Server.

| Validation metric | Result |
|---|---:|
| Total records | 348,180 |
| Missing UniqueKey | 0 |
| Missing CreatedDate | 0 |
| Missing ClosedDate | 2,593 |
| Missing ComplaintType | 0 |
| Missing Descriptor | 1,539 |
| Duplicate request identifiers | 0 |

Date validation identified the following results:

| Date validation metric | Records |
|---|---:|
| Valid creation and closure date pairs | 345,587 |
| Negative resolution durations | 99 |
| Zero-second resolution durations | 3,601 |
| Positive resolution durations | 341,887 |

Negative and zero-second durations were excluded from positive resolution-time calculations.

### 5.2 Service Demand Analysis

**Complaint categories**

The three categories generating the highest request volumes were:

| Complaint category | Requests | Demand share |
|---|---:|---:|
| Noise - Residential | 70,837 | 20.34% |
| HEAT/HOT WATER | 67,229 | 19.31% |
| Illegal Parking | 43,139 | 12.39% |

These three categories account for approximately **52.04% of all service requests**, indicating that demand is concentrated in a relatively small number of complaint categories.

**Geographic distribution**

| Borough | Requests | Demand share |
|---|---:|---:|
| Bronx | 115,111 | 33.06% |
| Brooklyn | 92,911 | 26.68% |
| Queens | 68,525 | 19.68% |
| Manhattan | 61,331 | 17.61% |
| Staten Island | 10,125 | 2.91% |
| Unspecified | 177 | 0.05% |

The Bronx and Brooklyn together account for approximately **59.74% of all requests**.

**Agency workload**

| Agency | Requests | Demand share |
|---|---:|---:|
| NYPD | 153,175 | 43.99% |
| HPD | 110,624 | 31.77% |
| DSNY | 26,370 | 7.57% |
| DOT | 16,592 | 4.77% |
| DEP | 15,358 | 4.41% |

NYPD and HPD handle approximately **75.76% of the requests** in this dataset, indicating a highly concentrated distribution of operational workload.

### 5.3 Resolution Performance

The analysis identified **341,887 requests with positive resolution durations**.

| Performance metric | Result |
|---|---:|
| Valid resolved requests | 341,887 |
| Average resolution time | 242.21 hours |
| Median resolution time | 15.65 hours |

The average resolution time is substantially higher than the median. This suggests a right-skewed distribution in which a smaller number of long-running requests may substantially increase the overall average.

The median therefore provides an additional perspective on the typical resolution duration and complements the average when evaluating resolution patterns.

### 5.4 Request Status and Closure Completeness

Missing closure dates were not distributed equally across request statuses.

For example:

- 99.88% of requests with status `In Progress` had no closure date.
- 85.46% of requests with status `Open` had no closure date.
- 0.30% of requests with status `Closed` had no closure date.

This demonstrates why request status and closure-date completeness should be evaluated together.

A missing closure date does not automatically mean that a request is unresolved. The status field provides important additional context, and inconsistencies between these fields should be considered when interpreting the results.

## 6. SQL Skills Demonstrated

- Data profiling and quality validation
- NULL and blank-value handling
- Duplicate identification
- Data type conversion using `TRY_CONVERT`
- Conditional aggregation using `CASE WHEN`
- Common Table Expressions (CTEs)
- Grouping and ranking
- Window functions
- `DATEDIFF` and date calculations
- `PERCENTILE_CONT` for median calculation
- Business-oriented interpretation of operational data

## 7. Data Quality Considerations and Limitations

The analysis includes several important limitations:

1. Records with missing closure dates cannot be included in completed-request resolution-time calculations.
2. Negative resolution durations may indicate inconsistencies in the source timestamps and were excluded from positive-duration analysis.
3. Zero-second durations may result from the precision of the `DATEDIFF(SECOND, ...)` calculation, which counts second boundaries rather than measuring exact elapsed time.
4. The average resolution time is sensitive to unusually long resolution durations, making the median an important complementary metric.
5. Agency workload comparisons do not independently measure agency efficiency or service quality because differences in request complexity, responsibilities, and service targets are not accounted for.
6. Resolution-time calculations include only requests with valid creation and closure dates available in the extracted dataset. Requests without valid closure dates are excluded, so the results should not be interpreted as the eventual resolution times of every request created during January 2025.

## 8. Repository Structure

```text
week-02-service-request-operations/
│
├── README.md
├── 01_data_profiling.sql
├── 02_service_demand.sql
└── 03_resolution_performance.sql
```
