-- Project Meridian
-- 01_schema.sql
-- Core table definitions

CREATE SCHEMA IF NOT EXISTS meridian;

CREATE TABLE meridian.customers (
    customer_id       INTEGER NOT NULL,
    customer_name     VARCHAR(100) NOT NULL,
    email             VARCHAR(200) NOT NULL,
    signup_date       DATE NOT NULL,
    customer_segment  VARCHAR(30) NOT NULL,
    country           VARCHAR(50) NOT NULL
);

CREATE TABLE meridian.products (
    product_id    INTEGER NOT NULL,
    sku           VARCHAR(40) NOT NULL,
    product_name  VARCHAR(200) NOT NULL,
    category      VARCHAR(80) NOT NULL,
    unit_price    NUMERIC(12,2) NOT NULL
);

CREATE TABLE meridian.orders (
    order_id         INTEGER NOT NULL,
    customer_id      INTEGER NOT NULL,
    product_id       INTEGER NOT NULL,
    order_date       DATE NOT NULL,
    quantity         INTEGER NOT NULL,
    unit_price       NUMERIC(12,2) NOT NULL,
    discount_amount  NUMERIC(12,2) NOT NULL DEFAULT 0,
    order_status     VARCHAR(20) NOT NULL,
    sales_channel    VARCHAR(20) NOT NULL,
    updated_at       TIMESTAMP NOT NULL
)
PARTITION BY DATE_TRUNC('month', order_date);

CREATE TABLE meridian.returns (
    return_id        INTEGER NOT NULL,
    order_id         INTEGER NOT NULL,
    customer_id      INTEGER NOT NULL,
    return_date      DATE NOT NULL,
    refund_amount    NUMERIC(12,2) NOT NULL,
    refund_reason    VARCHAR(200) NOT NULL,
    customer_email   VARCHAR(200) NOT NULL,
    customer_phone   VARCHAR(40),
    billing_address  VARCHAR(300),
    payment_token    VARCHAR(120)
);

CREATE TABLE meridian.orders_stg (
    order_id         INTEGER NOT NULL,
    customer_id      INTEGER NOT NULL,
    product_id       INTEGER NOT NULL,
    order_date       DATE NOT NULL,
    quantity         INTEGER NOT NULL,
    unit_price       NUMERIC(12,2) NOT NULL,
    discount_amount  NUMERIC(12,2) NOT NULL DEFAULT 0,
    order_status     VARCHAR(20) NOT NULL,
    sales_channel    VARCHAR(20) NOT NULL,
    updated_at       TIMESTAMP NOT NULL
);
