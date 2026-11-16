/*
Purpose: Analyze trial conversion and subscription churn.
*/

USE StreamFlow;
GO

-- 1. Trial-to-paid conversion
WITH TrialSubscriptions AS (
    SELECT
        COUNT(DISTINCT subscription_id) AS total_trials
    FROM dbo.Subscription_Events
    WHERE event_type = 'TRIAL_STARTED'
),
ConvertedSubscriptions AS (
    SELECT
        COUNT(DISTINCT subscription_id) AS converted_trials
    FROM dbo.Subscription_Events
    WHERE event_type = 'PLAN_ACTIVATED'
)
SELECT
    t.total_trials,
    c.converted_trials,
    CAST(
        100.0 * c.converted_trials
        / NULLIF(t.total_trials, 0)
        AS DECIMAL(5,2)
    ) AS conversion_rate
FROM TrialSubscriptions t
CROSS JOIN ConvertedSubscriptions c;


-- 2. Subscription churn
SELECT
    COUNT(*) AS total_subscriptions,
    SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END)
        AS ended_subscriptions,
    CAST(
        100.0 * SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END)
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS churn_rate
FROM dbo.Subscriptions;


-- 3. Investigate trial expiration and cancellation events
SELECT
    event_type,
    COUNT(*) AS total_events,
    COUNT(DISTINCT subscription_id) AS affected_subscriptions
FROM dbo.Subscription_Events
WHERE event_type IN ('TRIAL_EXPIRED', 'CANCELLED')
GROUP BY event_type;


-- 4. Check subscriptions with both events
SELECT
    t.subscription_id
FROM dbo.Subscription_Events t
JOIN dbo.Subscription_Events c
    ON t.subscription_id = c.subscription_id
WHERE t.event_type = 'TRIAL_EXPIRED'
  AND c.event_type = 'CANCELLED'
  AND c.event_date >= t.event_date
  AND c.event_date <= DATEADD(DAY, 7, t.event_date)
GROUP BY t.subscription_id;
