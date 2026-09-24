# Vertica Day 3 — Security, RBAC & Resource Pools

## Objective

Build and verify a basic Vertica security and workload-management setup beyond the `dbadmin` user.

The lab covers:

* Creating real users and roles
* Granting and revoking schema/table privileges
* Separating read-only analyst access from ETL load access
* Assigning a resource pool to a workload
* Configuring memory and concurrency limits
* Proving that a resource-pool restriction is actually enforced
* Understanding K-safety and multi-node concepts

## Environment

* Vertica: `v24.1.0-0`
* Deployment: Single-node Vertica Community Edition
* Database node: `v_demo_node0001`
* Client: `vsql`

## Users and Roles

| User           | Role           | Purpose                                 |
| -------------- | -------------- | --------------------------------------- |
| `analyst_user` | `analyst_role` | Read-only access to `training.orders`   |
| `etl_user`     | `etl_role`     | Insert-only access to `training.orders` |
| `dbadmin`      | `dbadmin`      | Administrative setup and verification   |

## Analyst Access

Created `analyst_role` and granted schema usage plus `SELECT` on `training.orders`.

```sql
GRANT USAGE ON SCHEMA training TO analyst_role;
GRANT SELECT ON training.orders TO analyst_role;

SET ROLE analyst_role;

SELECT * FROM training.orders;
```

## ETL Access

Created `etl_role` and granted schema usage plus `INSERT` on `training.orders`.

```sql
GRANT USAGE ON SCHEMA training TO etl_role;
GRANT INSERT ON training.orders TO etl_role;

SET ROLE etl_role;
```

## Access-Control Matrix

| Role           | `SELECT training.orders` | `INSERT training.orders` |
| -------------- | -----------------------: | -----------------------: |
| `analyst_role` |                  Allowed |                   Denied |
| `etl_role`     |                   Denied |                  Allowed |

The permissions were tested using separate non-`dbadmin` users.

## Resource Pool

Created a dedicated resource pool for the ETL workload.

```sql
CREATE RESOURCE POOL etl_pool
    MEMORYSIZE '5%'
    MAXMEMORYSIZE '10%'
    PLANNEDCONCURRENCY 2;

GRANT USAGE ON RESOURCE POOL etl_pool TO etl_user;

ALTER USER etl_user RESOURCE POOL etl_pool;

ALTER RESOURCE POOL etl_pool
    MAXCONCURRENCY 1;
```

## Resource-Pool Enforcement Proof

Created a workload table large enough to produce a measurable query.

```sql
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
```

The resource-pool concurrency restriction was tested at runtime. The test produced `ERROR 3326`, demonstrating that the configured maximum concurrency was enforced rather than merely documented.

## Monitoring

Resource-pool status was checked with:

```sql
SELECT pool_name,
       memory_size_kb,
       memory_inuse_kb,
       max_memory_size_kb,
       running_query_count,
       planned_concurrency
FROM resource_pool_status
WHERE pool_name = 'etl_pool';
```

Query history was also inspected through `v_monitor.query_requests`:

```sql
SELECT user_name, request_id, request
FROM v_monitor.query_requests
WHERE user_name = 'etl_user'
ORDER BY request_id DESC
LIMIT 10;
```

These views helped verify the pool configuration and the workload executed by `etl_user`.

## K-Safety and Multi-Node Concepts

The lab environment is a single-node Vertica CE deployment.

```sql
SELECT node_name, node_state, node_address
FROM nodes;
```

Result:

```text
v_demo_node0001 | UP | 127.0.0.1
```

The system reported:

```text
designed_fault_tolerance | current_fault_tolerance
0                        | 0
```

Therefore, physical K-safety and node-failure recovery could not be demonstrated in this single-node environment.

Conceptually:

* RBAC controls **what a user is allowed to do**.
* Resource pools control **how workload resources are managed**.
* K-safety provides **data redundancy and fault tolerance across nodes**.
* A multi-node cluster is required to demonstrate physical redundancy and failover.

## SQL Work Completed

| Area              | Work                                                       |
| ----------------- | ---------------------------------------------------------- |
| RBAC              | Created `analyst_role` and `etl_role`                      |
| Users             | Created `analyst_user` and `etl_user`                      |
| Schema access     | Granted `USAGE` on `training`                              |
| Table access      | Granted `SELECT` or `INSERT` according to role             |
| Access proof      | Verified allowed and denied operations                     |
| Resource pool     | Created `etl_pool`                                         |
| Memory limits     | Configured 5% initial and 10% maximum memory               |
| Concurrency       | Configured planned concurrency 2 and maximum concurrency 1 |
| Enforcement proof | Captured `ERROR 3326` from the runtime cap                 |
| Monitoring        | Used `resource_pool_status` and `v_monitor.query_requests` |
| K-safety          | Verified the environment is single-node                    |

## Key Takeaways

1. Vertica RBAC separates permissions from individual users by assigning privileges to roles.
2. Schema `USAGE` is required before a role can access objects within the schema.
3. `analyst_role` and `etl_role` demonstrate separation of duties.
4. Resource pools can be assigned to specific users and configured with workload limits.
5. A configuration alone is not sufficient as proof; the runtime-cap test produced an actual Vertica error showing enforcement.
6. K-safety is a multi-node concept and cannot be physically demonstrated on this single-node CE environment.
7. No passwords or other credentials were stored in this repository.

```


