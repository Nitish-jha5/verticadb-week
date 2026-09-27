# Project Meridian — Access Matrix

| Object / Capability | Analyst | Loader | Finance |
|---|---|---|---|
| `meridian.customers` | SELECT | No access | No access |
| `meridian.products` | SELECT | No access | No access |
| `meridian.orders` | SELECT | SELECT, INSERT, UPDATE | No access |
| `meridian.orders_stg` | No access | SELECT, INSERT | No access |
| `meridian.returns` | No access | No access | SELECT |
| `meridian.returns_analyst` | SELECT | No access | No access |
| Returns PII columns | No access | No access | SELECT |
| DELETE privileges | No | No | No |
| DDL privileges | No | No | No |
| Primary purpose | Read-only analytics | Nightly ingestion/merge | Returns and refund investigation |

## Role design

### Analyst

The analyst role is read-only and can query customers, products, orders,
and the sanitized `returns_analyst` view.

The analyst does not have direct SELECT permission on `meridian.returns`,
so sensitive fields such as customer email, phone, billing address, and
payment token are not exposed.

### Loader

The loader role is restricted to ingestion-related DML:

- SELECT from `orders`
- SELECT and INSERT on `orders_stg`
- SELECT, INSERT, and UPDATE on `orders`

It has no DELETE or DDL privileges.

This supports the nightly staging/COPY/MERGE workflow without granting
broad administrative access.

### Finance

The finance role has SELECT access to `meridian.returns`, including the
sensitive refund and PII fields.

It has no access to the orders, customers, products, or staging tables.

## Validation performed

- Analyst querying `meridian.returns` → permission denied.
- Analyst querying `meridian.returns_analyst` → succeeds.
- Finance querying `meridian.returns` → succeeds.
- Finance querying `meridian.orders` → permission denied.
- Loader staging access → succeeds.
- Loader MERGE workflow → succeeds.

User passwords were created interactively during the lab and are
intentionally excluded from version control.
