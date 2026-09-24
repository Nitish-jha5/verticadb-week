-- Day 3: Resource Pool and Query Monitoring

SELECT pool_name,
       memory_size_kb,
       memory_inuse_kb,
       max_memory_size_kb,
       running_query_count,
       planned_concurrency
FROM resource_pool_status
WHERE pool_name = 'etl_pool';

SELECT user_name, request_id, request
FROM v_monitor.query_requests
WHERE user_name = 'etl_user'
ORDER BY request_id DESC
LIMIT 10;

-- K-Safety / node verification
SELECT node_name, node_state, node_address
FROM nodes;
