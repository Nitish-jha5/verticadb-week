-- Final target row count
SELECT COUNT(*) AS target_count_after
FROM customer_target;

-- Rows updated by the MERGE
SELECT *
FROM customer_target
WHERE customer_id IN (2, 3)
ORDER BY customer_id;

-- Rows inserted by the MERGE
SELECT *
FROM customer_target
WHERE customer_id IN (4, 5)
ORDER BY customer_id;
