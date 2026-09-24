# Vertica Day 2 — Segmentation, Co-located Joins & MERGE

## Objective

Day 2 focuses on Vertica table segmentation, co-located joins, query-plan inspection with `EXPLAIN`, and incremental loading with `MERGE`.

## Topics Covered

* Table segmentation using `SEGMENTED BY HASH(...) ALL NODES`
* Staging-table pattern for incremental loads
* Co-located joins
* Using `EXPLAIN` to inspect join plans
* Verifying projection segmentation with `EXPORT_OBJECTS`
* `MERGE` with `WHEN MATCHED` and `WHEN NOT MATCHED`
* Validating updates and inserts from one `MERGE` operation

## Table Design

Both target and staging tables were created using:

```sql
SEGMENTED BY HASH(customer_id) ALL NODES
```

Using the same segmentation key means rows with the same `customer_id` can be assigned to the same node in a multi-node Vertica cluster.

This supports co-located joins because matching rows can be processed locally when related tables use compatible segmentation.

## Tables

### Target Table

`customer_target` initially contained:

| customer_id | customer_name | city      |
| ----------: | ------------- | --------- |
|           1 | Alice         | Hyderabad |
|           2 | Bob           | Mumbai    |
|           3 | Carol         | Delhi     |

### Staging Table

The incremental batch contained:

| customer_id | customer_name | city      |
| ----------: | ------------- | --------- |
|           2 | Bob           | Pune      |
|           3 | Carol         | Bengaluru |
|           4 | David         | Chennai   |
|           5 | Eva           | Kolkata   |

The staging table contains both existing customer IDs and new customer IDs.

## MERGE

The `MERGE` operation matches staging rows with the target using:

```sql
ON t.customer_id = s.customer_id
```

Existing customer IDs use:

```sql
WHEN MATCHED THEN UPDATE
```

New customer IDs use:

```sql
WHEN NOT MATCHED THEN INSERT
```

### Result

* Customer IDs `2` and `3` were updated.
* Customer IDs `4` and `5` were inserted.
* The `MERGE` affected 4 rows.
* Target row count increased from 3 to 5.

Final target data:

| customer_id | customer_name | city      |
| ----------: | ------------- | --------- |
|           1 | Alice         | Hyderabad |
|           2 | Bob           | Pune      |
|           3 | Carol         | Bengaluru |
|           4 | David         | Chennai   |
|           5 | Eva           | Kolkata   |

This demonstrates how `MERGE` can handle both updates and inserts in a single incremental-load operation.

## EXPLAIN and Segmentation Verification

`EXPLAIN` was used to inspect the join between `customer_target` and `customer_stage`.

The physical projection definitions were also inspected using `EXPORT_OBJECTS`.

Both projections showed:

```sql
SEGMENTED BY hash(customer_id) ALL NODES
```

This verified that the target and staging tables were physically designed with the same segmentation key.

## Environment Limitation

The Vertica Docker environment used for this exercise contains only one Vertica node:

```text
v_demo_node0001
```

Because this is a single-node cluster, actual inter-node data redistribution cannot be observed in the `EXPLAIN` plan.

The segmentation design was still verified using `EXPORT_OBJECTS`.

In a multi-node Vertica cluster, using the same hash segmentation key on related tables can support co-located joins by keeping matching rows on the same node.

## SQL Files

| File                   | Purpose                                            |
| ---------------------- | -------------------------------------------------- |
| `01_create_tables.sql` | Creates segmented target and staging tables        |
| `02_load_data.sql`     | Loads initial target and staging data              |
| `03_merge.sql`         | Performs the incremental `MERGE`                   |
| `04_explain.sql`       | Inspects the join plan and projection segmentation |
| `05_validation.sql`    | Verifies the final `MERGE` results                 |

## Key Takeaways

1. Segmentation determines how Vertica distributes table data across nodes.
2. Using the same hash key on related tables can support co-located joins.
3. `EXPLAIN` helps inspect how Vertica plans a query.
4. `EXPORT_OBJECTS` can be used to inspect physical projection definitions.
5. `MERGE` can combine updates and inserts into one operation.
6. A staging table is a useful pattern for incremental data loading.
7. Cluster topology matters when evaluating data redistribution and join behavior.
