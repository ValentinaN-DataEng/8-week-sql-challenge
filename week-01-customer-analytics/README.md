# 🛍️ Week 1 — Customer Analytics

> **8-Week SQL Challenge · Case Study 01**  
> Exploring customer purchasing behavior with Microsoft SQL Server.

[![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-CC2927?logo=microsoftsqlserver&logoColor=white)](https://learn.microsoft.com/en-us/sql/sql-server/)
[![Dataset](https://img.shields.io/badge/Dataset-UCI%20Online%20Retail-blue)](https://archive.ics.uci.edu/dataset/352/online+retail)
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

---

## 🎯 Business Scenario

An online retailer wants to better understand its customers and identify the purchasing behaviors associated with higher customer value.

The business has transaction-level data, but raw transactions alone do not explain which customers contribute the most revenue, how returns affect transaction values, or whether purchasing frequency is associated with customer value.

**Your mission:** Transform raw retail transactions into useful customer-level metrics and evidence-based business insights using SQL.

## 🗂️ Dataset Overview

| Attribute | Details |
|---|---|
| Dataset | Online Retail |
| Source | [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/352/online+retail) |
| Original records | 541,909 rows |
| Database | Microsoft SQL Server |
| Raw table | `dbo.OnlineRetail_Raw` |
| SQL dialect | T-SQL |

The dataset contains retail transaction information, including invoice numbers, products, quantities, prices, invoice dates, customer IDs, and countries.

## 🔎 Business Questions

Use the expandable sections below to explore the questions addressed in this case study.

<details>
<summary><strong>01 — Data Profiling and Quality</strong></summary>

**Business objective:** Understand the reliability of the raw data before performing analysis.

Questions investigated:

- Which columns contain missing values?
- How many invoice rows are cancellations?
- How many rows have negative quantities?
- Which raw columns require type conversion?
- Can quantities, prices, and dates be converted successfully?

**SQL file:** `01_data_profiling.sql`

</details>

<details>
<summary><strong>02 — Highest-Revenue Customers</strong></summary>

**Business objective:** Identify the customers contributing the highest net transaction value.

Questions investigated:

- How many unique customers can be identified?
- Which 10 customers rank highest by net transaction value?
- How do their net quantities compare?

**SQL file:** `02_customer_analysis.sql`

</details>

<details>
<summary><strong>03 — Gross vs. Net Transaction Value</strong></summary>

**Business objective:** Understand how negative-quantity transactions affect overall transaction value.

Questions investigated:

- What is the transaction value from positive-quantity rows?
- What is the net transaction value when negative quantities are included?
- What is the difference between these two measures?

**SQL file:** `02_customer_analysis.sql`

</details>

<details>
<summary><strong>04 — Customer Purchasing Behavior</strong></summary>

**Business objective:** Compare the purchasing patterns of high-value customers.

Metrics calculated:

- Total net quantity
- Total net transaction value
- Average unit price
- Revenue per net unit
- Distinct invoice count
- Average net transaction value per invoice

**SQL file:** `02_customer_analysis.sql`

</details>

## 💻 SQL Solutions

The SQL scripts are organized by analytical task:

| File | Purpose |
|---|---|
| [`01_data_profiling.sql`](01_data_profiling.sql) | Data profiling, quality checks, and conversion validation |
| [`02_customer_analysis.sql`](02_customer_analysis.sql) | Customer aggregation, revenue metrics, and purchasing behavior |

The analysis uses common SQL techniques, including `CASE WHEN`, `SUM`, `COUNT(DISTINCT)`, `GROUP BY`, CTEs, `TRY_CAST`, `TRY_CONVERT`, and `TOP`.

## 📊 Key Findings

### 1. Customer value and purchasing frequency

Customer **14646** ranked first in both net transaction value and distinct invoice count among the top-revenue customers examined.

This suggests that purchasing frequency may be associated with customer value. Further analysis is needed to separate its influence from order size and product mix.

### 2. Revenue per net unit

Customer **18102** had a revenue-per-net-unit ratio of **3.99**, the highest among the top three customers examined.

This demonstrates that the customer generating the highest total transaction value does not necessarily have the highest revenue-per-net-unit ratio.

### 3. Gross vs. net transaction value

| Metric | Result |
|---|---:|
| Gross transaction value | 1,064,456.42 |
| Net transaction value | 974,747.93 |
| Difference | 89,708.49 |
| Difference as a percentage of gross | 8.43% |

Under the definitions used in this analysis, the net transaction value was approximately **8.43% lower** than the positive-quantity transaction value.

This difference should not be attributed to returns alone: cancellation invoices and other negative-quantity transactions have not yet been isolated and reconciled.

## 🧹 Data Quality and Limitations

The corrected conversion checks returned zero failed conversions among nonblank values for:

- `Quantity`
- `UnitPrice`
- `InvoiceDate`

Other considerations remain:

- Customer IDs and product descriptions contain missing values.
- Negative quantities and cancellation invoices require separate analysis.
- Invoice counts currently include cancellation invoices.
- Revenue-per-net-unit and average net transaction value per invoice are exploratory metrics, not official accounting measures.
- Transaction values are calculated as `Quantity × UnitPrice`. Currency and accounting treatment have not been independently verified.
- The raw dataset is retained separately; these scripts analyze `dbo.OnlineRetail_Raw` without modifying it.

## 🧠 Skills Practiced

- Data profiling and quality validation
- Data type conversion and error handling
- Conditional aggregation with `CASE WHEN`
- Customer-level aggregation with `GROUP BY`
- Common Table Expressions (CTEs)
- Distinct counts and customer ranking
- Revenue calculations and percentage comparisons
- Translating SQL results into business insights

## 🗃️ Project Structure

```text
8-week-sql-challenge/
├── README.md
└── week-01-customer-analytics/
    ├── README.md
    ├── 01_data_profiling.sql
    └── 02_customer_analysis.sql
```

## 🚀 Next Steps

- [ ] Refine cancellation and return handling.
- [ ] Validate customer revenue calculations against transaction-level records.
- [ ] Continue to Week 2: a new business case and additional SQL techniques.

---

*Part of an original, self-directed 8-week SQL portfolio challenge using Microsoft SQL Server and real-world datasets.*
