-- Project Meridian
-- 06_security.sql
-- Role-based access control and least-privilege boundaries

CREATE ROLE meridian_analyst;
CREATE ROLE meridian_loader;
CREATE ROLE meridian_finance;


-- Sanitized returns view for analysts.
-- Sensitive PII/payment columns are intentionally excluded.
CREATE VIEW meridian.returns_analyst AS
SELECT
    return_id,
    order_id,
    customer_id,
    return_date,
    refund_amount,
    refund_reason
FROM meridian.returns;


-- Analyst: reporting access, but no direct access to sensitive returns.
GRANT USAGE ON SCHEMA meridian TO meridian_analyst;
GRANT SELECT ON meridian.customers TO meridian_analyst;
GRANT SELECT ON meridian.products TO meridian_analyst;
GRANT SELECT ON meridian.orders TO meridian_analyst;
GRANT SELECT ON meridian.returns_analyst TO meridian_analyst;


-- Loader: ingestion-only DML.
-- SELECT is needed for staging/merge workflows.
-- DELETE and DDL privileges are intentionally not granted.
GRANT USAGE ON SCHEMA meridian TO meridian_loader;
GRANT INSERT, SELECT ON meridian.orders_stg TO meridian_loader;
GRANT SELECT ON meridian.orders TO meridian_loader;
GRANT INSERT, UPDATE ON meridian.orders TO meridian_loader;


-- Finance: sensitive returns access only.
GRANT USAGE ON SCHEMA meridian TO meridian_finance;
GRANT SELECT ON meridian.returns TO meridian_finance;


-- Demo users were created interactively during the lab.
-- Passwords are intentionally excluded from version control.
--
-- CREATE USER meridian_analyst_user IDENTIFIED BY '<set-secure-password>';
-- CREATE USER meridian_loader_user IDENTIFIED BY '<set-secure-password>';
-- CREATE USER meridian_finance_user IDENTIFIED BY '<set-secure-password>';


-- Assign roles to the demo users.
GRANT meridian_analyst TO meridian_analyst_user;
GRANT meridian_loader TO meridian_loader_user;
GRANT meridian_finance TO meridian_finance_user;
