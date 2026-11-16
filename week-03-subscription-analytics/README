# 🎧 Week 3 — StreamFlow Subscription Analytics & Customer Lifecycle

> **8-Week SQL Challenge · Case Study 03**
> Analyzing subscription conversion, customer lifecycle, retention, and simulated revenue using Microsoft SQL Server.


\


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

StreamFlow is a fictional digital audio streaming company offering subscription plans with different pricing and billing frequencies.

The company collects information about customer registrations, subscription lifecycles, plan changes, billing transitions, and cancellations. However, these records alone do not provide a clear understanding of customer behavior or subscription performance.

The business wants to identify how effectively free-trial users convert into paying subscribers, which subscription plans generate the most revenue, how customers move between plans, and how many customers return after ending a subscription.

**Mission:** Transform subscription and customer event data into business insights by analyzing customer acquisition, trial conversion, churn, plan transitions, customer retention, and simulated revenue using SQL.

## 🗂️ Dataset Overview

| Attribute          | Details                                                |
| ------------------ | ------------------------------------------------------ |
| Business           | StreamFlow (fictional digital audio streaming company) |
| Dataset            | Synthetic subscription and customer data               |
| Generation method  | Python and pandas                                      |
| Observation period | January 2024 – December 2025                           |
| Observation cutoff | December 31, 2025                                      |
| Currency           | USD                                                    |
| Database           | Microsoft SQL Server                                   |
| SQL dialect        | T-SQL                                                  |

The project uses four synthetic source datasets generated with Python and imported into SQL Server.

| Dataset             | Records | Description                                                             |
| ------------------- | ------: | ----------------------------------------------------------------------- |
| Customers           |   1,000 | Customer registration dates and countries                               |
| Plans               |       7 | Subscription plans, billing frequencies, and prices                     |
| Subscriptions       |   1,150 | Customer subscription lifecycles and dates                              |
| Subscription_Events |   3,000 | Trial, activation, plan change, billing change, and cancellation events |

An additional `dbo.Payments` table was created in SQL Server to generate simulated subscription payment records.

### Subscription Model

The dataset follows these business rules:

- Every subscription lifecycle begins with a 14-day free trial.
- Customers may have multiple subscription lifecycles.
- Each reactivation creates a new subscription ID and a new trial period.
- Plan and billing-frequency changes are recorded as subscription events.
- A NULL subscription end date indicates an ongoing subscription.
- Free trials do not generate payments.

The synthetic data was generated using Python and pandas. Payment records were subsequently generated in SQL Server based on subscription events and defined billing rules.

## 🔎 Business Questions

Expand each section to explore the analytical questions addressed in this case study.

\<details> \<summary>\<strong>01 — Customer Acquisition\</strong>\</summary>

**Business objective:** Understand customer registration patterns and identify how acquisition evolves over time.

Questions investigated:

- How many customers registered during the observation period?
- How does customer acquisition vary by month?
- How many customers registered in January 2025?
- How many customers from the January 2025 cohort subsequently started a subscription lifecycle?

**SQL file:** [`02_customer_acquisition.sql`](sql/02_customer_acquisition.sql)

\</details>

\<details> \<summary>\<strong>02 — Subscription Conversion and Churn\</strong>\</summary>

**Business objective:** Evaluate trial-to-paid conversion and understand the proportion of subscription lifecycles that end.

Questions investigated:

- How many subscription lifecycles started a free trial?
- How many subscription lifecycles converted into paid subscriptions?
- What is the trial-to-paid conversion rate?
- How many subscription lifecycles have ended?
- What is the overall lifecycle churn rate?
- Are there subscriptions with a cancellation event within seven days after trial expiration?

**SQL file:** [`03_subscription_conversion_and_churn.sql`](sql/03_subscription_conversion_and_churn.sql)

\</details>

\<details> \<summary>\<strong>03 — Plan Performance and Subscription Transitions\</strong>\</summary>

**Business objective:** Understand subscription plan activity and identify how customers change their subscription configurations.

Questions investigated:

- Which plans have the highest number of subscription events?
- How are active subscription lifecycles distributed across plans at the observation cutoff?
- How many customers transition from monthly to annual billing?
- How many plan changes represent downgrades based on subscription price?
- What is the average interval between the preceding event and a monthly-to-annual billing transition?

**SQL file:** [`04_plan_analysis_and_transitions.sql`](sql/04_plan_analysis_and_transitions.sql)

\</details>

\<details> \<summary>\<strong>04 — Customer Lifecycle and Retention\</strong>\</summary>

**Business objective:** Understand repeat subscription activity and evaluate subscription retention.

Questions investigated:

- How many customers have more than one subscription lifecycle?
- What percentage of customers with subscriptions have multiple lifecycles?
- How many subscription lifecycles are eligible for a 90-day retention analysis?
- How many remain active after 90 days?
- What is the 90-day subscription lifecycle retention rate?

**SQL file:** [`05_customer_lifecycle_and_retention.sql`](sql/05_customer_lifecycle_and_retention.sql)

\</details>

\<details> \<summary>\<strong>05 — Payments and Revenue Analytics\</strong>\</summary>

**Business objective:** Generate a simulated payment history and evaluate revenue performance across subscription plans and billing frequencies.

Questions investigated:

- How can payment records be generated from subscription events?
- How many payment records are generated during the observation period?
- Which plans and billing frequencies contribute the most simulated revenue?
- How does simulated revenue evolve monthly?
- What is the average payment amount?
- Which subscription configurations generate the highest revenue?

**SQL files:**

- [`06_payments_generation.sql`](sql/06_payments_generation.sql)
- [`07_revenue_analysis.sql`](sql/07_revenue_analysis.sql)

\</details>

## 💻 SQL Solutions

The analysis is organized into eight SQL scripts:

| File                                                                                       | Purpose                                                                                     |
| ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------- |
| [`00_database_setup.sql`](sql/00_database_setup.sql)                                       | Database creation and source table definitions, primary keys, foreign keys, and constraints |
| [`01_data_validation.sql`](sql/01_data_validation.sql)                                     | Record counts, NULL checks, duplicate identification, and referential integrity validation  |
| [`02_customer_acquisition.sql`](sql/02_customer_acquisition.sql)                           | Total customer registrations, monthly acquisition, and cohort analysis                      |
| [`03_subscription_conversion_and_churn.sql`](sql/03_subscription_conversion_and_churn.sql) | Trial-to-paid conversion, lifecycle churn, and post-trial cancellation investigation        |
| [`04_plan_analysis_and_transitions.sql`](sql/04_plan_analysis_and_transitions.sql)         | Subscription events by plan, active plan distribution, billing transitions, and downgrades  |
| [`05_customer_lifecycle_and_retention.sql`](sql/05_customer_lifecycle_and_retention.sql)   | Repeat subscription lifecycles and 90-day retention                                         |
| [`06_payments_generation.sql`](sql/06_payments_generation.sql)                             | Payment table creation, payment schedule generation, validation, and insertion              |
| [`07_revenue_analysis.sql`](sql/07_revenue_analysis.sql)                                   | Revenue by plan, monthly revenue trend, and overall revenue KPIs                            |

The project applies SQL Server techniques including:

- Data profiling and validation
- `COUNT`, `SUM`, `AVG`, and conditional aggregation
- `GROUP BY`, `HAVING`, and `ORDER BY`
- `INNER JOIN` and `LEFT JOIN`
- Common Table Expressions (CTEs)
- `CASE WHEN` expressions
- Window functions: `ROW_NUMBER()` and `LAG()`
- Date calculations using `DATEADD()` and `DATEDIFF()`
- `TRY_CAST()` and `TRY_CONVERT()`
- Subqueries and `CROSS APPLY` / `OUTER APPLY`
- Recursive payment scheduling through iterative SQL processing
- Percentage calculations and business metrics

## 📊 Key Findings

The findings below are based on the SQL query results obtained during the case study. Conversion, churn, and retention metrics are calculated at the subscription-lifecycle level unless otherwise specified.

### 1. Customer acquisition

A total of **1,000 customers** registered during the observation period.

The January 2025 registration cohort contained:

| Metric                                  | Result |
| --------------------------------------- | -----: |
| Registered customers                    |     51 |
| Customers with a subscription lifecycle |     49 |
| Observed conversion rate                | 96.08% |

The observed conversion rate represents customers who had started a subscription lifecycle by the observation cutoff. It should not be interpreted as a fully matured cohort conversion rate.

### 2. Trial-to-paid conversion

The analysis identified the following conversion results:

| Conversion metric                 | Result |
| --------------------------------- | -----: |
| Trial subscription lifecycles     |  1,150 |
| Converted subscription lifecycles |  1,091 |
| Trial-to-paid conversion rate     | 94.87% |

The conversion rate was calculated by dividing the number of distinct subscription lifecycles with a `PLAN_ACTIVATED` event by the number of distinct lifecycles with a `TRIAL_STARTED` event.

The resulting conversion rate is high and should be interpreted in the context of the synthetic dataset and its generation rules.

### 3. Subscription churn

A total of **361 subscription lifecycles** had an end date recorded.

| Churn metric                      | Result |
| --------------------------------- | -----: |
| Total subscription lifecycles     |  1,150 |
| Ended subscriptions               |    361 |
| Subscriptions without an end date |    789 |
| Lifecycle churn rate              | 31.39% |

The churn calculation considers a subscription lifecycle ended whenever its `end_date` is not NULL.

This is a cumulative lifecycle churn measure, not a monthly churn rate.

### 4. Active subscription distribution

At the observation cutoff of December 31, 2025, **791 subscription lifecycles** were classified as active.

The latest recorded plan for each active lifecycle was identified using `ROW_NUMBER()` and ordered by event date and event ID.

| Plan       | Billing frequency | Active subscriptions |
| ---------- | ----------------- | -------------------: |
| Premium    | Annual            |                  142 |
| Premium    | Monthly           |                  134 |
| Basic      | Monthly           |                  125 |
| Family     | Monthly           |                  113 |
| Family     | Annual            |                  138 |
| Basic      | Annual            |                  104 |
| Free Trial | —                 |                   35 |

This analysis provides a snapshot of the subscription portfolio at the observation cutoff.

### 5. Plan transitions

The event history was used to identify billing-frequency changes and plan downgrades.

| Transition metric                     | Result |
| ------------------------------------- | -----: |
| Monthly-to-annual billing transitions |     95 |
| Affected subscription lifecycles      |     95 |
| Plan downgrade events                 |     84 |
| Affected subscription lifecycles      |     84 |

A downgrade was defined as a `PLAN_CHANGED` event where the new plan price was lower than the previous plan price while retaining the same billing frequency.

The time interval between the preceding event and a monthly-to-annual billing transition was also calculated.

| Upgrade interval metric |      Result |
| ----------------------- | ----------: |
| Upgrade events          |          95 |
| Average interval        | 188.76 days |
| Minimum interval        |     31 days |
| Maximum interval        |    620 days |

This interval measures the time between the immediately preceding subscription event and the billing transition. It does not necessarily represent the exact time spent on a monthly billing plan.

### 6. Customer lifecycle and retention

The analysis identified customers with multiple subscription lifecycles, representing repeat subscription activity.

| Customer lifecycle metric          | Result |
| ---------------------------------- | -----: |
| Customers with multiple lifecycles |    150 |
| Total customers with subscriptions |  1,000 |
| Customers with multiple lifecycles | 15.00% |

The 90-day retention analysis evaluated subscription lifecycles that had sufficient observation time before the December 31, 2025 cutoff.

| Retention metric                 | Result |
| -------------------------------- | -----: |
| Eligible subscription lifecycles |    950 |
| Retained after 90 days           |    858 |
| Not retained after 90 days       |     92 |
| 90-day lifecycle retention rate  | 90.32% |

A subscription lifecycle was considered retained if its end date was NULL or occurred on or after its 90th day.

This metric measures subscription lifecycle retention rather than unique-customer retention.

### 7. Payments and revenue analytics

The payment extension generated recurring payment records based on subscription activation, billing frequency, plan changes, and billing changes.

The payment schedule was restricted to the observation cutoff and each subscription's effective end date.

#### Overall revenue KPIs

| Revenue metric                        |            Result |
| ------------------------------------- | ----------------: |
| Total payment records                 |             6,191 |
| Subscription lifecycles with payments |             1,091 |
| Total simulated revenue               |       $180,144.09 |
| Average payment                       |            $29.10 |
| First payment date                    |  January 15, 2024 |
| Last payment date                     | December 31, 2025 |

#### Revenue by plan and billing frequency

| Plan    | Billing frequency | Payments | Revenue (USD) |
| ------- | ----------------- | -------: | ------------: |
| Family  | Annual            |      274 |     49,317.26 |
| Premium | Annual            |      297 |     35,637.03 |
| Family  | Monthly           |    1,711 |     34,202.89 |
| Premium | Monthly           |    1,824 |     23,693.76 |
| Basic   | Annual            |      229 |     20,607.71 |
| Basic   | Monthly           |    1,856 |     16,685.44 |

#### Key revenue observations

- Family Annual generated the highest revenue among the six paid plan configurations, contributing **$49,317.26**.
- Basic Monthly generated the highest number of payment records, with **1,856 payments**, but the lowest total revenue.
- Annual billing contributed approximately **58.6% of total simulated revenue**.
- Monthly billing contributed approximately **41.4% of total simulated revenue**.

These results demonstrate how billing frequency and plan pricing influence the revenue distribution, even when monthly plans generate more individual payment records.

## 🧹 Data Quality and Limitations

### Subscription event consistency

The post-trial cancellation investigation attempted to identify subscriptions with both `TRIAL_EXPIRED` and `CANCELLED` events, where cancellation occurred within seven days after trial expiration.

The event records contained:

- 337 distinct subscriptions with `CANCELLED` events.
- 24 distinct subscriptions with `TRIAL_EXPIRED` events.
- No subscriptions containing both event types in the required sequence.

Consequently, the immediate post-trial cancellation metric could not be reliably calculated from the available event records.

### Subscription lifecycle and retention definitions

- Multiple subscription lifecycles belong to the same customer but have different subscription IDs.
- Churn is measured using the subscription end date, not individual cancellation events.
- Conversion and retention are calculated at the subscription-lifecycle level.
- The 90-day retention calculation only includes lifecycles with at least 90 days of observable history before the cutoff.

### Payment generation assumptions

The payment extension uses the following assumptions:

- The first payment occurs on the `PLAN_ACTIVATED` event date.
- Monthly billing generates recurring payments every month.
- Annual billing generates recurring payments every 12 months.
- An annual billing change triggers an immediate payment on the transition date and resets the next billing cycle.
- A plan change applies the new plan price to the next scheduled payment.
- The effective subscription end date prevents subsequent payment generation.
- No prorated charges or refunds are modeled.

### Remaining limitations

- All source datasets are synthetic and do not represent actual customers or commercial transactions.
- The generated payment records represent simulated revenue, not verified cash collected from customers.
- The high trial conversion rate reflects the synthetic event model and should not be generalized to real subscription businesses.
- The upgrade interval measures the time between subscription events rather than exact plan tenure.
- The immediate post-trial cancellation analysis is limited by inconsistencies in the event records.
- No payment failures, refunds, taxes, discounts, or payment-processing fees are modeled.
- Revenue results depend on the defined payment-generation assumptions and should not be interpreted as audited financial performance.

## 🧠 Skills Practiced

- Data profiling and quality validation
- Relational database design and constraints
- Data modeling and foreign-key relationships
- Data type handling and NULL validation
- Conditional aggregation using `CASE WHEN`
- Complex joins and subqueries
- Common Table Expressions (CTEs)
- Window functions: `ROW_NUMBER()` and `LAG()`
- Historical subscription-state analysis
- Customer acquisition and cohort analysis
- Subscription conversion and churn metrics
- Customer lifecycle and retention analysis
- Date calculations using `DATEADD()` and `DATEDIFF()`
- Payment schedule generation using SQL
- Revenue aggregation and performance analysis
- Business-oriented interpretation of analytical results
- Documenting assumptions and data limitations

## 🗃️ Project Structure

```text
8-week-sql-challenge/
├── README.md
├── week-01-customer-analytics/
├── week-02-service-request-operations/
└── week-03-subscription-analytics/
    ├── README.md
    ├── data/
    │   ├── README.md
    │   ├── customers.csv
    │   ├── plans.csv
    │   ├── subscription_events.csv
    │   └── subscriptions.csv
    ├── python/
    │   └── generate_data.py
    └── sql/
        ├── 00_database_setup.sql
        ├── 01_data_validation.sql
        ├── 02_customer_acquisition.sql
        ├── 03_subscription_conversion_and_churn.sql
        ├── 04_plan_analysis_and_transitions.sql
        ├── 05_customer_lifecycle_and_retention.sql
        ├── 06_payments_generation.sql
        └── 07_revenue_analysis.sql
```

The root README provides the roadmap for the full eight-week challenge. Each weekly folder contains its own case-study documentation, datasets, and SQL scripts.

## 🚀 Future Improvements

The core Week 3 analysis is complete. Potential extensions include:

- [ ] Investigate and improve consistency between subscription lifecycle dates and event records.
- [ ] Develop a more detailed customer-level cohort retention analysis.
- [ ] Analyze monthly recurring revenue (MRR) and annual recurring revenue (ARR).
- [ ] Incorporate payment failures, refunds, and discounts into the payment model.
- [ ] Compare customer lifetime value across subscription plans.
- [ ] Connect the SQL analysis to Power BI to develop a subscription performance dashboard.

---

*Part of an original, self-directed eight-week SQL portfolio challenge using Microsoft SQL Server, synthetic datasets, and business-oriented analytical questions.*
