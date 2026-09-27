-- Project Meridian
-- 03_incremental_merge.sql
-- Incremental ingestion using staging and MERGE

COPY meridian.orders_stg
FROM '/tmp/meridian/orders_incremental.csv'
DELIMITER ','
ENCLOSED BY '"'
SKIP 1;

MERGE INTO meridian.orders AS target
USING meridian.orders_stg AS source
ON target.order_id = source.order_id

WHEN MATCHED THEN UPDATE SET
    customer_id      = source.customer_id,
    product_id       = source.product_id,
    order_date       = source.order_date,
    quantity         = source.quantity,
    unit_price       = source.unit_price,
    discount_amount  = source.discount_amount,
    order_status     = source.order_status,
    sales_channel    = source.sales_channel,
    updated_at       = source.updated_at

WHEN NOT MATCHED THEN INSERT (
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
)
VALUES (
    source.order_id,
    source.customer_id,
    source.product_id,
    source.order_date,
    source.quantity,
    source.unit_price,
    source.discount_amount,
    source.order_status,
    source.sales_channel,
    source.updated_at
);

-- Clear the staging table after a successful merge.
TRUNCATE TABLE meridian.orders_stg;

-- Verify staging is empty.
SELECT COUNT(*) AS staging_rows
FROM meridian.orders_stg;
