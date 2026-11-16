/*
Purpose: Analyze customer lifecycle and retention.
*/

USE StreamFlow;
GO

-- 1. Customers with multiple subscription lifecycles
WITH CustomerLifecycles AS (
    SELECT
        customer_id,
        COUNT(*) AS total_lifecycles
    FROM dbo.Subscriptions
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS customers_with_multiple_lifecycles
FROM CustomerLifecycles
WHERE total_lifecycles > 1;


-- 2. Percentage of customers with multiple lifecycles
WITH CustomerLifecycles AS (
    SELECT
        customer_id,
        COUNT(*) AS total_lifecycles
    FROM dbo.Subscriptions
    GROUP BY customer_id
)
SELECT
    COUNT(CASE WHEN total_lifecycles > 1 THEN 1 END)
        AS customers_with_multiple_lifecycles,
    COUNT(*) AS total_customers_with_subscriptions,
    CAST(
        100.0 * COUNT(CASE WHEN total_lifecycles > 1 THEN 1 END)
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS percentage_multiple_lifecycles
FROM CustomerLifecycles;


-- 3. 90-day subscription lifecycle retention
DECLARE @CutoffDate DATE = '2025-12-31';

WITH EligibleSubscriptions AS (
    SELECT
        subscription_id,
        start_date,
        end_date,
        DATEADD(DAY, 90, start_date) AS day_90
    FROM dbo.Subscriptions
    WHERE start_date <= DATEADD(DAY, -90, @CutoffDate)
),
RetentionResults AS (
    SELECT
        subscription_id,
        CASE
            WHEN end_date IS NULL OR end_date >= day_90
                THEN 1
            ELSE 0
        END AS retained_after_90_days
    FROM EligibleSubscriptions
)
SELECT
    COUNT(*) AS eligible_subscriptions,
    SUM(retained_after_90_days) AS retained_subscriptions,
    CAST(
        100.0 * SUM(retained_after_90_days) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS retention_rate_90_days
FROM RetentionResults;
