-- Day 3: Resource Pool Enforcement Test
--
-- Run the setup as dbadmin, then execute the enforcement query as etl_user.
-- The runtime-cap test produced Vertica ERROR 3326 in the lab environment.

CREATE TABLE training.pool_test (
    id INT,
    payload VARCHAR(100)
);

INSERT INTO training.pool_test (id, payload)
SELECT
    ROW_NUMBER() OVER ()::INT,
    'resource-pool-test'
FROM training.orders a
CROSS JOIN training.orders b
CROSS JOIN training.orders c
CROSS JOIN training.orders d
CROSS JOIN training.orders e
LIMIT 1000000;

COMMIT;

-- Allow the ETL role to read the workload table used by the test.
GRANT SELECT ON training.pool_test TO etl_role;

-- Set a deliberately short runtime cap for the enforcement test.
ALTER RESOURCE POOL etl_pool
    RUNTIMECAP '00:00:01';

-- Run this statement as etl_user.
-- In the lab this produced:
-- ERROR 3326: Execution time exceeded run time cap of 00:00:01
SELECT COUNT(*)
FROM training.pool_test;

-- Always restore the pool after the test.
ALTER RESOURCE POOL etl_pool
    RUNTIMECAP NONE;
