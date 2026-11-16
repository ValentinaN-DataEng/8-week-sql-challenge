/*
Purpose: Validate source tables and inspect data quality.
*/

USE StreamFlow;
GO

-- 1. Record counts
SELECT 'Customers' AS table_name, COUNT(*) AS total_records
FROM dbo.Customers
UNION ALL
SELECT 'Plans', COUNT(*) FROM dbo.Plans
UNION ALL
SELECT 'Subscriptions', COUNT(*) FROM dbo.Subscriptions
UNION ALL
SELECT 'Subscription_Events', COUNT(*) 
FROM dbo.Subscription_Events;


-- 2. Check duplicate customer IDs
SELECT customer_id, COUNT(*) AS occurrences
FROM dbo.Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 3. Check NULL values in important fields
SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN registration_date IS NULL THEN 1 ELSE 0 END) AS null_registration_date,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_country
FROM dbo.Customers;


-- 4. Check invalid customer references
SELECT COUNT(*) AS invalid_customer_references
FROM dbo.Subscriptions s
LEFT JOIN dbo.Customers c
    ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- 5. Check invalid subscription references
SELECT COUNT(*) AS invalid_subscription_references
FROM dbo.Subscription_Events e
LEFT JOIN dbo.Subscriptions s
    ON e.subscription_id = s.subscription_id
WHERE s.subscription_id IS NULL;
