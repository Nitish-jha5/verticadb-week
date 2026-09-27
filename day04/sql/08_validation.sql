-- Project Meridian
-- 08_validation.sql
-- Final validation checks

-- Core row counts
SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM meridian.customers
UNION ALL
SELECT 'products', COUNT(*)
FROM meridian.products
UNION ALL
SELECT 'orders', COUNT(*)
FROM meridian.orders
UNION ALL
SELECT 'orders_stg', COUNT(*)
FROM meridian.orders_stg
UNION ALL
SELECT 'returns', COUNT(*)
FROM meridian.returns;


-- Check for orders referencing a missing product.
SELECT
    o.order_id,
    o.product_id
FROM meridian.orders o
LEFT JOIN meridian.products p
    ON p.product_id = o.product_id
WHERE p.product_id IS NULL
ORDER BY o.order_id;


-- Projection health
SELECT
    projection_name,
    anchor_table_name,
    is_up_to_date,
    is_segmented
FROM v_catalog.projections
WHERE projection_schema = 'meridian'
ORDER BY projection_name;


-- Monthly partitions
SELECT
    projection_name,
    partition_key,
    node_name,
    ros_row_count
FROM v_monitor.partitions
WHERE table_schema = 'meridian'
  AND projection_name = 'orders_join'
ORDER BY partition_key;
