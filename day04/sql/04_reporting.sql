-- Project Meridian
-- 04_reporting.sql
-- Core reporting queries

-- 1. Monthly revenue
SELECT
    DATE_TRUNC('month', order_date) AS order_month,
    SUM(quantity * unit_price - discount_amount) AS revenue
FROM meridian.orders
GROUP BY 1
ORDER BY 1;


-- 2. Revenue by customer segment
SELECT
    c.customer_segment,
    COUNT(*) AS order_count,
    SUM(o.quantity * o.unit_price - o.discount_amount) AS revenue
FROM meridian.orders o
JOIN meridian.customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY revenue DESC;


-- 3. Revenue by product category
SELECT
    p.category,
    SUM(o.quantity * o.unit_price - o.discount_amount) AS revenue
FROM meridian.orders o
JOIN meridian.products p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;


-- 4. Revenue by sales channel
SELECT
    sales_channel,
    COUNT(*) AS order_count,
    SUM(quantity * unit_price - discount_amount) AS revenue
FROM meridian.orders
GROUP BY sales_channel
ORDER BY revenue DESC;


-- 5. Revenue by order status
SELECT
    order_status,
    COUNT(*) AS order_count,
    SUM(quantity * unit_price - discount_amount) AS revenue
FROM meridian.orders
GROUP BY order_status
ORDER BY revenue DESC;
