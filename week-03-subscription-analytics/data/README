# Dataset Documentation — StreamFlow

## Data Source

All datasets used in this project are synthetically generated using Python and pandas.

The data simulates customer registrations, subscription lifecycles, subscription plans, and subscription events for a fictional digital audio streaming company.

No real customer information is used.

## Dataset Files

| File | Description |
|---|---|
| Customers.csv | Customer registration dates and countries |
| Plans.csv | Subscription plans, billing frequencies, and prices |
| Subscriptions.csv | Customer subscription lifecycles and dates |
| Subscription_Events.csv | Trial, activation, plan change, billing change, and cancellation events |

## Dataset Volume

| Dataset | Records |
|---|---:|
| Customers | 1,000 |
| Plans | 7 |
| Subscriptions | 1,150 |
| Subscription_Events | 3,000 |

## Generation

The datasets are generated using the Python script:

`python/generate_data.py`

The script uses pandas to generate the synthetic records and export them as CSV files.

## Business Rules

- Every subscription lifecycle begins with a 14-day free trial.
- Customers may have multiple subscription lifecycles.
- Each reactivation creates a new subscription ID.
- Plan and billing-frequency changes are represented as subscription events.
- A NULL subscription end date indicates an ongoing subscription.

## Observation Period

January 2024 – December 2025.

Observation cutoff: December 31, 2025.

Currency: USD.
