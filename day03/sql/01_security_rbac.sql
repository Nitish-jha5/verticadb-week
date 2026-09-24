-- Day 3: Security and RBAC
-- Analyst and ETL role permissions

GRANT USAGE ON SCHEMA training TO analyst_role;
GRANT SELECT ON training.orders TO analyst_role;

SET ROLE analyst_role;

SELECT * FROM training.orders;

GRANT USAGE ON SCHEMA training TO etl_role;
GRANT INSERT ON training.orders TO etl_role;

SET ROLE etl_role;
