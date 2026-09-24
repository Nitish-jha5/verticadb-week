-- Inspect the join plan for the segmented tables
EXPLAIN
SELECT
    t.customer_id,
    t.customer_name,
    s.city
FROM customer_target t
JOIN customer_stage s
    ON t.customer_id = s.customer_id;

-- Verify the physical projection segmentation
SELECT EXPORT_OBJECTS(
    '',
    'customer_target',
    'false'
);

SELECT EXPORT_OBJECTS(
    '',
    'customer_stage',
    'false'
);
