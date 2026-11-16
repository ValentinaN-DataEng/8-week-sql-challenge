
/*
Project: StreamFlow - Subscription Analytics
File: 00_database_setup.sql
Purpose: Create the database and define the source tables.
Environment: Microsoft SQL Server
*/

-- Create database
CREATE DATABASE StreamFlow;
GO

USE StreamFlow;
GO

-- =============================================
-- 1. CUSTOMERS
-- =============================================

CREATE TABLE dbo.Customers (
    customer_id INT NOT NULL,
    registration_date DATE NOT NULL,
    country VARCHAR(50) NOT NULL,

    CONSTRAINT PK_Customers
        PRIMARY KEY (customer_id)
);
GO


-- =============================================
-- 2. PLANS
-- =============================================

CREATE TABLE dbo.Plans (
    plan_id INT NOT NULL,
    plan_name VARCHAR(30) NOT NULL,
    billing_frequency VARCHAR(20) NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_Plans
        PRIMARY KEY (plan_id),

    CONSTRAINT CK_Plans_Price
        CHECK (price >= 0)
);
GO


-- =============================================
-- 3. SUBSCRIPTIONS
-- =============================================

CREATE TABLE dbo.Subscriptions (
    subscription_id INT NOT NULL,
    customer_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,

    CONSTRAINT PK_Subscriptions
        PRIMARY KEY (subscription_id),

    CONSTRAINT FK_Subscriptions_Customers
        FOREIGN KEY (customer_id)
        REFERENCES dbo.Customers(customer_id),

    CONSTRAINT CK_Subscriptions_Dates
        CHECK (end_date IS NULL OR end_date >= start_date)
);
GO


-- =============================================
-- 4. SUBSCRIPTION EVENTS
-- =============================================

CREATE TABLE dbo.Subscription_Events (
    event_id INT NOT NULL,
    subscription_id INT NOT NULL,
    plan_id INT NOT NULL,
    event_type VARCHAR(30) NOT NULL,
    event_date DATE NOT NULL,

    CONSTRAINT PK_Subscription_Events
        PRIMARY KEY (event_id),

    CONSTRAINT FK_Events_Subscriptions
        FOREIGN KEY (subscription_id)
        REFERENCES dbo.Subscriptions(subscription_id),

    CONSTRAINT FK_Events_Plans
        FOREIGN KEY (plan_id)
        REFERENCES dbo.Plans(plan_id)
);
GO

