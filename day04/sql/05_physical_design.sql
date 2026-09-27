-- Project Meridian
-- 05_physical_design.sql
-- Workload-driven projections for join locality and ordering

CREATE PROJECTION meridian.products_join
AS
SELECT
    product_id,
    sku,
    product_name,
    category,
    unit_price
FROM meridian.products
ORDER BY product_id
SEGMENTED BY HASH(product_id) ALL NODES;


CREATE PROJECTION meridian.orders_join
AS
SELECT
    order_id,
    customer_id,
    product_id,
    order_date,
    quantity,
    unit_price,
    discount_amount,
    order_status,
    sales_channel,
    updated_at
FROM meridian.orders
ORDER BY product_id, order_date
SEGMENTED BY HASH(product_id) ALL NODES;


CREATE PROJECTION meridian.customers_join
AS
SELECT
    customer_id,
    customer_name,
    email,
    signup_date,
    customer_segment,
    country
FROM meridian.customers
ORDER BY customer_id
SEGMENTED BY HASH(customer_id) ALL NODES;


-- Refresh projections after creation.
SELECT START_REFRESH();
