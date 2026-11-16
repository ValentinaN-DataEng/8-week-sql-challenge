
# 🎧 Week 3 — StreamFlow Subscription Analytics & Customer Lifecycle

> **8-Week SQL Challenge · Case Study 03**  
> Analyzing subscription performance, customer retention, and simulated revenue using Microsoft SQL Server.

[![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-CC2927?logo=microsoftsqlserver&logoColor=white)](https://learn.microsoft.com/en-us/sql/sql-server/)
![Dataset](https://img.shields.io/badge/Dataset-Synthetic-blue)
![Status](https://img.shields.io/badge/Status-Completed-success)

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

StreamFlow is a fictional digital audio streaming company offering subscription plans with different prices and billing frequencies.

The company wants to understand customer acquisition, trial conversion, subscription churn, plan transitions, retention, and revenue performance.

**Mission:** Use SQL to transform subscription data into meaningful business insights and evaluate the company's subscription performance.

## 🗂️ Dataset Overview

| Attribute | Details |
|---|---|
| Business | Digital audio streaming |
| Data source | Synthetic data generated with Python and pandas |
| Observation period | January 2024 – December 2025 |
| Observation cutoff | December 31, 2025 |
| Currency | USD |
| Database | Microsoft SQL Server |

### Source Tables

| Dataset | Records | Description |
|---|---:|---|
| Customers | 1,000 | Customer registration information |
| Plans | 7 | Subscription plans and pricing |
| Subscriptions | 1,150 | Subscription lifecycles |
| Subscription_Events | 3,000 | Subscription activity and changes |

An additional `dbo.Payments` table was generated in SQL Server.

### Subscription Rules

- Every subscription starts with a 14-day free trial.
- Customers can have multiple subscription lifecycles.
- Reactivations create new subscription IDs.
- Plan and billing changes are recorded as events.
- NULL end dates indicate ongoing subscriptions.
- Free trials do not generate payments.

## 🔎 Business Questions

Expand each section to explore the analytical questions addressed in this case study.

<details>
<summary><strong>01 — Data Profiling and Validation</strong></summary>

**Objective:** Validate source data quality and relational integrity.

- How many records are available in each table?
- Are there duplicate identifiers or missing values?
- Are foreign-key relationships valid?

**SQL file:** [01_data_validation.sql](sql/01_data_validation.sql)

</details>

<details>
<summary><strong>02 — Customer Acquisition</strong></summary>

**Objective:** Analyze customer registration patterns.

- How many customers registered?
- How does monthly acquisition evolve?
- What was the observed conversion of the January 2025 cohort?

**SQL file:** [02_customer_acquisition.sql](sql/02_customer_acquisition.sql)

</details>

<details>
<summary><strong>03 — Subscription Conversion and Churn</strong></summary>

**Objective:** Evaluate trial conversion and subscription cancellations.

- How many trial lifecycles converted into paid subscriptions?
- What is the trial-to-paid conversion rate?
- How many subscriptions ended?
- Can immediate post-trial cancellations be identified?

**SQL file:** [03_subscription_conversion_and_churn.sql](sql/03_subscription_conversion_and_churn.sql)

</details>

<details>
<summary><strong>04 — Plan Performance and Transitions</strong></summary>

**Objective:** Understand plan distribution and subscription changes.

- Which plans have the highest event activity?
- How are active subscriptions distributed across plans?
- How many customers transition from monthly to annual billing?
- How many plan downgrades occurred?

**SQL file:** [04_plan_analysis_and_transitions.sql](sql/04_plan_analysis_and_transitions.sql)

</details>

<details>
<summary><strong>05 — Customer Lifecycle and Retention</strong></summary>

**Objective:** Analyze repeat subscriptions and customer retention.

- How many customers have multiple subscription lifecycles?
- What is the percentage of repeat customers?
- What is the 90-day subscription retention rate?

**SQL file:** [05_customer_lifecycle_and_retention.sql](sql/05_customer_lifecycle_and_retention.sql)

</details>

<details>
<summary><strong>06 — Payments and Revenue Analytics</strong></summary>

**Objective:** Generate simulated payment records and evaluate revenue performance.

- How many payment records were generated?
- Which plans contribute the most revenue?
- How does revenue vary by billing frequency?
- How does monthly revenue evolve?

**SQL files:**

- [06_payments_generation.sql](sql/06_payments_generation.sql)
- [07_revenue_analysis.sql](sql/07_revenue_analysis.sql)

</details>

## 💻 SQL Solutions

The project contains eight SQL scripts:

| File | Description |
|---|---|
| `00_database_setup.sql` | Database and table creation |
| `01_data_validation.sql` | Data quality and integrity checks |
| `02_customer_acquisition.sql` | Customer acquisition and cohort analysis |
| `03_subscription_conversion_and_churn.sql` | Conversion and churn metrics |
| `04_plan_analysis_and_transitions.sql` | Plan distribution and transitions |
| `05_customer_lifecycle_and_retention.sql` | Repeat subscriptions and retention |
| `06_payments_generation.sql` | Payment schedule generation |
| `07_revenue_analysis.sql` | Revenue analysis and KPIs |

**SQL techniques applied:**

- Joins, aggregations and conditional expressions
- CTEs and subqueries
- Window functions: `ROW_NUMBER()` and `LAG()`
- Date functions: `DATEADD()` and `DATEDIFF()`
- Data conversion and validation
- `CROSS APPLY` and `OUTER APPLY`
- Iterative processing with `WHILE` loops

## 📊 Key Findings

### 1. Customer Acquisition

| Metric | Result |
|---|---:|
| Total registered customers | 1,000 |
| January 2025 registrations | 51 |
| Customers with subscription lifecycles | 49 |
| Observed cohort conversion | 96.08% |

### 2. Trial-to-Paid Conversion

| Metric | Result |
|---|---:|
| Trial lifecycles | 1,150 |
| Converted lifecycles | 1,091 |
| Conversion rate | **94.87%** |

### 3. Subscription Churn

| Metric | Result |
|---|---:|
| Total lifecycles | 1,150 |
| Ended subscriptions | 361 |
| Lifecycle churn rate | **31.39%** |

### 4. Active Subscription Distribution

**791 subscription lifecycles** were active on December 31, 2025.

| Plan | Billing frequency | Active subscriptions |
|---|---|---:|
| Premium | Annual | 142 |
| Family | Annual | 138 |
| Premium | Monthly | 134 |
| Basic | Monthly | 125 |
| Family | Monthly | 113 |
| Basic | Annual | 104 |
| Free Trial | — | 35 |

### 5. Plan Transitions

| Metric | Result |
|---|---:|
| Monthly-to-annual transitions | 95 |
| Plan downgrade events | 84 |
| Average interval before billing transition | 188.76 days |

The downgrade definition is based on a lower plan price while retaining the same billing frequency.

### 6. Customer Lifecycle and Retention

| Metric | Result |
|---|---:|
| Customers with multiple lifecycles | 150 |
| Percentage of repeat customers | 15.00% |
| Eligible lifecycles for 90-day retention | 950 |
| Retained after 90 days | 858 |
| 90-day lifecycle retention | **90.32%** |

### 7. Payments and Revenue Analytics

<details>
<summary><strong>Overall Revenue KPIs</strong></summary>

| Metric | Result |
|---|---:|
| Total payment records | 6,191 |
| Paying subscription lifecycles | 1,091 |
| Total simulated revenue | **$180,144.09** |
| Average payment | $29.10 |
| First payment | January 15, 2024 |
| Last payment | December 31, 2025 |

</details>

#### Revenue by Plan

| Plan | Frequency | Payments | Revenue (USD) |
|---|---|---:|---:|
| Family | Annual | 274 | 49,317.26 |
| Premium | Annual | 297 | 35,637.03 |
| Family | Monthly | 1,711 | 34,202.89 |
| Premium | Monthly | 1,824 | 23,693.76 |
| Basic | Annual | 229 | 20,607.71 |
| Basic | Monthly | 1,856 | 16,685.44 |

**Key observations:**

- Family Annual generated the highest revenue.
- Basic Monthly generated the most payment records but the lowest revenue.
- Annual billing contributed approximately **58.6%** of total simulated revenue.

## 🧹 Data Quality and Limitations

- The source datasets are synthetic and do not represent real customers.
- No subscriptions contained both `TRIAL_EXPIRED` and subsequent `CANCELLED` events within the investigated seven-day window. Immediate post-trial cancellation could not be measured reliably.
- Conversion, churn, and retention are measured at the subscription-lifecycle level.
- The 188.76-day upgrade interval measures time between subscription events, not exact monthly-plan tenure.
- Payment records represent simulated revenue, not verified cash collected.
- The payment model excludes prorations, refunds, failed payments, taxes, and discounts.
- Billing changes to annual trigger an immediate payment and reset the billing cycle.

## 🧠 Skills Practiced

- SQL Server and T-SQL
- Data profiling and validation
- Relational database design
- Joins and aggregations
- CTEs and subqueries
- Window functions
- Date calculations
- Customer acquisition and cohort analysis
- Subscription conversion and churn
- Lifecycle and retention analysis
- Payment schedule generation
- Revenue analysis and business interpretation

## 🗃️ Project Structure

```text
week-03-subscription-analytics/
├── README.md
├── data/
│   ├── README
│   ├── customers.csv
│   ├── plans.csv
│   ├── subscription_events.csv
│   └── subscriptions.csv
├── python/
│   └── generate_data.py
└── sql/
    ├── README
    ├── 00_database_setup.sql
    ├── 01_data_validation.sql
    ├── 02_customer_acquisition.sql
    ├── 03_subscription_conversion_and_churn.sql
    ├── 04_plan_analysis_and_transitions.sql
    ├── 05_customer_lifecycle_and_retention.sql
    ├── 06_payments_generation.sql
    └── 07_revenue_analysis.sql
```

## 🚀 Future Improvements

- [ ] Improve consistency between subscription dates and event records.
- [ ] Develop customer-level cohort retention analysis.
- [ ] Calculate MRR, ARR, and customer lifetime value.
- [ ] Incorporate failed payments and refunds.
- [ ] Build a Power BI subscription performance dashboard.

---

*Part of an original 8-Week SQL Challenge portfolio focused on solving business problems through SQL and data analysis.*
