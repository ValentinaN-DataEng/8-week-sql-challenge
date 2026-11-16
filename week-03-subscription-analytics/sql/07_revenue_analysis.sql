
/*
Purpose: Analyze simulated subscription revenue.
*/

USE StreamFlow;
GO

-- 1. Revenue by plan and billing frequency
SELECT
    pl.plan_name,
    p.billing_frequency,
    COUNT(*) AS payment_count,
    COUNT(DISTINCT p.subscription_id) AS subscriptions_with_payments,
    SUM(p.amount) AS total_revenue,
    AVG(p.amount) AS average_payment
FROM dbo.Payments p
JOIN dbo.Plans pl
    ON p.plan_id = pl.plan_id
GROUP BY
    pl.plan_name,
    p.billing_frequency
ORDER BY total_revenue DESC;


-- 2. Monthly revenue trend
SELECT
    YEAR(payment_date) AS payment_year,
    MONTH(payment_date) AS payment_month,
    COUNT(*) AS payment_count,
    SUM(amount) AS monthly_revenue
FROM dbo.Payments
GROUP BY
    YEAR(payment_date),
    MONTH(payment_date)
ORDER BY
    payment_year,
    payment_month;


-- 3. Overall revenue KPIs
SELECT
    COUNT(*) AS total_payments,
    COUNT(DISTINCT subscription_id) AS paying_subscriptions,
    SUM(amount) AS total_revenue,
    AVG(amount) AS average_payment,
    MIN(payment_date) AS first_payment_date,
    MAX(payment_date) AS last_payment_date
FROM dbo.Payments;
