# 🧠 8-Week SQL Challenge

> A business-driven SQL portfolio exploring real-world and synthetic datasets through data analysis, problem-solving, and actionable insights.

[![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-CC2927?logo=microsoftsqlserver&logoColor=white)](https://learn.microsoft.com/en-us/sql/sql-server/)
![Case Studies](https://img.shields.io/badge/Case%20Studies-8-blue)
![Progress](https://img.shields.io/badge/Progress-3%2F8%20Weeks-orange)

Welcome! This repository documents my **8-week SQL challenge**, where I solve original business cases using Microsoft SQL Server, real-world datasets, and synthetic data.

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
| [03](./week-03-subscription-analytics/) | StreamFlow Subscription Analytics & Customer Lifecycle | Subscription conversion, churn, plan transitions, retention, payment generation, revenue analysis | ✅ Completed |
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

### Week 3 — StreamFlow Subscription Analytics & Customer Lifecycle

**Business question:** How effectively does a subscription business convert trial users, retain customers, manage subscription changes, and generate revenue?

**Dataset:** Synthetic subscription data generated using Python and pandas.

The project simulates a digital audio streaming company with 1,000 customers, seven subscription plans, 1,150 subscription lifecycles, and 3,000 subscription events.

Using SQL Server, I analyzed customer acquisition, trial conversion, subscription churn, plan transitions, retention, and simulated revenue. I also generated a payment history using SQL based on defined subscription billing rules.

**Key activities:**
- Generated and imported synthetic datasets using Python and pandas.
- Designed relational tables with primary keys, foreign keys, and constraints.
- Profiled source data and validated referential integrity.
- Analyzed monthly customer acquisition and cohort conversion.
- Calculated trial-to-paid conversion and subscription churn.
- Used window functions to identify plan transitions and historical subscription states.
- Evaluated repeat subscription lifecycles and 90-day retention.
- Generated recurring payment records and analyzed revenue by plan and billing frequency.

**Key findings:**
- Trial-to-paid conversion reached **94.87%**, representing 1,091 converted subscription lifecycles.
- Lifecycle churn was **31.39%**, based on 361 ended subscriptions.
- **15%** of customers had multiple subscription lifecycles.
- 90-day lifecycle retention reached **90.32%**.
- Monthly-to-annual billing transitions accounted for **95 events**.
- Total simulated revenue reached **$180,144.09** across 6,191 payment records.
- Family Annual generated the highest revenue, contributing **$49,317.26**.

**Key takeaway:** Subscription analytics requires connecting customer behavior, lifecycle events, billing rules, and revenue metrics. The case study also highlights the importance of documenting assumptions and data limitations when working with synthetic business data.

📂 **[Explore Week 3 — StreamFlow Subscription Analytics & Customer Lifecycle](./week-03-subscription-analytics/)**

---

## 🛠️ Tools & Techniques

**Database and development environment**
- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Python and pandas
- Socrata API for public data extraction
- Git and GitHub

**SQL techniques practiced**
- Data profiling and quality validation
- `SELECT`, `WHERE`, `ORDER BY`, and `TOP`
- `CASE WHEN` and conditional aggregation
- `GROUP BY`, `HAVING`, `SUM`, `AVG`, and `COUNT`
- `COUNT(DISTINCT)` and duplicate identification
- Common Table Expressions (CTEs)
- Data type conversion using `TRY_CAST` and `TRY_CONVERT`
- NULL and blank-value handling
- Date calculations using `DATEDIFF` and `DATEADD`
- Window functions: `ROW_NUMBER()` and `LAG()`
- Median calculation using `PERCENTILE_CONT`
- Subqueries and `CROSS APPLY`
- Iterative processing using `WHILE` loops
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
│   └── SQL scripts
│
├── week-02-service-request-operations/
│   ├── README.md
│   └── SQL scripts
│
├── week-03-subscription-analytics/
│   ├── README.md
│   ├── data/
│   │   ├── README
│   │   ├── customers.csv
│   │   ├── plans.csv
│   │   ├── subscription_events.csv
│   │   └── subscriptions.csv
│   ├── python/
│   │   └── generate_data.py
│   └── sql/
│       ├── README
│       ├── 00_database_setup.sql
│       ├── 01_data_validation.sql
│       ├── 02_customer_acquisition.sql
│       ├── 03_subscription_conversion_and_churn.sql
│       ├── 04_plan_analysis_and_transitions.sql
│       ├── 05_customer_lifecycle_and_retention.sql
│       ├── 06_payments_generation.sql
│       └── 07_revenue_analysis.sql
│
├── week-04/
├── week-05/
├── week-06/
├── week-07/
└── week-08/
```

Future week folders will be added as their case studies are completed.

## 👩‍💻 About This Project

This is an original, self-directed SQL portfolio challenge created to strengthen my practical data analytics skills.

The case studies use business-oriented questions and publicly available datasets wherever appropriate. Synthetic data is also used when a business scenario requires a controlled dataset to explore specific analytical concepts.

Each project is developed independently, with an emphasis on analytical reasoning, data validation, and communicating findings.

The challenge is inspired by the broader practice of SQL case-study challenges, while its scenarios, queries, and analytical work are developed independently.

---

**Thanks for visiting!** Explore the completed case studies and follow the repository as the challenge progresses.
