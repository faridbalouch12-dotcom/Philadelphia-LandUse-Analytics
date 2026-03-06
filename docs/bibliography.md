# Bibliography — Philly Data Warehouse

**Author:** Farid
**Created:** 2026-02-28
**Last Updated:** 2026-03-06
**Status:** Draft

---

## Purpose

This file is the authoritative citation record for all resources used in this project. Every resource referenced in notes, specs, or policies by an ID (e.g., [D1], [B3]) must have a corresponding entry here. Entries follow a consistent format to ensure sources are auditable and recoverable.

---

## Citation format

Each entry uses **Chicago Author-Date** style for the core citation, extended with three project-specific fields:

```markdown
**[ID]** Author/Org. Year. "Title." Accessed YYYY-MM-DD. <URL>

- **Type:** Book | Documentation | Video | Dataset | Reference Repo
- **Why relevant:** [1-sentence explanation tied to this project's needs]
```

**Field definitions:**

| Field | Description |
| --- | --- |
| ID | Resource ID from `claude/resources.md` (e.g., D1, B3, V4) |
| Author/Org | Person or organization responsible for the resource |
| Year | Publication or last-updated year; use `n.d.` if unknown |
| Title | Full title of the resource (article, book, page, video, etc.) |
| Date accessed | Date you read/viewed it — enables Wayback Machine lookup if URL goes dead |
| URL | Direct link to the resource |
| Type | One of: Book, Documentation, Video, Dataset, Reference Repo |
| Why relevant | One sentence connecting this resource to a specific project need |

---

## Entries

### Documentation

**[D1]** U.S. Census Bureau. 2022. "Period Estimates in the American Community Survey." Accessed 2026-02-28. <https://www.census.gov/newsroom/blogs/random-samplings/2022/03/period-estimates-american-community-survey.html>

- **Type:** Documentation
- **Why relevant:** Explains how ACS multi-year period estimates are constructed and interpreted — required reading before using ACS data in any project metric.

---

**[D2]** U.S. Census Bureau. n.d. "Comparing ACS Data." Accessed 2026-02-28. <https://www.census.gov/programs-surveys/acs/guidance/comparing-acs-data.html>

- **Type:** Documentation
- **Why relevant:** Provides guidance on valid and invalid ACS comparisons across time periods — directly informs the ACS usage policy and caveat language for this project.

---

**[D3]** PostGIS Project. n.d. "PostGIS Manual: Introduction." Accessed 2026-02-28. <https://postgis.net/docs/manual-2.5/postgis_introduction.html>

- **Type:** Documentation
- **Why relevant:** Conceptual introduction to PostGIS and spatial types — prerequisite reading before working with planning district or zoning polygon geometries.

---

**[D4]** PostGIS Project. n.d. "PostGIS FAQ: Spatial Indexes." Accessed 2026-02-28. <https://postgis.net/documentation/faq/spatial-indexes/>

- **Type:** Documentation
- **Why relevant:** Explains how spatial indexes work and why they matter for query performance — foundational before writing any spatial join queries.

---

**[D8]** MIT Missing Semester. 2026. "Version Control (Git)." Accessed 2026-02-28. <https://missing.csail.mit.edu/2026/version-control/>

- **Type:** Documentation
- **Why relevant:** Practical Git workflows for branching, commits, and history — foundational for the solo PR workflow used throughout this project.

---

**[D9]** Metabase. n.d. "Learn Metabase." Accessed 2026-02-28. <https://www.metabase.com/learn/>

- **Type:** Documentation
- **Why relevant:** Official Metabase concepts and modeling guides — forward reference for the BI layer that will consume this warehouse's rollup tables.

---

**[D10]** dbt Labs. n.d. "dbt Learn (dbt Fundamentals course overview)." Accessed 2026-02-28. <https://www.getdbt.com/dbt-learn>

- **Type:** Documentation
- **Why relevant:** Official dbt training entry point covering sources, testing, docs, and deployment — provides conceptual context for the Transform step before dbt is introduced in Month 2.

---

**[D11]** PostgreSQL.org. n.d. "PostgreSQL Docs: Constraints (PK, UK, FK)." Accessed 2026-02-28. <https://www.postgresql.org/docs/current/ddl-constraints.html>

- **Type:** Documentation
- **Why relevant:** Authoritative definitions for primary keys, unique constraints, and foreign keys — directly informs schema modeling policies for this warehouse.

---

**[D12]** CARTO. n.d. "CARTO User Manual: PostgreSQL Connections." Accessed 2026-03-06. <https://docs.carto.com/carto-user-manual/connections/postgresql>

- **Type:** Documentation
- **Why relevant:** Covers how to configure a PostgreSQL connection in CARTO — directly relevant to accessing the L&I permits dataset via the Carto SQL API endpoint used in the source catalog.

---

**[D13]** CARTO. n.d. "CARTO SQL API Documentation." Accessed 2026-03-06. <https://carto.com/developers/sql-api/>

- **Type:** Documentation
- **Why relevant:** Reference for querying CARTO-hosted datasets via SQL over HTTP — the access method used to pull L&I permits data as documented in the source catalog.

---

### Books

**[B13]** Forrest, Matthew. 2023. "Spatial SQL: A Practical Approach to Modern GIS Using SQL." Accessed 2026-03-03. <https://locatepress.com/book/spatial-sql>

- **Type:** Book
- **Why relevant:** Practical introduction to PostGIS geometry types, spatial joins, and spatial indexing — primary reading for Task 2.8 spatial primer notes, used in place of D3/D4 for direct book-based discussion.

---

**[B1]** Kimball, Ralph, and Margy Ross. 2013. "The Data Warehouse Toolkit: The Definitive Guide to Dimensional Modeling (3rd ed.)." Accessed 2026-02-28. <https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/books/data-warehouse-dw-toolkit/>

- **Type:** Book
- **Why relevant:** Provides dimensional modeling foundations — grain, facts, dimensions, SCD patterns — directly applicable to designing the permits fact table, district dimension, and zoning snapshot tables.

---

**[B2]** Kleppmann, Martin. 2017. "Designing Data-Intensive Applications." Accessed 2026-02-28. <https://dataintensive.net/>

- **Type:** Book
- **Why relevant:** Covers foundational data systems tradeoffs (consistency, storage engines, batch vs. stream) that inform architectural decisions throughout the pipeline.

---

**[B3]** Reis, Joe, and Matt Housley. 2022. "Fundamentals of Data Engineering." Accessed 2026-02-28. <https://mitpressbookstore.mit.edu/book/9781098108304>

- **Type:** Book
- **Why relevant:** Frames the end-to-end data engineering lifecycle, helping scope Month 1 deliverables and identify what is appropriately deferred to later months.

---

**[B5]** Karwin, Bill. 2010. "SQL Antipatterns." Accessed 2026-02-28. <https://www.oreilly.com/library/view/sql-antipatterns/9781680500073/>

- **Type:** Book
- **Why relevant:** Documents common schema and query mistakes centered on PK/FK/constraints — directly relevant to designing clean relational models for this warehouse.

---

**[B10]** Hsu, Leo S., and Regina O. Obe. 2021. "PostGIS in Action (3rd ed.)." Accessed 2026-02-28. <https://www.manning.com/books/postgis-in-action-third-edition>

- **Type:** Book
- **Why relevant:** Core reference for PostGIS spatial types, functions, and spatial joins — required before writing geometry-aware queries for district boundary assignment.

---

### Videos

**[V1]** Metabase. n.d. "How to Create a Dashboard (Getting Started)." Accessed 2026-02-28. <https://www.youtube.com/watch?v=W-i9E5_Wjmw>

- **Type:** Video
- **Why relevant:** Short walkthrough of building dashboards in Metabase — forward reference for the visualization layer.

---

**[V3]** Ramsey, Paul (Crunchy Data). n.d. "PostGIS Introduction." Accessed 2026-02-28. <https://www.youtube.com/live/g4DgAVCmiDE>

- **Type:** Video
- **Why relevant:** Conceptual overview of PostGIS and spatial querying — a visual primer for spatial data concepts before hands-on work begins.

---

**[V4]** MIT Missing Semester. 2026. "Version Control Lecture." Accessed 2026-02-28. <https://missing.csail.mit.edu/2026/version-control/>

- **Type:** Video
- **Why relevant:** Git workflows explained with practical demonstrations — companion video to D8 for building Git habits.

---

**[V5]** U.S. Census Bureau. 2023. "Discovering the ACS: Guidance for Data Users." Accessed 2026-02-28. <https://www.census.gov/library/video/2023/discovering-the-acs.html>

- **Type:** Video
- **Why relevant:** Census Bureau walkthrough of 1-year vs. 5-year estimates, MOE interpretation, and safe comparisons — supplements D1/D2 with worked examples.

---

### Datasets

**[S1]** City of Philadelphia / ArcGIS. n.d. "Planning Districts (Feature Layer)." Accessed 2026-03-05. <https://catalog.data.gov/dataset/planning-districts-6a446>

- **Type:** Dataset
- **Why relevant:** District spine for all rollup metrics; provides the 18-district geometry used to compute land-only area and assign permit, zoning, and ACS records to a district.

---

**[S2]** OpenDataPhilly. n.d. "L&I Building and Zoning Permits." Accessed 2026-03-05. <https://opendataphilly.org/datasets/licenses-and-inspections-building-and-zoning-permits/>

- **Type:** Dataset
- **Why relevant:** Primary physical change time series (2007+); requires event-date selection, geocoding quality checks, and category mapping before use in district-month rollups.

---

**[S3]** City of Philadelphia / ArcGIS. n.d. "Zoning Base Districts (vintages)." Accessed 2026-03-05. <https://catalog.data.gov/dataset/zoning-base-districts>

- **Type:** Dataset
- **Why relevant:** Annual zoning snapshots used for year-to-year churn and composition metrics; schema consistency across vintages must be validated before comparing years.

---

**[S4]** U.S. Census Bureau. n.d. "American Community Survey 5-Year Data." Accessed 2026-03-05. <https://data.census.gov/>

- **Type:** Dataset
- **Why relevant:** ACS demographic context at tract level — 5-year estimates only, non-overlapping periods only, per the ACS usage policy; used for district-level income and tenure proxies.

---

### Reference repos

**[R1]** DrivenData. n.d. "cookiecutter-data-science." Accessed 2026-02-28. <https://github.com/drivendataorg/cookiecutter-data-science>

- **Type:** Reference Repo
- **Why relevant:** Reference project structure patterns used to inform how this repo's folder layout and documentation conventions are organized.

---

**[R2]** dbt Labs. n.d. "jaffle-shop." Accessed 2026-02-28. <https://github.com/dbt-labs/jaffle-shop>

- **Type:** Reference Repo
- **Why relevant:** Reference documentation patterns for dbt projects — informs how to structure models and documentation in the Transform layer.

---

## Change log

| Date | Change description | Author |
| --- | --- | --- |
| 2026-02-28 | Initial format defined; D1 and D2 added (Task 2.2) | Farid |
| 2026-02-28 | Starter resource set added: B1-B5, B10, D3-D4, D8-D11, R1-R2, V1-V5 (Task 2.4) | Farid |
| 2026-03-03 | Added B13 (Spatial SQL, Forrest) — used as primary reading for Task 2.8 | Farid |
| 2026-03-05 | Added S1, S2, S3, S4 dataset entries (Task 5.9) | Farid |
| 2026-03-06 | Added D12 (CARTO PostgreSQL Connections docs) — cited in L&I permits source catalog | Farid |
| 2026-03-06 | Added D13 (CARTO SQL API docs) — access method reference for L&I permits source catalog | Farid |
