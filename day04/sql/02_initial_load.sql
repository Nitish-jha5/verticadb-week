-- Project Meridian
-- 02_initial_load.sql
-- Initial bulk load with rejected-record capture

COPY meridian.orders
FROM '/tmp/meridian/orders_2025.csv'
DELIMITER ','
ENCLOSED BY '"'
SKIP 1
REJECTED DATA '/tmp/meridian/orders_2025.rejects'
EXCEPTIONS '/tmp/meridian/orders_2025.exceptions';

-- Basic load validation
SELECT
    COUNT(*) AS order_count,
    MIN(order_id) AS min_order_id,
    MAX(order_id) AS max_order_id
FROM meridian.orders;

-- Referential-integrity validation
-- COPY catches data-format/type problems, but not this business rule.
SELECT
    o.order_id,
    o.product_id,
    p.product_id AS matched_product_id
FROM meridian.orders o
LEFT JOIN meridian.products p
    ON p.product_id = o.product_id
WHERE p.product_id IS NULL;
