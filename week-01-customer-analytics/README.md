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
- [Future Improvements](#-future-improvements)

---

## 🎯 Business Scenario

An online retailer wants to better understand its customers and identify purchasing behaviors associated with higher customer value.

The retailer has transaction-level data, but raw transactions alone do not reveal which customers contribute the most transaction value, how negative transactions affect totals, or whether purchasing frequency is associated with customer value.

**Mission:** Transform raw retail transactions into customer-level metrics and evidence-based business insights using SQL.

## 🗂️ Dataset Overview

| Attribute | Details |
|---|---|
| Dataset | Online Retail |
| Source | [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/352/online+retail) |
| Raw records | 541,909 rows |
| Database | Microsoft SQL Server |
| Raw table | `dbo.OnlineRetail_Raw` |
| SQL dialect | T-SQL |

The dataset contains retail transaction information, including invoice numbers, product codes and descriptions, quantities, unit prices, invoice dates, customer IDs, and countries.

The raw data was imported into SQL Server with the source columns stored as text. Numeric and date conversions were applied within the analysis queries, leaving the raw table unchanged.

## 🔎 Business Questions

Expand each section to explore the analytical questions addressed in this case study.

<details>
<summary><strong>01 — Data Profiling and Quality</strong></summary>

**Business objective:** Assess data completeness and conversion reliability before performing customer analysis.

Questions investigated:

- Which columns contain missing or blank values?
- How many invoice rows have invoice numbers beginning with `C`?
- How many rows have negative or zero quantities?
- Which raw columns require type conversion?
- Can quantities, unit prices, and invoice dates be converted successfully?

**SQL file:** [`01_data_profiling.sql`](01_data_profiling.sql)

</details>

<details>
<summary><strong>02 — Highest-Value Customers</strong></summary>

**Business objective:** Identify customers with the highest calculated net transaction value.

Questions investigated:

- How many distinct, identifiable customers are present?
- Which ten customers rank highest by net transaction value?
- How do their net quantities compare?

**SQL file:** [`02_customer_analysis.sql`](02_customer_analysis.sql)

</details>

<details>
<summary><strong>03 — Gross vs. Net Transaction Value</strong></summary>

**Business objective:** Quantify the difference between positive-quantity transaction value and transaction value calculated using signed quantities.

Questions investigated:

- What is the transaction value from rows with positive quantities?
- What is the transaction value when positive and negative quantities are included?
- What is the difference between these measures?
- What percentage of the positive-quantity transaction value does this difference represent?

**SQL file:** [`02_customer_analysis.sql`](02_customer_analysis.sql)

</details>

<details>
<summary><strong>04 — Customer Purchasing Behavior</strong></summary>

**Business objective:** Compare the purchasing patterns of customers with high calculated net transaction value.

Metrics calculated:

- Total net quantity
- Total net transaction value
- Average unit price across transaction rows
- Revenue per net unit
- Distinct invoice count, including cancellation invoices
- Average net transaction value per distinct invoice number

**SQL file:** [`02_customer_analysis.sql`](02_customer_analysis.sql)

</details>

## 💻 SQL Solutions

The analysis is organized into two SQL scripts:

| File | Purpose |
|---|---|
| [`01_data_profiling.sql`](01_data_profiling.sql) | Data profiling, missing-value checks, conversion diagnostics, and final conversion validation |
| [`02_customer_analysis.sql`](02_customer_analysis.sql) | Customer-level aggregation, revenue metrics, invoice counts, and purchasing behavior |

The project applies SQL Server techniques including:

- `CASE WHEN` and conditional aggregation
- `SUM`, `AVG`, and `COUNT(DISTINCT)`
- `GROUP BY` and `ORDER BY`
- Common Table Expressions (CTEs)
- `TRY_CAST` and `TRY_CONVERT`
- `REPLACE`, `TRIM`, and `NULLIF`
- `TOP` and calculated metrics

## 📊 Key Findings

The findings below are based on the query results obtained during this case study. Customer-level comparisons refer to the ten highest-revenue customers returned by the analysis unless otherwise stated.

### 1. Customer value and purchasing frequency

Customer **14646** ranked first in both calculated net transaction value and distinct invoice count among the ten highest-revenue customers examined.

This suggests an association between purchasing frequency and customer value within this group. However, further analysis would be needed to distinguish the contributions of order frequency, order size, and product mix.

**Limitation:** The invoice count includes cancellation invoices, so it is not a count of completed orders.

### 2. Revenue per net unit

Customer **18102** had a revenue-per-net-unit ratio of **3.99**, the highest among the top three customers examined.

This illustrates that the customer with the highest total transaction value does not necessarily have the highest revenue-per-net-unit ratio.

Revenue per net unit is calculated as net transaction value divided by net quantity. It is an exploratory ratio, not necessarily the average selling price of an item. Returns, negative quantities, and product mix can affect its interpretation.

### 3. Gross vs. net transaction value

The analysis produced the following results:

| Metric | Result |
|---|---:|
| Positive-quantity transaction value | 1,064,456.42 |
| Net transaction value | 974,747.93 |
| Difference | 89,708.49 |
| Difference as a percentage of positive-quantity transaction value | 8.43% |

Under the definitions used in this analysis, the net transaction value was approximately **8.43% lower** than the transaction value calculated from positive-quantity rows.

The difference reflects the impact of including negative transaction values in the net calculation. It should not be attributed to returns alone because cancellation invoices and other negative-quantity transactions have not yet been separately isolated and reconciled.

The values are presented in the dataset's monetary units; the analysis does not independently verify the currency or accounting treatment.

## 🧹 Data Quality and Limitations

### Conversion validation

The final conversion checks returned zero failed conversions among nonblank values for:

| Column | Failed conversions |
|---|---:|
| `Quantity` | 0 |
| `UnitPrice` | 0 |
| `InvoiceDate` | 0 |

The conversions used SQL Server's `TRY_CAST` and `TRY_CONVERT`, including decimal-comma normalization for unit prices and date style `103` for the `DD/MM/YYYY` date format.

These results confirm that the tested nonblank values converted successfully. They do not establish that every value is complete or semantically valid.

### Remaining limitations

- Customer IDs and product descriptions contain missing or blank values.
- Negative quantities and cancellation invoice rows require separate analysis.
- Distinct invoice counts include cancellation invoices and should not be interpreted as completed-order counts.
- Average net transaction value per invoice is an exploratory ratio, not a definitive average order value.
- Revenue per net unit can be distorted by returns, negative quantities, and product mix.
- Transaction value is calculated as `Quantity × UnitPrice`. Discounts, shipping charges, taxes, refunds, and other accounting adjustments have not been independently reconciled.
- `SUM` ignores `NULL` expressions. Although conversion failures were checked, missing values and their effect on individual metrics must still be considered.
- The analysis uses the raw table without modifying it.

## 🧠 Skills Practiced

- Data profiling and quality validation
- Data type conversion and error handling
- Conditional aggregation using `CASE WHEN`
- Customer-level aggregation with `GROUP BY`
- Common Table Expressions (CTEs)
- Distinct counts and customer ranking
- Transaction-value calculations
- Gross-versus-net comparisons
- Percentage calculations and decimal arithmetic
- Interpreting results and documenting analytical limitations

## 🗃️ Project Structure

```text
8-week-sql-challenge/
├── README.md
└── week-01-customer-analytics/
    ├── README.md
    ├── 01_data_profiling.sql
    └── 02_customer_analysis.sql
```

The root README provides the roadmap for the full eight-week challenge. Each weekly folder contains its own case-study documentation and SQL scripts.

## 🚀 Future Improvements

The core Week 1 analysis is complete. Potential extensions include:

- [ ] Separate cancellation invoices from other negative-quantity transactions.
- [ ] Reconcile returns and cancellations with their original transactions.
- [ ] Validate customer-level metrics against transaction-level records.
- [ ] Refine order-count and average-revenue-per-order definitions.
- [ ] Continue to Week 2 with a new business case and additional SQL techniques.

---

*Part of an original, self-directed eight-week SQL portfolio challenge using Microsoft SQL Server and real-world datasets.*
