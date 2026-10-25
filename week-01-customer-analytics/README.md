# Week 1 — Customer Analytics

## Business Objective

Analyze customer purchasing behavior using the UCI Online Retail dataset to identify high-value customers and understand transaction patterns.

## Dataset

- **Source:** [UCI Machine Learning Repository — Online Retail](https://archive.ics.uci.edu/dataset/352/online+retail)
- **Database:** SQL Server
- **Raw table:** `dbo.OnlineRetail_Raw`
- **Rows:** 541,909

## Analysis

1. Data profiling and quality validation.
2. Customer-level net quantity and transaction value.
3. Gross versus net transaction value.
4. Customer revenue, invoice counts, and purchasing behavior.

## SQL Scripts

- `01_data_profiling.sql` — data quality checks and type conversion validation.
- `02_customer_analysis.sql` — customer-level metrics and revenue analysis.

## Notes

Transaction values are calculated as quantity multiplied by unit price. Negative quantities are retained in net transaction calculations. Invoice counts currently include cancellation invoices, and gross-versus-net differences should not be interpreted as returns alone without further validation.

## Status

SQL analysis completed. Final repository documentation and script upload in progress.
