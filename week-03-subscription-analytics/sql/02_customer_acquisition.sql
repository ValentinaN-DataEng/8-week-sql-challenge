/*
Purpose: Analyze customer acquisition.
*/

USE StreamFlow;
GO

-- 1. Total registered customers
SELECT COUNT(*) AS total_customers
FROM dbo.Customers;


-- 2. Monthly customer acquisition
SELECT
    FORMAT(registration_date, 'yyyy-MM') AS acquisition_month,
    COUNT(*) AS new_customers
FROM dbo.Customers
GROUP BY FORMAT(registration_date, 'yyyy-MM')
ORDER BY acquisition_month;


-- 3. January 2025 cohort conversion
SELECT
    COUNT(DISTINCT c.customer_id) AS registered_customers,
    COUNT(DISTINCT s.customer_id) AS converted_customers,
    CAST(
        100.0 * COUNT(DISTINCT s.customer_id)
        / NULLIF(COUNT(DISTINCT c.customer_id), 0)
        AS DECIMAL(5,2)
    ) AS observed_conversion_rate
FROM dbo.Customers c
LEFT JOIN dbo.Subscriptions s
    ON c.customer_id = s.customer_id
WHERE c.registration_date >= '2025-01-01'
  AND c.registration_date < '2025-02-01';
