-- Project Meridian
-- 04_reporting.sql
-- Core reporting queries covering the required reporting use cases


-- 1. Top products by revenue
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(o.quantity) AS units_sold,
    SUM(o.quantity * o.unit_price - o.discount_amount) AS revenue
FROM meridian.orders o
JOIN meridian.products p
    ON o.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY revenue DESC
LIMIT 10;


-- 2. Customer lifetime value
SELECT
    c.customer_id,
    c.customer_name,
    c.customer_segment,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(o.quantity * o.unit_price - o.discount_amount) AS lifetime_value
FROM meridian.customers c
LEFT JOIN meridian.orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.customer_segment
ORDER BY lifetime_value DESC NULLS LAST;


-- 3. Monthly revenue trend
SELECT
    DATE_TRUNC('month', order_date) AS order_month,
    SUM(quantity * unit_price - discount_amount) AS revenue
FROM meridian.orders
GROUP BY 1
ORDER BY 1;


-- 4. Returns and refunds
SELECT
    r.return_date,
    r.order_id,
    r.refund_amount,
    r.refund_reason
FROM meridian.returns r
ORDER BY r.return_date DESC;


-- 5. Revenue by product category
-- This query is also the physical-design benchmark used in
-- the before/after EXPLAIN and PROFILE evidence.
SELECT
    p.category,
    SUM(o.quantity * o.unit_price - o.discount_amount) AS revenue
FROM meridian.orders o
JOIN meridian.products p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;
