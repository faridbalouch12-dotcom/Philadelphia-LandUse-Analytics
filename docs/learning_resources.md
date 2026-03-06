# Learning resources — Philly Data Warehouse

**Author:** Farid
**Created:** 2026-02-28
**Last Updated:** 2026-03-06
**Status:** Draft

---

## Purpose

This document is the central learning library for the Philly Data Warehouse project. It organizes curated resources by topic, explains why each category matters for this specific project, and tracks what to read and watch across Month 1 and beyond.

Resources are referenced using IDs from [`claude/resources.md`](../claude/resources.md). Full citations are in [`docs/bibliography.md`](./bibliography.md).

---

## Modeling

**Why this matters for this project:** This project involves building a data warehouse to analyze how Philadelphia's planning districts change over time, ingesting datasets from multiple sources (Philly Open Data, U.S. Census Bureau ACS). Understanding data modeling is essential for designing relationships between tables — 1:1, 1:many, many:many — and for knowing the difference between fact tables (events and measures) and dimension tables (descriptive context). Concepts like **grain** are foundational: without declaring grain precisely, metrics will be miscalculated and joins will produce incorrect results.

- **[B1]** [The Data Warehouse Toolkit](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/books/data-warehouse-dw-toolkit/) — Provides dimensional modeling foundations — grain, facts, dimensions, SCD patterns — directly applicable to designing the permits fact table, district dimension, and zoning snapshot tables.
- **[B2]** [Designing Data-Intensive Applications](https://dataintensive.net/) — Covers foundational data systems tradeoffs (consistency, storage engines, batch vs. stream) that inform architectural decisions throughout the pipeline.
- **[B3]** [Fundamentals of Data Engineering](https://mitpressbookstore.mit.edu/book/9781098108304) — Frames the end-to-end data engineering lifecycle, helping scope Month 1 deliverables and identify what is appropriately deferred to later months.
- **[B5]** [SQL Antipatterns](https://www.oreilly.com/library/view/sql-antipatterns/9781680500073/) — Documents common schema and query mistakes centered on PK/FK/constraints — directly relevant to designing clean relational models for this warehouse.

---

## Postgres/DB design

**Why this matters for this project:** Postgres is the primary database stack for this warehouse. Understanding DB design means knowing how to define primary keys, foreign keys, and column types; how to create and modify tables; how to write queries; and how to connect the database to downstream tools like Metabase (for visualization) and Python (via ODBC/psycopg2). Getting the schema design right in Month 1 avoids expensive structural changes later.

- **[D11]** [PostgreSQL Docs: Constraints (PK, UK, FK)](https://www.postgresql.org/docs/current/ddl-constraints.html) — Authoritative definitions for primary keys, unique constraints, and foreign keys — directly informs schema modeling policies for this warehouse.

---

## GIS/PostGIS

**Why this matters for this project:** The project includes spatial datasets (e.g., planning district boundaries, zoning polygons) in shapefile and GeoJSON formats. PostGIS extends Postgres with spatial data types and functions, enabling spatial joins (e.g., assigning a permit address to a planning district), area calculations (e.g., land-only square miles per district), and geometry validation. Understanding how spatial data differs from tabular data — and why spatial indexes matter for query performance — is critical before writing any pipeline.

- **[B13]** [Spatial SQL (Forrest)](https://locatepress.com/book/spatial-sql) — Practical introduction to PostGIS geometry types, spatial joins, and spatial indexing — used as primary reading for Task 2.8 (sections 3.4, 2.1–2.2, 3.5).
- **[D3]** [PostGIS Manual: Introduction](https://postgis.net/docs/manual-2.5/postgis_introduction.html) — Conceptual introduction to PostGIS and spatial types — prerequisite reading before working with planning district or zoning polygon geometries.
- **[D4]** [PostGIS FAQ: Spatial Indexes](https://postgis.net/documentation/faq/spatial-indexes/) — Explains how spatial indexes work and why they matter for query performance — foundational before writing any spatial join queries.
- **[B10]** [PostGIS in Action (3rd ed.)](https://www.manning.com/books/postgis-in-action-third-edition) — Core reference for PostGIS spatial types, functions, and spatial joins — required before writing geometry-aware queries for district boundary assignment.
- **[V3]** [PostGIS Introduction — Paul Ramsey (Crunchy Data)](https://www.youtube.com/live/g4DgAVCmiDE) — Conceptual overview of PostGIS and spatial querying — a visual primer before hands-on spatial work begins.

---

## ACS

**Why this matters for this project:** The American Community Survey (ACS) provides demographic context — population, income, tenure, and other indicators — that helps explain *why* districts are changing, not just *what* is changing. The ACS data has important nuances: estimates are produced over multi-year periods (e.g., 2009–2013), not single calendar years, and overlapping period estimates cannot be directly compared. Understanding these constraints is essential to using ACS data correctly in metrics and to phrasing caveats accurately in any output.

- **[D1]** [Period Estimates in the American Community Survey](https://www.census.gov/newsroom/blogs/random-samplings/2022/03/period-estimates-american-community-survey.html) — Explains how ACS multi-year period estimates are constructed and interpreted — required reading before using ACS data in any project metric.
- **[D2]** [Comparing ACS Data](https://www.census.gov/programs-surveys/acs/guidance/comparing-acs-data.html) — Provides guidance on valid and invalid ACS comparisons across time periods — directly informs the ACS usage policy and caveat language for this project.
- **[V5]** [Discovering the ACS: Guidance for Data Users](https://www.census.gov/library/video/2023/discovering-the-acs.html) — Census Bureau walkthrough of 1-year vs. 5-year estimates, MOE interpretation, and safe comparisons — supplements D1/D2 with worked examples.

---

## Git/GitHub workflow

**Why this matters for this project:** One of the explicit learning objectives of this project is building a reproducible, publicly reviewable data warehouse. Git and GitHub are the tools that make that possible. Beyond storage, understanding how developers actually use Git — branching strategies, commit hygiene, pull requests, protected branches — is essential for adopting professional engineering habits, especially given limited prior experience collaborating on version-controlled codebases.

- **[D8]** [Version Control (Git) — MIT Missing Semester](https://missing.csail.mit.edu/2026/version-control/) — Practical Git workflows for branching, commits, and history — foundational for the solo PR workflow used throughout this project.
- **[V4]** [Version Control Lecture — MIT Missing Semester](https://missing.csail.mit.edu/2026/version-control/) — Git workflows explained with practical demonstrations — companion video to D8 for building Git habits.
- **[R1]** [cookiecutter-data-science (DrivenData)](https://github.com/drivendataorg/cookiecutter-data-science) — Reference project structure patterns used to inform how this repo's folder layout and documentation conventions are organized.

---

## dbt

**Why this matters for this project:** dbt (data build tool) handles the Transform step in ELT pipelines. It lets you define fact and dimension tables as SQL models, test them for data quality, and document them — all in version control. It is a standard tool in modern data engineering stacks and learning it here, even in Month 1 as conceptual context, will reduce the ramp-up time when pipelines are built in Month 2+.

- **[D10]** [dbt Learn](https://www.getdbt.com/dbt-learn) — Official dbt training entry point covering sources, testing, docs, and deployment — provides conceptual context for the Transform step before dbt is introduced in Month 2.
- **[R2]** [jaffle-shop (dbt Labs)](https://github.com/dbt-labs/jaffle-shop) — Reference documentation patterns for dbt projects — informs how to structure models and documentation in the Transform layer.

---

## Metabase

**Why this matters for this project:** Metabase is the planned visualization and BI layer for this project. It is open-source, connects directly to Postgres, and is well-suited to solo or small-team projects. Understanding its capabilities and constraints — including what kinds of queries and dashboards it supports — informs how the warehouse schema is designed in Month 1, particularly the rollup tables intended for end-user consumption.

- **[D9]** [Learn Metabase](https://www.metabase.com/learn/) — Official Metabase concepts and modeling guides — forward reference for the BI layer that will consume this warehouse's rollup tables.
- **[V1]** [How to Create a Dashboard (Getting Started) — Metabase](https://www.youtube.com/watch?v=W-i9E5_Wjmw) — Short walkthrough of building dashboards in Metabase — forward reference for the visualization layer.

---

## Philly datasets

**Why this matters for this project:** The entire project is anchored to Philadelphia-specific open datasets: planning district boundaries, L&I building permits, zoning base districts, and ACS demographic context. Understanding what datasets are available (via OpenDataPhilly and related portals), where they live, how to access them (API vs. bulk download), and what their attributes mean is the prerequisite for every modeling and metric decision made in Month 1.

- **[S1]** [Planning Districts (Feature Layer) — City of Philadelphia / ArcGIS](https://catalog.data.gov/dataset/planning-districts-6a446) — District spine for all rollup metrics; provides the 18-district geometry used to compute land-only area and assign all permit/zoning/ACS records to a district.
- **[S2]** [L&I Building and Zoning Permits — OpenDataPhilly](https://opendataphilly.org/datasets/licenses-and-inspections-building-and-zoning-permits/) — Primary physical change time series (2007+); very large dataset requiring careful event-date selection, geocoding quality checks, and category mapping before use in district-month rollups.
- **[S3]** [Zoning Base Districts (vintages) — City of Philadelphia / ArcGIS](https://catalog.data.gov/dataset/zoning-base-districts) — Annual zoning snapshots used for year-to-year churn and composition metrics; schema consistency across vintages must be validated before comparing years.
- **[S4]** [American Community Survey 5-Year Data — U.S. Census Bureau (data.census.gov)](https://data.census.gov/) — ACS demographic context at tract level; 5-year estimates only, non-overlapping periods only, per the [ACS usage policy](./policies/acs_usage_policy.md).
- **[D16]** [OpenDataPhilly — About](https://opendataphilly.org/about/) — Context on the portal that hosts L&I permits and other Philly datasets; explains how datasets are published, maintained, and licensed.
- **[D17]** [ArcGIS REST API — Feature Service (Esri)](https://developers.arcgis.com/rest/services-reference/enterprise/feature-service/) — Reference for FeatureServer endpoints used to access planning district boundaries (S1) and zoning base districts (S3); covers field querying and pagination.
- **[D19]** [CARTO User Manual: PostgreSQL Connections](https://docs.carto.com/carto-user-manual/connections/postgresql) — Documents the PostgreSQL connection interface for CARTO-hosted datasets; relevant to the L&I permits Carto SQL API access method.
- **[D20]** [CARTO SQL API Documentation](https://carto.com/developers/sql-api/) — Reference for querying CARTO-hosted datasets via SQL over HTTP; the access method used to pull L&I permits data.

---

## References

Full citations for all resources listed above are in [`docs/bibliography.md`](./bibliography.md). Resources are referenced by ID — resolve using [`claude/resources.md`](../claude/resources.md).

---

## Change log

| Date | Change description | Author |
| --- | --- | --- |
| 2026-02-28 | Initial skeleton created (Task 2.1) | Farid |
| 2026-02-28 | Starter resource set populated (Task 2.4) | Farid |
| 2026-03-03 | Added B13 (Spatial SQL) to GIS/PostGIS section (Task 2.8) | Farid |
| 2026-03-05 | Populated Philly datasets section with S1, S2, S3, S4 (Task 5.9) | Farid |
| 2026-03-06 | Added D16, D17, D19, D20 to Philly datasets section — permits/open data access references (Task 7.7) | Farid |
