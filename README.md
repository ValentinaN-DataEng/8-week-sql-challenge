# 🧠 8-Week SQL Challenge

> A business-driven SQL portfolio exploring real-world datasets through data analysis, problem-solving, and actionable insights.

[![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-CC2927?logo=microsoftsqlserver&logoColor=white)](https://learn.microsoft.com/en-us/sql/sql-server/)
![Case Studies](https://img.shields.io/badge/Case%20Studies-8-blue)
![Progress](https://img.shields.io/badge/Progress-2%2F8%20Weeks-orange)

Welcome! This repository documents my **8-week SQL challenge**, where I solve original business cases using Microsoft SQL Server and real-world datasets.

Rather than focusing only on SQL syntax, each case study follows a business-driven analytical workflow: understanding the problem, profiling the data, developing queries, validating results, and communicating meaningful findings.

The goal is to strengthen my SQL skills while developing the analytical thinking required to transform raw data into actionable business insights.

## 🎯 Challenge Objectives

- Strengthen SQL skills through practical business questions.
- Practice data cleaning, transformation, aggregation, and analysis.
- Develop the ability to translate query results into business insights.
- Work with real-world datasets and understand their limitations.
- Build a portfolio demonstrating analytical thinking and technical skills.
- Progress from foundational SQL techniques toward more advanced analysis.

## 🗺️ Challenge Roadmap

| Week | Case Study | Focus Areas | Status |
|---|---|---|---|
| [01](./week-01-customer-analytics/) | Customer Analytics | Data profiling, transaction analysis, customer revenue, purchasing behavior | ✅ Completed |
| [02](./week-02-service-request-operations/) | NYC 311 Service Request Operations & Performance | Data quality, service demand, geographic analysis, window functions, resolution times | ✅ Completed |
| 03 | To be announced | Joins and relational analysis | 🔜 Planned |
| 04 | To be announced | CTEs, subqueries, and analytical logic | 🔜 Planned |
| 05 | To be announced | Advanced window functions and ranking | 🔜 Planned |
| 06 | To be announced | Customer segmentation and performance analysis | 🔜 Planned |
| 07 | To be announced | Advanced analytical case study | 🔜 Planned |
| 08 | To be announced | Capstone analysis and business recommendations | 🔜 Planned |

*The roadmap is provisional. Upcoming case studies will be defined around their business scenarios, datasets, and analytical objectives.*

## 🔍 Featured Case Studies

### Week 1 — Customer Analytics

**Business question:** Which customers contribute the most transaction value, and what can purchasing behavior tell us about customer value?

**Dataset:** [UCI Online Retail](https://archive.ics.uci.edu/dataset/352/online+retail)

Using 541,909 raw transaction records, I explored transaction quality, customer-level revenue, purchasing quantities, and invoice counts.

**Key activities:**
- Profiled and validated raw transaction data.
- Checked data types, missing values, and conversion issues.
- Compared positive-quantity transaction value with net transaction value.
- Ranked customers by net transaction value.
- Examined purchasing frequency and revenue-per-net-unit metrics.

**Key takeaway:** Customer transaction value and purchasing frequency provide complementary perspectives for understanding customer contribution.

📂 **[Explore Week 1 — Customer Analytics](./week-01-customer-analytics/)**

---

### Week 2 — NYC 311 Service Request Operations & Performance

**Business question:** Where is demand for public services concentrated, how is the workload distributed across agencies, and what can resolution times reveal about service operations?

**Dataset:** [NYC 311 Service Requests — NYC Open Data](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9)

Using the Socrata API, I extracted **348,180 service request records** for January 2025 and analyzed service demand, geographic distribution, agency workload, and resolution patterns.

**Key activities:**
- Imported and profiled 348,180 records in SQL Server.
- Evaluated missing values, duplicate identifiers, and date inconsistencies.
- Identified the most frequent complaint categories and their demand shares.
- Compared service request volumes across NYC boroughs.
- Analyzed workload distribution across government agencies.
- Calculated average and median resolution times overall and by agency.
- Investigated inconsistencies between request status and closure dates.

**Key findings:**
- The three most frequent complaint categories account for approximately **52.04%** of all requests.
- The Bronx and Brooklyn account for approximately **59.74%** of requests.
- NYPD and HPD handle approximately **75.76%** of the requests.
- Average resolution time is **242.21 hours**, compared with a median of **15.65 hours**, indicating a strongly right-skewed distribution.

**Key takeaway:** Operational demand is concentrated across specific complaint categories, boroughs, and agencies. Resolution-time analysis also demonstrates why averages, medians, and data-quality checks should be considered together.

📂 **[Explore Week 2 — NYC 311 Service Request Operations & Performance](./week-02-service-request-operations/)**

---

## 🛠️ Tools & Techniques

**Database and development environment**
- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Python and Socrata API for data extraction

**SQL techniques practiced**
- Data profiling and quality validation
- `SELECT`, `WHERE`, `ORDER BY`, and `TOP`
- `CASE WHEN` and conditional aggregation
- `GROUP BY`, `HAVING`, `SUM`, `AVG`, and `COUNT`
- `COUNT(DISTINCT)` and duplicate identification
- Common Table Expressions (CTEs)
- Data type conversion using `TRY_CAST` and `TRY_CONVERT`
- NULL and blank-value handling
- Date calculations using `DATEDIFF`
- Window functions and ranking
- Median calculation using `PERCENTILE_CONT`
- Percentage calculations and analytical metrics

Additional SQL techniques and tools will be introduced as the challenge progresses.

## 📈 My Analytical Workflow

Each case study follows a consistent process:

1. **Understand** — Define the business scenario and analytical questions.
2. **Profile** — Inspect the dataset, identify missing values, and validate data types.
3. **Analyze** — Write SQL queries to calculate relevant metrics and investigate business questions.
4. **Validate** — Check assumptions, conversion failures, duplicates, and analytical limitations.
5. **Interpret** — Translate query results into evidence-based business findings.
6. **Document** — Publish SQL scripts, methodology, findings, and limitations in a case-study README.

## 📁 Repository Structure

```text
8-week-sql-challenge/
│
├── README.md
│
├── week-01-customer-analytics/
│   ├── README.md
│   ├── 01_data_profiling.sql
│   └── 02_customer_analysis.sql
│
├── week-02-service-request-operations/
│   ├── README.md
│   ├── 01_data_profiling.sql
│   ├── 02_service_demand.sql
│   └── 03_resolution_performance.sql
│
├── week-03/
├── week-04/
├── week-05/
├── week-06/
├── week-07/
└── week-08/
```

Future week folders will be added as their case studies are completed.

## 👩‍💻 About This Project

This is an original, self-directed SQL portfolio challenge created to strengthen my practical data analytics skills.

The case studies use business-oriented questions and publicly available datasets wherever appropriate. Each project is developed independently, with an emphasis on analytical reasoning, data validation, and communicating findings.

The challenge is inspired by the broader practice of SQL case-study challenges, while its scenarios, queries, and analytical work are developed independently.

---

**Thanks for visiting!** Explore the completed case studies and follow the repository as the challenge progresses.
