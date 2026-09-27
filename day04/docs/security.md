# Security and Access Control

Project Meridian uses role-based access control with separate roles for analysts, loaders, and finance users.

## Roles

### Analyst

The `meridian_analyst` role can:

- Read customers
- Read products
- Read orders
- Read the sanitized `returns_analyst` view

The analyst does not have direct access to `meridian.returns`, which contains sensitive customer and payment-related fields.

### Loader

The `meridian_loader` role is intended for ingestion workflows.

It can:

- Read and insert into `orders_stg`
- Read orders
- Insert and update orders

DELETE and DDL privileges are intentionally not granted.

### Finance

The `meridian_finance` role can read `meridian.returns`, including the sensitive return-related fields.

No grants were given to finance for customers, products, or orders.

## Sanitized returns view

Analysts use:

`meridian.returns_analyst`

The view exposes:

- return_id
- order_id
- customer_id
- return_date
- refund_amount
- refund_reason

Sensitive fields such as customer email, phone, billing address, and payment token are excluded.

## Validation tests

The access boundaries were tested using separate demo users.

### Analyst

The analyst could query orders successfully.

A direct query against `meridian.returns` was rejected with a permission error.

A query against `meridian.returns_analyst` succeeded and returned the two return records.

### Finance

The finance user could query `meridian.returns`, including the sensitive columns.

A query against `meridian.orders` was rejected with a permission error.

### Loader

The loader could access the staging table and perform the required ingestion MERGE workflow.

A query against `meridian.customers` was rejected with a permission error.

The loader role therefore has access focused on the ingestion path rather than general reporting data.

## Credentials

Demo user passwords were created interactively during the lab and are intentionally excluded from version control.

Credentials should be supplied securely when recreating the environment rather than stored in SQL scripts or Git.
