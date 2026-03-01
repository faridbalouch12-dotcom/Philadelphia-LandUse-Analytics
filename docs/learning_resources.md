# Learning resources — Philly Data Warehouse

**Author:** Farid
**Created:** 2026-02-28
**Last Updated:** 2026-02-28
**Status:** Draft

---

## Purpose

This document is the central learning library for the Philly Data Warehouse project. It organizes curated resources by topic, explains why each category matters for this specific project, and tracks what to read and watch across Month 1 and beyond.

Resources are referenced using IDs from [`claude/resources.md`](../claude/resources.md). Full citations are in [`docs/bibliography.md`](./bibliography.md).

---

## Modeling

**Why this matters for this project:** This project involves building a data warehouse to analyze how Philadelphia's planning districts change over time, ingesting datasets from multiple sources (Philly Open Data, U.S. Census Bureau ACS). Understanding data modeling is essential for designing relationships between tables — 1:1, 1:many, many:many — and for knowing the difference between fact tables (events and measures) and dimension tables (descriptive context). Concepts like **grain** are foundational: without declaring grain precisely, metrics will be miscalculated and joins will produce incorrect results.

*Resources to be populated in Task 2.4:*

- <!-- B1: placeholder -->
- <!-- B2: placeholder -->
- <!-- B3: placeholder -->
- <!-- B5: placeholder -->
- <!-- V1: placeholder -->

---

## Postgres/DB design

**Why this matters for this project:** Postgres is the primary database stack for this warehouse. Understanding DB design means knowing how to define primary keys, foreign keys, and column types; how to create and modify tables; how to write queries; and how to connect the database to downstream tools like Metabase (for visualization) and Python (via ODBC/psycopg2). Getting the schema design right in Month 1 avoids expensive structural changes later.

*Resources to be populated in Task 2.4:*

- <!-- D9: placeholder -->
- <!-- D10: placeholder -->
- <!-- D11: placeholder -->

---

## GIS/PostGIS

**Why this matters for this project:** The project includes spatial datasets (e.g., planning district boundaries, zoning polygons) in shapefile and GeoJSON formats. PostGIS extends Postgres with spatial data types and functions, enabling spatial joins (e.g., assigning a permit address to a planning district), area calculations (e.g., land-only square miles per district), and geometry validation. Understanding how spatial data differs from tabular data — and why spatial indexes matter for query performance — is critical before writing any pipeline.

*Resources to be populated in Task 2.4:*

- <!-- D3: placeholder -->
- <!-- D4: placeholder -->
- <!-- V3: placeholder -->

---

## ACS

**Why this matters for this project:** The American Community Survey (ACS) provides demographic context — population, income, tenure, and other indicators — that helps explain *why* districts are changing, not just *what* is changing. The ACS data has important nuances: estimates are produced over multi-year periods (e.g., 2009–2013), not single calendar years, and overlapping period estimates cannot be directly compared. Understanding these constraints is essential to using ACS data correctly in metrics and to phrasing caveats accurately in any output.

*Resources to be populated in Task 2.4:*

- <!-- D1: placeholder -->
- <!-- D2: placeholder -->

---

## Git/GitHub workflow

**Why this matters for this project:** One of the explicit learning objectives of this project is building a reproducible, publicly reviewable data warehouse. Git and GitHub are the tools that make that possible. Beyond storage, understanding how developers actually use Git — branching strategies, commit hygiene, pull requests, protected branches — is essential for adopting professional engineering habits, especially given limited prior experience collaborating on version-controlled codebases.

*Resources to be populated in Task 2.4:*

- <!-- D8: placeholder -->
- <!-- V4: placeholder -->
- <!-- V6: placeholder -->

---

## dbt

**Why this matters for this project:** dbt (data build tool) handles the Transform step in ELT pipelines. It lets you define fact and dimension tables as SQL models, test them for data quality, and document them — all in version control. It is a standard tool in modern data engineering stacks and learning it here, even in Month 1 as conceptual context, will reduce the ramp-up time when pipelines are built in Month 2+.

*Resources to be populated in Task 2.4:*

- <!-- R2: placeholder -->
- <!-- V5: placeholder -->

---

## Metabase

**Why this matters for this project:** Metabase is the planned visualization and BI layer for this project. It is open-source, connects directly to Postgres, and is well-suited to solo or small-team projects. Understanding its capabilities and constraints — including what kinds of queries and dashboards it supports — informs how the warehouse schema is designed in Month 1, particularly the rollup tables intended for end-user consumption.

*Resources to be populated in Task 2.4:*

- <!-- placeholder: Metabase docs/resources TBD -->

---

## Philly datasets

**Why this matters for this project:** The entire project is anchored to Philadelphia-specific open datasets: planning district boundaries, L&I building permits, zoning base districts, and ACS demographic context. Understanding what datasets are available (via OpenDataPhilly and related portals), where they live, how to access them (API vs. bulk download), and what their attributes mean is the prerequisite for every modeling and metric decision made in Month 1.

*Resources to be populated in Task 2.4:*

- <!-- S1: placeholder -->
- <!-- S2: placeholder -->
- <!-- S3: placeholder -->

---

## References

*To be populated as resources are added in Tasks 2.4 and beyond. Full citations in [`docs/bibliography.md`](./bibliography.md).*

---

## Change log

| Date       | Change description                        | Author |
|------------|-------------------------------------------|--------|
| 2026-02-28 | Initial skeleton created (Task 2.1)       | Farid  |
