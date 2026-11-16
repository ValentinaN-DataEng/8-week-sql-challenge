
import pandas as pd
import random
from pathlib import Path
from datetime import date, timedelta

def random_date(start_date, end_date):
    days = (end_date - start_date).days
    return start_date + timedelta(days=random.randint(0, days))

# Reproducibility
random.seed(42)

# Project directories
BASE_DIR = Path(__file__).resolve().parents[1]
DATASET_DIR = BASE_DIR / "dataset"

DATASET_DIR.mkdir(parents=True, exist_ok=True)

# Subscription plans
plans = [
    {"plan_id": 0, "plan_name": "Free Trial", "billing_frequency": "Trial", "price": 0.00},
    {"plan_id": 1, "plan_name": "Basic", "billing_frequency": "Monthly", "price": 8.99},
    {"plan_id": 2, "plan_name": "Basic", "billing_frequency": "Annual", "price": 89.99},
    {"plan_id": 3, "plan_name": "Premium", "billing_frequency": "Monthly", "price": 12.99},
    {"plan_id": 4, "plan_name": "Premium", "billing_frequency": "Annual", "price": 119.99},
    {"plan_id": 5, "plan_name": "Family", "billing_frequency": "Monthly", "price": 19.99},
    {"plan_id": 6, "plan_name": "Family", "billing_frequency": "Annual", "price": 179.99}
]

plans_df = pd.DataFrame(plans)

# Export
plans_df.to_csv(DATASET_DIR / "plans.csv", index=False)

print("Plans dataset generated successfully!")
print(plans_df)


# ---------------------------------------
# CUSTOMERS DATASET
# ---------------------------------------

# Customer generation parameters
NUM_CUSTOMERS = 1000
START_DATE = date(2024, 1, 1)
END_DATE = date(2025, 12, 31)

# Country distribution
countries = [
    "Colombia",
    "United States",
    "Mexico",
    "Spain",
    "Brazil",
    "Canada"
]

country_weights = [35, 25, 15, 10, 8, 7]

# Calculate the number of days in the registration period
date_range = (END_DATE - START_DATE).days

customers = []

for customer_id in range(1001, 1001 + NUM_CUSTOMERS):

    # Generate a random registration date
    random_days = random.randint(0, date_range)
    registration_date = START_DATE + timedelta(days=random_days)

    # Assign a country using weighted probabilities
    country = random.choices(
        countries,
        weights=country_weights,
        k=1
    )[0]

    customers.append({
        "customer_id": customer_id,
        "registration_date": registration_date,
        "country": country
    })

# Convert to DataFrame
customers_df = pd.DataFrame(customers)

# Export CSV
customers_df.to_csv(
    DATASET_DIR / "customers.csv",
    index=False
)

print("\nCustomers dataset generated successfully!")
print(customers_df.head())
print(f"Total customers: {len(customers_df)}")


# ---------------------------------------
# SUBSCRIPTIONS DATASET
# ---------------------------------------

OBSERVATION_END = date(2025, 12, 31)

subscriptions = []
subscription_id = 5001

for customer in customers:

    customer_id = customer["customer_id"]
    registration_date = customer["registration_date"]

    # Every customer starts with one subscription lifecycle
    first_start = registration_date
    first_end = None

    # Determine whether the customer returns after cancellation
    can_return = (
        first_start <= OBSERVATION_END - timedelta(days=90)
    )

    will_return = can_return and random.random() < 0.15

    if will_return:

        # First lifecycle ends before the observation cutoff
        first_end = random_date(
            first_start + timedelta(days=30),
            OBSERVATION_END - timedelta(days=30)
        )

    else:
        # Some customers cancel without returning
        can_cancel = (
            first_start <= OBSERVATION_END - timedelta(days=30)
        )

        will_cancel = can_cancel and random.random() < 0.25

        if will_cancel:
            if random.random() < 0.15:
                # Trial expires without conversion
                first_end = first_start + timedelta(days=14)
            else:
                # Paid subscription is cancelled
                first_end = random_date(
                    first_start + timedelta(days=30),
                    OBSERVATION_END
                )

    subscriptions.append({
        "subscription_id": subscription_id,
        "customer_id": customer_id,
        "start_date": first_start,
        "end_date": first_end
    })

    subscription_id += 1

    # Create a new lifecycle for returning customers
    if will_return:

        remaining_days = (OBSERVATION_END - first_end).days

        second_start = first_end + timedelta(
            days=random.randint(15, min(90, remaining_days))
        )

        second_end = None

        # Some returning customers cancel again
        can_cancel_again = (
            second_start <= OBSERVATION_END - timedelta(days=30)
        )

        if can_cancel_again and random.random() < 0.20:
            second_end = random_date(
                second_start + timedelta(days=30),
                OBSERVATION_END
            )

        subscriptions.append({
            "subscription_id": subscription_id,
            "customer_id": customer_id,
            "start_date": second_start,
            "end_date": second_end
        })

        subscription_id += 1


# Convert to DataFrame
subscriptions_df = pd.DataFrame(subscriptions)

# Export CSV
subscriptions_df.to_csv(
    DATASET_DIR / "subscriptions.csv",
    index=False
)

print("\nSubscriptions dataset generated successfully!")
print(subscriptions_df.head(10))
print(f"Total subscriptions: {len(subscriptions_df)}")
print(f"Unique customers: {subscriptions_df['customer_id'].nunique()}")


# Subscription data validation

print("\n--- SUBSCRIPTION VALIDATION ---")

print(
    "Invalid date ranges:",
    (subscriptions_df["end_date"].notna() &
     (subscriptions_df["end_date"] < subscriptions_df["start_date"])).sum()
)

print(
    "Subscriptions starting after cutoff:",
    (subscriptions_df["start_date"] > OBSERVATION_END).sum()
)

print(
    "Duplicate subscription IDs:",
    subscriptions_df["subscription_id"].duplicated().sum()
)

print(
    "Customers without subscriptions:",
    len(set(customers_df["customer_id"]) -
        set(subscriptions_df["customer_id"]))
)


# ---------------------------------------
# SUBSCRIPTION EVENTS DATASET
# ---------------------------------------

events = []
event_id = 1

# Create a lookup dictionary for plan information
plan_lookup = {
    plan["plan_id"]: plan for plan in plans
}

paid_plan_ids = [1, 2, 3, 4, 5, 6]

for subscription in subscriptions:

    sub_id = subscription["subscription_id"]
    start = subscription["start_date"]
    end = subscription["end_date"]

    # Event 1: Every lifecycle starts with a trial
    events.append({
        "event_id": event_id,
        "subscription_id": sub_id,
        "plan_id": 0,
        "event_type": "TRIAL_STARTED",
        "event_date": start
    })
    event_id += 1

    # Calculate trial expiration date
    trial_end = start + timedelta(days=14)

    # Case 1: Trial expires without conversion
    if end is not None and end <= trial_end:

        if end <= OBSERVATION_END:
            events.append({
                "event_id": event_id,
                "subscription_id": sub_id,
                "plan_id": 0,
                "event_type": "TRIAL_EXPIRED",
                "event_date": end
            })
            event_id += 1

        continue

    # Case 2: Trial converts to a paid subscription
    if trial_end > OBSERVATION_END:
        continue

    current_plan_id = random.choice(paid_plan_ids)

    events.append({
        "event_id": event_id,
        "subscription_id": sub_id,
        "plan_id": current_plan_id,
        "event_type": "PLAN_ACTIVATED",
        "event_date": trial_end
    })
    event_id += 1

    # Determine cancellation request date
    if end is not None:
        earliest_cancel = max(
            trial_end,
            end - timedelta(days=30)
        )
        cancellation_date = random_date(earliest_cancel, end)
        latest_change_date = cancellation_date - timedelta(days=1)
    else:
        cancellation_date = None
        latest_change_date = OBSERVATION_END

    # Generate optional plan changes
    number_of_changes = random.choices(
        [0, 1, 2],
        weights=[65, 25, 10],
        k=1
    )[0]

    last_change_date = trial_end

    for _ in range(number_of_changes):

        earliest_change = last_change_date + timedelta(days=30)

        if earliest_change > latest_change_date:
            break

        change_date = random_date(
            earliest_change,
            latest_change_date
        )

        current_plan = plan_lookup[current_plan_id]

        change_type = random.choice([
            "PLAN_CHANGED",
            "BILLING_CHANGED"
        ])

        if change_type == "PLAN_CHANGED":

            candidates = [
                p for p in plans
                if p["billing_frequency"] == current_plan["billing_frequency"]
                and p["plan_name"] != current_plan["plan_name"]
            ]

        else:

            candidates = [
                p for p in plans
                if p["plan_name"] == current_plan["plan_name"]
                and p["billing_frequency"] != current_plan["billing_frequency"]
            ]

        new_plan = random.choice(candidates)
        current_plan_id = new_plan["plan_id"]

        events.append({
            "event_id": event_id,
            "subscription_id": sub_id,
            "plan_id": current_plan_id,
            "event_type": change_type,
            "event_date": change_date
        })
        event_id += 1

        last_change_date = change_date

    # Final event: cancellation request
    if cancellation_date is not None:

        events.append({
            "event_id": event_id,
            "subscription_id": sub_id,
            "plan_id": current_plan_id,
            "event_type": "CANCELLED",
            "event_date": cancellation_date
        })
        event_id += 1


# Convert to DataFrame
events_df = pd.DataFrame(events)

# Sort events chronologically
events_df = events_df.sort_values(
    ["subscription_id", "event_date"]
).reset_index(drop=True)

# Export CSV
events_df.to_csv(
    DATASET_DIR / "subscription_events.csv",
    index=False
)

print("\nSubscription events generated successfully!")
print(events_df.head(15))
print(f"Total events: {len(events_df)}")
print(f"Unique subscriptions: {events_df['subscription_id'].nunique()}")


# ---------------------------------------
# EVENTS VALIDATION
# ---------------------------------------

print("\n--- EVENTS VALIDATION ---")

print(
    "Duplicate event IDs:",
    events_df["event_id"].duplicated().sum()
)

print(
    "Events with invalid subscription IDs:",
    (~events_df["subscription_id"].isin(
        subscriptions_df["subscription_id"]
    )).sum()
)

print(
    "Events with invalid plan IDs:",
    (~events_df["plan_id"].isin(
        plans_df["plan_id"]
    )).sum()
)

print(
    "Events after observation cutoff:",
    (events_df["event_date"] > OBSERVATION_END).sum()
)

trial_counts = (
    events_df[events_df["event_type"] == "TRIAL_STARTED"]
    .groupby("subscription_id")
    .size()
)

print(
    "Subscriptions without exactly one trial:",
    (trial_counts.reindex(
        subscriptions_df["subscription_id"],
        fill_value=0
    ) != 1).sum()
)


# ---------------------------------------
# FINAL DATASET AUDIT
# ---------------------------------------

print("\n========== FINAL DATASET AUDIT ==========")

# 1. Record counts
print("\n--- RECORD COUNTS ---")
print(f"Customers: {len(customers_df)}")
print(f"Plans: {len(plans_df)}")
print(f"Subscriptions: {len(subscriptions_df)}")
print(f"Events: {len(events_df)}")

# 2. Primary key validation
print("\n--- PRIMARY KEY VALIDATION ---")
print("Duplicate customers:", customers_df["customer_id"].duplicated().sum())
print("Duplicate plans:", plans_df["plan_id"].duplicated().sum())
print("Duplicate subscriptions:", subscriptions_df["subscription_id"].duplicated().sum())
print("Duplicate events:", events_df["event_id"].duplicated().sum())

# 3. Foreign key validation
print("\n--- FOREIGN KEY VALIDATION ---")
print("Invalid customer references:",
      (~subscriptions_df["customer_id"].isin(customers_df["customer_id"])).sum())

print("Invalid subscription references:",
      (~events_df["subscription_id"].isin(subscriptions_df["subscription_id"])).sum())

print("Invalid plan references:",
      (~events_df["plan_id"].isin(plans_df["plan_id"])).sum())

# 4. Chronological validation
print("\n--- CHRONOLOGICAL VALIDATION ---")

merged = events_df.merge(
    subscriptions_df[["subscription_id", "start_date", "end_date"]],
    on="subscription_id",
    how="left"
)

print("Events before subscription start:",
      (merged["event_date"] < merged["start_date"]).sum())

print("Events after subscription end:",
      (merged["end_date"].notna() &
       (merged["event_date"] > merged["end_date"])).sum())

# 5. Final file verification
print("\n--- FILE VERIFICATION ---")

for filename in [
    "customers.csv",
    "plans.csv",
    "subscriptions.csv",
    "subscription_events.csv"
]:
    print(filename, ":", (DATASET_DIR / filename).exists())

print("\n========== AUDIT COMPLETED ==========")
