# 🏙️ Week 2 — NYC 311 Service Request Operations & Performance

> A SQL case study analyzing public service demand, geographic distribution, agency workload, and resolution patterns using NYC 311 service request data.

![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-CC2927?logo=microsoftsqlserver&logoColor=white)
![Dataset](https://img.shields.io/badge/Dataset-NYC%20311-blue)
![Records](https://img.shields.io/badge/Records-348%2C180-informational)
![Status](https://img.shields.io/badge/Status-Completed-success)

---

## 📑 Table of Contents

- [1. Project Overview](#1-project-overview)
- [2. Business Scenario](#2-business-scenario)
- [3. Dataset & Tools](#3-dataset--tools)
- [4. Analytical Approach](#4-analytical-approach)
- [5. Business Questions & SQL Analysis](#5-business-questions--sql-analysis)
  - [Part 1 — Data Profiling](#part-1--data-profiling)
  - [Part 2 — Service Demand](#part-2--service-demand)
  - [Part 3 — Resolution Performance](#part-3--resolution-performance)
- [6. Key Findings](#6-key-findings)
- [7. Data Quality & Limitations](#7-data-quality--limitations)
- [8. SQL Skills Demonstrated](#8-sql-skills-demonstrated)
- [9. Repository Structure](#9-repository-structure)

---

## 1. Project Overview

This project explores New York City's 311 service requests to understand how residents' reported problems translate into operational demand for municipal agencies.

Using **348,180 records** extracted from NYC Open Data, I developed a SQL analysis to investigate:

- Which complaint categories generate the highest service demand?
- How are requests distributed geographically across NYC boroughs?
- Which agencies handle the largest share of service requests?
- How long do requests take to resolve?
- What data-quality issues affect the interpretation of operational performance?

The analysis was developed using **Microsoft SQL Server**, following a structured workflow from data profiling to business-oriented interpretation.

<details>
<summary>🎯 <strong>Project objectives</strong></summary>

1. Assess the completeness and reliability of the raw dataset.
2. Identify the most frequent service request categories.
3. Analyze the geographic distribution of service demand.
4. Evaluate how service request workload is distributed across agencies.
5. Calculate average and median resolution times.
6. Identify inconsistencies between request status and closure dates.
7. Translate analytical results into meaningful operational findings.

</details>

## 2. Business Scenario

A municipal operations department wants to understand demand for public services, how workload is distributed across agencies, and how resolution patterns vary.

The objective is to use historical service request data to identify demand concentrations and provide a clearer picture of operational activity.

The analysis focuses on three main areas:

| Area | Business objective |
|---|---|
| Data quality | Determine whether the source data is reliable enough for analysis |
| Service demand | Identify where and what types of service requests are most frequent |
| Resolution performance | Understand resolution durations and investigate status inconsistencies |

## 3. Dataset & Tools

### Dataset

**Source:** NYC Open Data — 311 Service Requests from 2020 to Present

🔗 [Access the official dataset](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9)

| Attribute | Description |
|---|---|
| Extraction period | January 1–31, 2025 |
| Extraction method | Socrata API |
| Imported records | 348,180 |
| Database | `NYC_311_Analysis` |
| Raw table | `dbo.NYC_311_Raw` |
| SQL environment | Microsoft SQL Server |
| Development tool | SQL Server Management Studio |

### Selected dataset fields

| Column | Description |
|---|---|
| `UniqueKey` | Unique service request identifier |
| `CreatedDate` | Date and time when the request was created |
| `ClosedDate` | Date and time when the request was closed |
| `Agency` | Agency responsible for the request |
| `ComplaintType` | Type of reported problem |
| `Descriptor` | More specific description of the problem |
| `Status` | Current request status |
| `Borough` | NYC borough associated with the request |

<details>
<summary>🛠️ <strong>Data extraction and preparation</strong></summary>

The dataset was retrieved using the NYC Open Data Socrata API and Python's `requests` library.

The raw CSV was imported into SQL Server, where the source fields were initially stored as text.

Data profiling and conversion checks were then performed using SQL Server functions such as `TRIM()`, `NULLIF()`, and `TRY_CONVERT()`.

This approach allowed the analysis to identify missing values, validate dates, and calculate resolution durations without modifying the original raw data.

</details>

## 4. Analytical Approach

The project is divided into three analytical stages.

<details>
<summary>📂 <strong>Part 1 — Data Profiling & Quality Validation</strong></summary>

**Objective:** Evaluate the completeness, consistency, and reliability of the dataset before performing business analysis.

**Main activities:**
- Identified missing and blank values.
- Checked duplicate request identifiers.
- Validated date conversions.
- Identified negative and zero-second resolution durations.
- Investigated records with missing closure dates.

**SQL script:** [`01_data_profiling.sql`](./01_data_profiling.sql)

<badge-placeholder></badge-placeholder>

</details>

<details>
<summary>📊 <strong>Part 2 — Service Demand Analysis</strong></summary>

**Objective:** Understand the distribution of service demand across complaint categories, boroughs, and agencies.

**Main activities:**
- Ranked complaint categories by request volume.
- Calculated the percentage contribution of each category.
- Compared service demand across boroughs.
- Identified agencies handling the highest request volumes.

**SQL script:** [`02_service_demand.sql`](./02_service_demand.sql)

</details>

<details>
<summary>⏱️ <strong>Part 3 — Resolution Performance Analysis</strong></summary>

**Objective:** Analyze resolution durations and understand the relationship between request status and closure-date completeness.

**Main activities:**
- Calculated average and median resolution times.
- Identified requests with missing closure dates by status.
- Compared average and median resolution times across agencies.
- Evaluated limitations affecting performance comparisons.

**SQL script:** [`03_resolution_performance.sql`](./03_resolution_performance.sql)

</details>

## 5. Business Questions & SQL Analysis

### Part 1 — Data Profiling

<badge color="success">Completed</badge>

**Business question:** Is the dataset sufficiently complete and consistent to support operational analysis?

<details>
<summary>🔎 <strong>Q1. How complete is the dataset?</strong></summary>

A total of 348,180 records were imported.

| Validation metric | Result |
|---|---:|
| Total records | 348,180 |
| Missing `UniqueKey` | 0 |
| Missing `CreatedDate` | 0 |
| Missing `ClosedDate` | 2,593 |
| Missing `ComplaintType` | 0 |
| Missing `Descriptor` | 1,539 |
| Duplicate request identifiers | 0 |

**Finding:** The dataset has complete request identifiers and creation dates, but some records have missing closure dates or descriptions.

</details>

<details>
<summary>📅 <strong>Q2. Are the creation and closure dates valid?</strong></summary>

Date validation produced the following results:

| Date validation metric | Records |
|---|---:|
| Valid creation and closure date pairs | 345,587 |
| Negative resolution durations | 99 |
| Zero-second resolution durations | 3,601 |
| Positive resolution durations | 341,887 |

**Finding:** Negative and zero-second durations require special treatment before calculating positive resolution-time metrics.

</details>

**Key takeaway:** Data profiling revealed important limitations in the source data and established the criteria used for subsequent resolution-time calculations.

📄 [Explore the complete data profiling SQL analysis](./01_data_profiling.sql)

---

### Part 2 — Service Demand

<badge color="success">Completed</badge>

**Business question:** Where is service demand concentrated, and which agencies handle the largest request volumes?

<details>
<summary>🏷️ <strong>Q1. Which complaint categories generate the highest demand?</strong></summary>

| Complaint category | Requests | Demand share |
|---|---:|---:|
| Noise - Residential | 70,837 | 20.34% |
| HEAT/HOT WATER | 67,229 | 19.31% |
| Illegal Parking | 43,139 | 12.39% |

**Finding:** The three most frequent complaint categories account for approximately **52.04% of all requests**.

This indicates that a relatively small number of complaint categories represent a substantial share of reported service demand.

</details>

<details>
<summary>🗺️ <strong>Q2. How is service demand distributed across boroughs?</strong></summary>

| Borough | Requests | Demand share |
|---|---:|---:|
| Bronx | 115,111 | 33.06% |
| Brooklyn | 92,911 | 26.68% |
| Queens | 68,525 | 19.68% |
| Manhattan | 61,331 | 17.61% |
| Staten Island | 10,125 | 2.91% |
| Unspecified | 177 | 0.05% |

**Finding:** The Bronx and Brooklyn together account for approximately **59.74% of all requests**.

This highlights a concentration of reported service demand in these two boroughs. These figures represent request volume, not population-adjusted demand.

</details>

<details>
<summary>🏢 <strong>Q3. Which agencies handle the highest request volumes?</strong></summary>

| Agency | Requests | Demand share |
|---|---:|---:|
| NYPD | 153,175 | 43.99% |
| HPD | 110,624 | 31.77% |
| DSNY | 26,370 | 7.57% |
| DOT | 16,592 | 4.77% |
| DEP | 15,358 | 4.41% |

**Finding:** NYPD and HPD together handle approximately **75.76% of all requests**.

This indicates a highly concentrated distribution of service request workload across agencies.

</details>

**Key takeaway:** Service demand is concentrated across a relatively small number of complaint categories, boroughs, and agencies. Understanding these distributions provides an initial view of operational workload.

📄 [Explore the complete service demand SQL analysis](./02_service_demand.sql)

---

### Part 3 — Resolution Performance

<badge color="success">Completed</badge>

**Business question:** How long do service requests take to resolve, and how do resolution patterns vary across agencies?

<details>
<summary>⏱️ <strong>Q1. What is the average and median resolution time?</strong></summary>

Only requests with valid creation dates, valid closure dates, and positive resolution durations were included.

| Performance metric | Result |
|---|---:|
| Valid resolved requests | 341,887 |
| Average resolution time | 242.21 hours |
| Median resolution time | 15.65 hours |

**Finding:** The average is approximately 15.5 times higher than the median.

This suggests a strongly right-skewed distribution, where a smaller number of long-running requests substantially increase the average.

The median provides an additional perspective on the typical resolution duration.

</details>

<details>
<summary>📋 <strong>Q2. How do missing closure dates vary by request status?</strong></summary>

| Status | Total requests | Missing closure dates | Missing closure rate |
|---|---:|---:|---:|
| In Progress | 858 | 857 | 99.88% |
| Open | 399 | 341 | 85.46% |
| Assigned | 263 | 184 | 69.96% |
| Pending | 183 | 85 | 46.45% |
| Started | 78 | 74 | 94.87% |
| Unspecified | 36 | 1 | 2.78% |
| Closed | 346,363 | 1,051 | 0.30% |

**Finding:** Closure-date completeness varies considerably across request statuses.

There are also inconsistencies:
- 1,542 requests with a non-Closed status have no closure date.
- 275 requests with a non-Closed status nevertheless have a closure date.
- 1,051 requests marked `Closed` have no closure date.

**Business implication:** Request status and closure-date completeness should be considered together. A missing closure date does not automatically establish that a request remains unresolved.

</details>

<details>
<summary>🏢 <strong>Q3. Which agencies have the longest resolution times?</strong></summary>

The analysis compares average and median resolution durations across agencies.

**Examples from the highest-average results:**

| Agency | Valid requests | Average (hours) | Median (hours) |
|---|---:|---:|---:|
| EDC | 1,815 | 3,749.59 | 3,410.94 |
| DOE | 289 | 1,680.52 | 839.06 |
| TLC | 2,498 | 1,640.89 | 1,651.94 |
| DOB | 6,692 | 1,590.21 | 294.95 |
| DPR | 3,558 | 1,040.08 | 144.12 |

**Findings:**

- EDC has the highest average and median resolution durations in the agency comparison.
- DOB has a substantial difference between its average and median, suggesting a right-skewed distribution.
- HPD handles the largest volume of valid resolved requests among the agencies analyzed.

**Business implication:** Resolution patterns vary considerably across agencies. However, differences in complaint complexity, service responsibilities, and agency-specific service targets must be considered before drawing conclusions about efficiency.

</details>

**Key takeaway:** Average and median resolution times provide complementary information. Agency comparisons can reveal differences in resolution patterns, but they should not be interpreted as direct measures of operational efficiency.

📄 [Explore the complete resolution performance SQL analysis](./03_resolution_performance.sql)

---

## 6. Key Findings

| Analytical area | Main finding |
|---|---|
| Data quality | 348,180 records imported, with no missing request identifiers or duplicate identifiers |
| Complaint demand | Top three complaint categories represent 52.04% of requests |
| Geographic demand | Bronx and Brooklyn represent 59.74% of requests |
| Agency workload | NYPD and HPD handle 75.76% of requests |
| Resolution time | Average: 242.21 hours; median: 15.65 hours |
| Closure completeness | Status and closure-date fields show inconsistencies |
| Agency comparison | Resolution durations vary considerably across agencies |

### 💡 Overall business interpretation

The analysis reveals that NYC 311 service demand is concentrated across specific complaint categories, boroughs, and agencies.

Resolution-time analysis shows a substantial difference between the average and median, indicating that a subset of long-running requests influences the overall results.

Data-quality validation is essential when interpreting these metrics, particularly because request status and closure dates are not always consistent.

## 7. Data Quality & Limitations

<details>
<summary>⚠️ <strong>Click to expand methodological considerations</strong></summary>

1. **Missing closure dates:** Records without valid closure dates cannot be included in completed-request resolution-time calculations.

2. **Negative durations:** Records where the closure date precedes the creation date were excluded from positive-duration calculations.

3. **Zero-second durations:** `DATEDIFF(SECOND, ...)` counts second boundaries. Therefore, a zero result does not necessarily mean that the original timestamps are identical.

4. **Skewed distributions:** Average resolution time is sensitive to unusually long durations. The median provides a useful complementary measure.

5. **Agency comparisons:** Differences in request complexity, responsibilities, and service targets are not accounted for. Resolution duration alone is not a direct measure of agency efficiency.

6. **Extracted dataset:** Resolution-time calculations include only requests with valid creation and closure dates available in the extracted dataset. Requests without valid closure dates are excluded, so results should not be interpreted as the eventual resolution times of every request created during January 2025.

</details>

## 8. SQL Skills Demonstrated

| Skill | Application |
|---|---|
| Data profiling | Missing values, duplicate identifiers, and date validation |
| Data cleaning | `TRIM()`, `NULLIF()`, `TRY_CONVERT()` |
| Conditional aggregation | `CASE WHEN` |
| Grouping and aggregation | `GROUP BY`, `COUNT()`, `SUM()`, `AVG()` |
| Common Table Expressions | Organizing multi-step analytical queries |
| Window functions | Overall and agency-level median calculations |
| Percentile calculations | `PERCENTILE_CONT()` |
| Date calculations | `DATEDIFF()` |
| Analytical metrics | Demand shares, missing-value rates, and resolution durations |
| Business interpretation | Translating SQL results into operational findings |

## 9. Repository Structure

```text
week-02-service-request-operations/
│
├── README.md
├── 01_data_profiling.sql
├── 02_service_demand.sql
└── 03_resolution_performance.sql
```

---

⬅️ [Back to the 8-Week SQL Challenge](../README.md)

**Thanks for exploring this case study!**
