# Project Meridian

A hands-on Vertica Community Edition lab covering ingestion, incremental loading, reporting, physical design, security, and workload governance.

## Project goals

Project Meridian demonstrates:

- Initial CSV ingestion with `COPY`
- Rejected-record handling
- Data-quality validation
- Incremental loading with staging and `MERGE INTO`
- Reporting queries
- Statistics collection
- Vertica Database Designer evaluation
- Custom projection design
- Monthly table partitioning
- Query-plan inspection with `EXPLAIN`
- Runtime inspection with `PROFILE`
- Role-based access control
- Sensitive-data isolation
- Resource-pool governance
- Single-node CE architecture and K-safety limitations

## Environment

- Vertica Community Edition 24.1.0-0
- Docker
- Database: `demo`
- Schema: `meridian`
- Single node: `v_demo_node0001`

## Repository structure

```text
project-meridian/
├── data/
├── docs/
├── results/
├── sql/
│   ├── 01_schema.sql
│   ├── 02_initial_load.sql
│   ├── 03_incremental_merge.sql
│   ├── 04_reporting.sql
│   ├── 05_physical_design.sql
│   ├── 06_security.sql
│   ├── 07_resource_pool.sql
│   └── 08_validation.sql
└── README.md
