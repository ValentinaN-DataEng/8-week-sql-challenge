
/*
Purpose: Generate simulated subscription payments.
*/

USE StreamFlow;
GO

-- 1. Create payment table
CREATE TABLE dbo.Payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    subscription_id INT NOT NULL,
    customer_id INT NOT NULL,
    plan_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    billing_frequency VARCHAR(20) NOT NULL,

    CONSTRAINT FK_Payments_Subscriptions
        FOREIGN KEY (subscription_id)
        REFERENCES dbo.Subscriptions(subscription_id),

    CONSTRAINT FK_Payments_Customers
        FOREIGN KEY (customer_id)
        REFERENCES dbo.Customers(customer_id),

    CONSTRAINT FK_Payments_Plans
        FOREIGN KEY (plan_id)
        REFERENCES dbo.Plans(plan_id),

    CONSTRAINT CK_Payments_Amount
        CHECK (amount >= 0)
);
GO
