# VerticaDB Week — Day 1 Lab

**Date:** September 21–24, 2026  
**Database:** Vertica Analytic Database 24.1.0-0  
**Lab table:** `store.store_sales_fact`

## Objective

This lab focused on:

- Reviewing `JOIN`, `GROUP BY`, window functions, and `COPY` loading concepts.
- Using Vertica Database Designer (DBD).
- Creating a query set from workload queries.
- Generating and deploying a DBD projection recommendation.
- Comparing `EXPLAIN` plans before and after DBD.
- Partitioning a fact-style table by year.
- Dropping a partition using `DROP_PARTITION`.
- Verifying the resulting row counts and date range.

## Environment

Vertica was running in Docker:

- Container: `vertica-ce`
- Image: `molo17/vertica-ce:24.1.0-0`
- Vertica version: `24.1.0-0`

The lab was performed against the existing `store.store_sales_fact` table.

## 1. Baseline

Initial table size:

```text
Rows: 5,000,000
Minimum date: 2003-01-01
Maximum date: 2027-12-31
