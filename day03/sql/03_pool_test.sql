-- Day 3: Resource Pool Enforcement Test

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
