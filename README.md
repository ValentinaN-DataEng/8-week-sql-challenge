# 🧠 8-Week SQL Challenge

> An original, business-driven SQL portfolio exploring real-world datasets through data analysis, problem-solving, and actionable insights.

[![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-CC2927?logo=microsoftsqlserver&logoColor=white)](https://learn.microsoft.com/en-us/sql/sql-server/)
![Case Studies](https://img.shields.io/badge/Case%20Studies-8-blue)
![Progress](https://img.shields.io/badge/Progress-1%2F8%20Weeks-orange)

Welcome! This repository documents my **8-week SQL learning challenge**, in which I solve original business cases using Microsoft SQL Server and real-world datasets.

Rather than focusing only on SQL syntax, each case study follows an analytical workflow: understanding the business problem, profiling the data, writing queries, validating results, and communicating findings.

## 🎯 Challenge Objectives

- Strengthen SQL skills through practical business questions.
- Practice data cleaning, transformation, aggregation, and analysis.
- Develop the ability to translate query results into business insights.
- Build a portfolio demonstrating analytical thinking and technical skills.
- Progress from foundational SQL techniques toward more advanced analysis.

## 🗺️ Challenge Roadmap

| Week | Case Study | Focus Areas | Status |
|---|---|---|---|
| [01](./week-01-customer-analytics/) | Customer Analytics | Data profiling, customer revenue, purchasing behavior | ✅ Completed |
| 02 | To be announced | Filtering, aggregations, and business metrics | 🔜 Planned |
| 03 | To be announced | Joins and relational analysis | 🔜 Planned |
| 04 | To be announced | CTEs, subqueries, and analytical logic | 🔜 Planned |
| 05 | To be announced | Window functions and ranking | 🔜 Planned |
| 06 | To be announced | Customer segmentation and performance analysis | 🔜 Planned |
| 07 | To be announced | Advanced analytical case study | 🔜 Planned |
| 08 | To be announced | Capstone analysis and business recommendations | 🔜 Planned |

*The roadmap is provisional. Each upcoming case study will be defined around its business scenario and dataset.*

## 🔍 Featured Case Study

### Week 1 — Customer Analytics

**Business question:** Which customers contribute the most transaction value, and what can purchasing behavior tell us about customer value?

Using the [UCI Online Retail dataset](https://archive.ics.uci.edu/dataset/352/online+retail), I explored transaction quality, customer-level revenue, purchasing quantities, and invoice counts.

**Key activities:**
- Profiled 541,909 raw transaction rows.
- Validated data conversions for quantities, prices, and dates.
- Compared positive-quantity transaction value with net transaction value.
- Ranked customers by net transaction value.
- Examined purchasing frequency and revenue-per-net-unit metrics.

📂 **[Explore Week 1 — Customer Analytics](./week-01-customer-analytics/)**

Inside the case study, you'll find the SQL scripts, business questions, methodology, findings, and data-quality limitations.

## 🛠️ Tools & Techniques

**Database:** Microsoft SQL Server

**SQL techniques practiced:**
- `SELECT`, `WHERE`, `ORDER BY`, and `TOP`
- `CASE WHEN` and conditional aggregation
- `GROUP BY`, `SUM`, `AVG`, and `COUNT(DISTINCT)`
- Common Table Expressions (CTEs)
- Data type conversion with `TRY_CAST` and `TRY_CONVERT`
- Data quality checks and handling missing values
- Calculated metrics and percentage comparisons

Additional SQL techniques and tools will be introduced as the challenge progresses.

## 📈 My Analytical Workflow

Each case study follows a consistent process:

1. **Understand** — Define the business scenario and analytical questions.
2. **Profile** — Inspect the dataset, identify missing values, and validate data types.
3. **Analyze** — Write SQL queries to calculate relevant metrics.
4. **Validate** — Check assumptions, conversion failures, and limitations.
5. **Interpret** — Translate results into evidence-based business findings.
6. **Document** — Publish reproducible SQL scripts and a case-study README.

## 📁 Repository Structure

```text
8-week-sql-challenge/
├── README.md
├── week-01-customer-analytics/
│   ├── README.md
│   ├── 01_data_profiling.sql
│   └── 02_customer_analysis.sql
├── week-02/
├── week-03/
├── week-04/
├── week-05/
├── week-06/
├── week-07/
└── week-08/
```

Future week folders will be added as their case studies are completed.

## 👩‍💻 About This Project

This is an original, self-directed SQL portfolio challenge created to strengthen my practical data analytics skills. The case studies use business-oriented questions and publicly available datasets wherever appropriate.

The project is inspired by the broader practice of SQL case-study challenges, but its scenarios, queries, and analytical work are developed independently.

---

**Thanks for visiting!** Explore the case studies and follow the repository as the challenge progresses.
