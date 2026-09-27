# Incremental Load

Incremental order data was loaded into a staging table and then merged into the target table using `MERGE INTO`.

## Workflow

1. Load the incremental CSV into `meridian.orders_stg`.
2. Match staging rows to target rows using `order_id`.
3. Update existing orders when a matching `order_id` exists.
4. Insert new orders when no match exists.
5. Truncate the staging table after the merge.

## Merge result

The incremental batch contained three rows:

- `10003` — existing order, updated
- `10013` — new order, inserted
- `10014` — new order, inserted

The MERGE statement reported:

```text
OUTPUT 3
```

After the merge, the target table contained 13 orders.

Order `10003` was updated from its original values to:

- discount: `35.00`
- status: `COMPLETED`
- updated_at: `2025-09-25 08:00:00`

The staging table was then truncated and verified to contain zero rows.
