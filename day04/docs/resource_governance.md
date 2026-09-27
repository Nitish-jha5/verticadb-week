# Resource Governance

Project Meridian uses a dedicated Vertica resource pool for analyst workloads.

## Analyst resource pool

The `meridian_analyst_pool` resource pool was configured with:

- MEMORYSIZE: 50M
- MAXMEMORYSIZE: 100M
- PLANNEDCONCURRENCY: 1
- MAXCONCURRENCY: 1

The `meridian_analyst_user` account was assigned to this pool.

## Validation

The analyst product-category reporting query was executed while the user was assigned to `meridian_analyst_pool`.

The query was rejected because the execution plan requested more memory than the pool's configured maximum.

Vertica returned error 3587, indicating insufficient resources to execute the plan on `meridian_analyst_pool`.

The rejected request required 177204 KB while the pool limit was 102400 KB.

This demonstrates enforcement of the resource-pool memory limit.

The result should be described as a rejected query due to the resource limit, rather than as throttling.

## Loader isolation

The loader user remained assigned to the general resource pool.

A loader MERGE test completed successfully while the analyst workload was subject to the dedicated analyst resource pool.

This demonstrates separate workload governance for the two demo users.
