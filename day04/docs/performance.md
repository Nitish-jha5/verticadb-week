# Performance and Physical Design

## Baseline

The baseline reporting query used the default superprojections. After statistics were collected, EXPLAIN showed a hash join between orders and products, followed by a hash group-by and local resegmentation.

Baseline product-category query cost was approximately 750.

The baseline PROFILE completed in approximately 19 ms on the single-node CE environment. Because the dataset is very small, this runtime is useful as an observation but not as a reliable benchmark.

## Designer-assisted analysis

Vertica Database Designer was used to evaluate the workload. The generated design was inspected but not deployed wholesale because its automatically generated segmentation choices were broader than the focused join-key design required for this lab.

## Custom projections

Three projections were created:

- `meridian.products_join` — segmented by `HASH(product_id)` and ordered by `product_id`.
- `meridian.orders_join` — segmented by `HASH(product_id)` and ordered by `product_id, order_date`.
- `meridian.customers_join` — segmented by `HASH(customer_id)` and ordered by `customer_id`.

The projections were refreshed with `START_REFRESH()` and verified as up to date.

## Query-plan change

After the custom projections were created, the product-category query changed from a hash join to a merge join using the presorted `orders_join` and `products_join` projections.

Final product-category EXPLAIN cost was approximately 734.

The customer-segment query used a hash join with `orders_join` and `customers_join`, using the shared customer join key for segmentation.

## Runtime observation

The final product-category PROFILE completed in approximately 46 ms.

The final runtime was not lower than the baseline. This is expected to be noisy on a tiny single-node dataset and should not be presented as a performance improvement.

The primary evidence of the physical-design change is therefore the projection selection and query-plan change, rather than elapsed time.

## Partitioning

The `meridian.orders` table is partitioned monthly using `DATE_TRUNC('month', order_date)`.

The `orders_join` projection contained monthly partitions for January through November 2025.

A September-only query showed the date predicate being applied directly at storage access, demonstrating predicate pushdown for the monthly date filter.
