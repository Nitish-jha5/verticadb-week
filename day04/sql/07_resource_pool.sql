-- Project Meridian
-- 07_resource_pool.sql
-- Resource governance for analyst workloads

CREATE RESOURCE POOL meridian_analyst_pool
    MEMORYSIZE '50M'
    MAXMEMORYSIZE '100M'
    PLANNEDCONCURRENCY 1
    MAXCONCURRENCY 1;

GRANT USAGE ON RESOURCE POOL meridian_analyst_pool
TO meridian_analyst_user;

ALTER USER meridian_analyst_user
RESOURCE POOL meridian_analyst_pool;
