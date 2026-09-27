# Project Meridian — Sale Weekend Postmortem

## Executive Summary

Meridian Retail's previous sale-weekend outage was caused by multiple
workloads competing for the same database resources. Analyst ad-hoc
queries and the nightly refresh could consume shared memory and
concurrency capacity at the same time, allowing analytical workload
to interfere with operational data loading. The returns dataset also
exposed customer PII too broadly.

Project Meridian addresses these failure modes through physical design,
workload isolation, and role-based access control.

## What Changed

### 1. Data model and ingestion

The original single-table approach was replaced with a structured model:

- `orders` as the transactional fact table
- `customers` as a customer dimension
- `products` as a product dimension
- `returns` as a restricted returns/refund table

Initial ingestion uses Vertica `COPY` with a rejects file. The test
load successfully loaded 11 rows and rejected one malformed row because
`quantity` contained `not_a_number` where an INTEGER was required.

The nightly pipeline uses a staging table and `MERGE INTO` with both
`WHEN MATCHED` and `WHEN NOT MATCHED` behavior.

### 2. Physical design

Orders are partitioned monthly by `order_date`.

Purpose-built projections were created with join-key alignment:

- `orders_join` segmented by `HASH(product_id)`
- `products_join` segmented by `HASH(product_id)`
- `customers_join` segmented by `HASH(customer_id)`

The product-category reporting query changed from a baseline hash-join
and resegmentation plan to a merge join using the product_id-aligned
projections.

The estimated EXPLAIN cost changed from approximately 750 to
approximately 734.

PROFILE measurements were also captured before and after. The measured
runtime changed from approximately 19.3 ms to approximately 46.0 ms.
Because the test dataset contains only 13 orders and 5 products on a
single-node CE installation, this is not treated as a meaningful
production-scale performance comparison and no wall-clock improvement
is claimed.

### 3. Security

Three roles were created:

- Analyst — read-only reporting access without direct returns PII
- Loader — restricted ingestion/merge DML
- Finance — access to returns including sensitive fields

The analyst receives a sanitized returns view instead of direct access
to the sensitive returns table.

Security validation confirmed that analyst access to the raw returns
table is denied while the sanitized view succeeds. Finance can query
the sensitive returns table but cannot query orders.

### 4. Workload isolation

The analyst role was assigned to a dedicated resource pool with:

- 50 MB base memory
- 100 MB maximum memory
- planned concurrency of 1
- maximum concurrency of 1

A representative analyst query was rejected because the pool could not
satisfy its memory requirement. The recorded error reported a request
of approximately 177,204 KB against a 102,400 KB pool limit.

The loader workflow was tested separately and its MERGE continued to
work using the general resource pool.

This demonstrates the intended isolation: an analyst workload can be
rejected by its resource limit without consuming unrestricted resources
needed by the ingestion workload.

## Why the Previous Failure Mode Is Addressed

The new design separates the major sources of contention:

- Physical design reduces unnecessary data movement for key reporting
  joins.
- Monthly partitioning supports targeted access to order periods.
- Analyst resource limits prevent a single ad-hoc workload from
  consuming unrestricted memory/concurrency.
- The loader has a controlled ingestion privilege set and operates in
  the general pool.
- Returns PII is restricted to the finance role.

These controls address the specific contention and access-control
failure modes represented by the previous outage scenario.

## Multi-node and K-safety Consideration

The project was executed on a single-node Vertica CE Docker installation,
so node-level parallelism and K-safety could not be demonstrated
hands-on.

In a production multi-node deployment, K-safety would provide redundant
projection copies across nodes, while distributed execution would allow
work to be processed across multiple nodes rather than relying on a
single node. The production design should therefore include appropriate
segmentation, replication/K-safety, workload management, monitoring,
and capacity planning.

The single-node CE limitation is an environment constraint, not a
claim that a production cluster has been simulated.

## Leadership Conclusion

Project Meridian replaces the previous shared, unoptimized workload
model with structured data ingestion, workload-aware physical design,
role-based security, and resource governance. The lab demonstrates the
controls that address the identified outage mechanisms while clearly
documenting the limitations of the single-node CE test environment.
