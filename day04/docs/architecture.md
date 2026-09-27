# Architecture and Deployment Notes

## Vertica environment

Project Meridian was implemented on Vertica Community Edition running in Docker.

The lab environment uses a single Vertica node:

- Node: `v_demo_node0001`
- Address: `127.0.0.1`
- Database: `demo`

## Single-node limitation

The Community Edition environment used for this project contains only one Vertica node.

Therefore, the lab can demonstrate:

- Projection design
- Segmentation definitions
- Partitioning
- Query-plan changes
- Statistics
- Resource pools
- Role-based access control

It cannot provide a real multi-node demonstration of distributed query execution or node-to-node parallelism.

## K-safety

K-safety is a Vertica mechanism for maintaining additional projection copies so that the database can continue operating after node failures.

A meaningful node-level K-safety demonstration requires multiple Vertica nodes.

Because this project runs on a single-node CE environment, no node-failure or failover experiment was performed.

The physical-design work therefore focuses on projection definitions and query execution plans rather than claiming multi-node fault tolerance.

## Production considerations

A production deployment would use multiple Vertica nodes and would evaluate:

- K-safety requirements
- Projection replication
- Segmentation across nodes
- Workload concurrency
- Resource-pool allocation
- Partition retention
- Backup and recovery procedures
- Monitoring and operational alerting

The single-node CE environment is treated as a development and learning environment rather than a production architecture.
