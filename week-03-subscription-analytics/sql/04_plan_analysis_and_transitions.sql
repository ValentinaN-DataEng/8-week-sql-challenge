
/*
Purpose: Analyze plan performance and subscription transitions.
*/

USE StreamFlow;
GO

-- 1. Subscription events by plan
SELECT
    p.plan_name,
    p.billing_frequency,
    COUNT(*) AS total_events
FROM dbo.Subscription_Events e
JOIN dbo.Plans p
    ON e.plan_id = p.plan_id
GROUP BY
    p.plan_name,
    p.billing_frequency
ORDER BY total_events DESC;


-- 2. Active subscription distribution at cutoff
DECLARE @CutoffDate DATE = '2025-12-31';

WITH ActiveSubscriptions AS (
    SELECT subscription_id
    FROM dbo.Subscriptions
    WHERE start_date <= @CutoffDate
      AND (end_date IS NULL OR end_date >= @CutoffDate)
),
LatestPlan AS (
    SELECT
        e.subscription_id,
        e.plan_id,
        ROW_NUMBER() OVER (
            PARTITION BY e.subscription_id
            ORDER BY e.event_date DESC, e.event_id DESC
        ) AS rn
    FROM dbo.Subscription_Events e
    JOIN ActiveSubscriptions a
        ON e.subscription_id = a.subscription_id
)
SELECT
    p.plan_name,
    p.billing_frequency,
    COUNT(*) AS active_subscriptions
FROM LatestPlan lp
JOIN dbo.Plans p
    ON lp.plan_id = p.plan_id
WHERE lp.rn = 1
GROUP BY p.plan_name, p.billing_frequency
ORDER BY active_subscriptions DESC;


-- 3. Monthly-to-annual billing transitions
WITH BillingHistory AS (
    SELECT
        e.subscription_id,
        e.event_type,
        e.event_date,
        p.billing_frequency,
        LAG(p.billing_frequency) OVER (
            PARTITION BY e.subscription_id
            ORDER BY e.event_date, e.event_id
        ) AS previous_frequency
    FROM dbo.Subscription_Events e
    JOIN dbo.Plans p
        ON e.plan_id = p.plan_id
)
SELECT
    COUNT(*) AS monthly_to_annual_transitions,
    COUNT(DISTINCT subscription_id) AS affected_subscriptions
FROM BillingHistory
WHERE event_type = 'BILLING_CHANGED'
  AND previous_frequency = 'Monthly'
  AND billing_frequency = 'Annual';


-- 4. Plan downgrades
WITH PlanHistory AS (
    SELECT
        e.subscription_id,
        e.event_type,
        e.event_date,
        p.price,
        p.billing_frequency,
        LAG(p.price) OVER (
            PARTITION BY e.subscription_id
            ORDER BY e.event_date, e.event_id
        ) AS previous_price,
        LAG(p.billing_frequency) OVER (
            PARTITION BY e.subscription_id
            ORDER BY e.event_date, e.event_id
        ) AS previous_frequency
    FROM dbo.Subscription_Events e
    JOIN dbo.Plans p
        ON e.plan_id = p.plan_id
)
SELECT
    COUNT(*) AS downgrade_events,
    COUNT(DISTINCT subscription_id) AS affected_subscriptions
FROM PlanHistory
WHERE event_type = 'PLAN_CHANGED'
  AND previous_price > price
  AND previous_frequency = billing_frequency;


-- 5. Time between previous event and monthly-to-annual transition
WITH BillingHistory AS (
    SELECT
        e.subscription_id,
        e.event_type,
        e.event_date,
        p.billing_frequency,
        LAG(p.billing_frequency) OVER (
            PARTITION BY e.subscription_id
            ORDER BY e.event_date, e.event_id
        ) AS previous_frequency,
        LAG(e.event_date) OVER (
            PARTITION BY e.subscription_id
            ORDER BY e.event_date, e.event_id
        ) AS previous_event_date
    FROM dbo.Subscription_Events e
    JOIN dbo.Plans p
        ON e.plan_id = p.plan_id
),
UpgradeIntervals AS (
    SELECT
        DATEDIFF(DAY, previous_event_date, event_date) AS days_to_upgrade
    FROM BillingHistory
    WHERE event_type = 'BILLING_CHANGED'
      AND previous_frequency = 'Monthly'
      AND billing_frequency = 'Annual'
)
SELECT
    COUNT(*) AS upgrade_events,
    AVG(CAST(days_to_upgrade AS DECIMAL(10,2))) AS average_days,
    MIN(days_to_upgrade) AS minimum_days,
    MAX(days_to_upgrade) AS maximum_days
FROM UpgradeIntervals;
