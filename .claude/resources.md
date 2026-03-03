# Resource Library — Month 1

All resources are referenced by ID throughout the syllabus. Use this file to resolve any resource ID when tutoring or grading.

---

## Books (B)

| ID | Title | Author/Org | URL | Why it matters |
|----|-------|------------|-----|----------------|
| B1 | The Data Warehouse Toolkit (3rd ed.) | Ralph Kimball, Margy Ross | https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/books/data-warehouse-dw-toolkit/ | Dimensional modeling foundations: grain, facts, dimensions, SCD patterns. Read chapters on grain/facts early. |
| B2 | Designing Data-Intensive Applications (DDIA) | Martin Kleppmann | https://dataintensive.net/ | Foundational tradeoffs: consistency, storage engines, batch/stream, distributed systems. Great for DE systems thinking. |
| B3 | Fundamentals of Data Engineering | Joe Reis, Matt Housley | https://mitpressbookstore.mit.edu/book/9781098108304 | End-to-end DE lifecycle framing; helps you scope systems and tradeoffs. Use for lifecycle + governance concepts. |
| B4 | Database Internals | Alex Petrov | https://www.oreilly.com/library/view/database-internals/9781492040330/ | Storage engines, indexes, WAL, and distributed DB internals. Good for understanding Postgres under the hood. |
| B5 | SQL Antipatterns | Bill Karwin | https://www.oreilly.com/library/view/sql-antipatterns/9781680500073/ | Common schema/query mistakes; strong for PK/FK/constraints thinking. Skim Part I early. |
| B6 | PostgreSQL: Up and Running (3rd ed.) | Regina Obe, Leo Hsu | https://www.oreilly.com/library/view/postgresql-up-and/9781491963401/ | Practical Postgres roles, schemas, constraints, and ops basics. Use later for ops + tuning. |
| B7 | The Pragmatic Programmer (20th Anniversary) | David Thomas, Andrew Hunt | https://www.pragmaticprogrammers.com/titles/tpp20/ | SWE habits: maintainability, DRY, automation, debugging. Supports 'scalable code' gap. |
| B8 | Clean Code | Robert C. Martin | https://www.pearson.com/en-us/subject-catalog/p/clean-code | Naming, functions, cohesion, error handling, test mindset. |
| B9 | Refactoring (2nd ed.) | Martin Fowler | https://martinfowler.com/books/refactoring.html | How to change code safely; refactorings + importance of tests. |
| B10 | PostGIS in Action (3rd ed.) | Leo S. Hsu, Regina O. Obe | https://www.manning.com/books/postgis-in-action-third-edition | Spatial types/functions, performance, real-world GIS tasks in PostGIS. Core for map-ready DB thinking. |
| B11 | The Art of PostgreSQL | Dimitri Fontaine | https://theartofpostgresql.com/ | Advanced SQL thinking & query design in Postgres. |
| B12 | Architecture Patterns with Python | Harry Percival, Bob Gregory | https://books.apple.com/us/book/architecture-patterns-with-python/ | When to use patterns/OOP; testing as design tool. Read later, after basics. |
| B13 | Spatial SQL: A Practical Approach to Modern GIS Using SQL | Matthew Forrest | https://locatepress.com/book/spatial-sql | Practical PostGIS: geometry types, spatial joins, spatial indexing. Used for Task 2.8 spatial primer. |

---

## Documentation / Articles (D)

| ID | Title | Author/Org | URL | Why it matters |
|----|-------|------------|-----|----------------|
| D1 | Period Estimates in the American Community Survey | U.S. Census Bureau | https://www.census.gov/newsroom/blogs/random-samplings/2022/03/period-estimates-american-community-survey.html | Explains multi-year ACS period estimates and interpretation. Key for demographic trend caveats. |
| D2 | Comparing ACS Data | U.S. Census Bureau | https://www.census.gov/programs-surveys/acs/guidance/comparing-acs-data.html | Guidance on comparing ACS estimates over time (incl. non-overlapping). Use for safe comparisons. |
| D3 | PostGIS Manual: Introduction | PostGIS Project | https://postgis.net/docs/manual-2.5/postgis_introduction.html | Conceptual intro to PostGIS and spatial types. Version may differ; concepts stable. |
| D4 | PostGIS FAQ: Spatial Indexes | PostGIS Project | https://postgis.net/documentation/faq/spatial-indexes/ | High-level explanation of spatial indexes and performance. Good mental model for later tuning. |
| D5 | Creating a Pull Request Template | GitHub Docs | https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository | How to add PR templates in repos. Used in Week 1. |
| D6 | About issue & pull request templates | GitHub Docs | https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/about-issue-and-pull-request-templates | How issue/PR templates work in GitHub. Used in Week 1. |
| D7 | What to look for in a code review | Google Engineering Practices | https://google.github.io/eng-practices/review/reviewer/looking-for.html | Concrete checklist for reviewing changes. Use to self-review your docs. |
| D8 | Version Control (Git) | MIT Missing Semester | https://missing.csail.mit.edu/2026/version-control/ | Practical Git workflows and concepts. Great for building Git muscle. |
| D9 | Learn Metabase | Metabase | https://www.metabase.com/learn/ | Metabase concepts & modeling guides. Future reference for BI layer. |
| D10 | dbt Learn (dbt Fundamentals course overview) | dbt Labs | https://www.getdbt.com/dbt-learn | Official training entry point; overview of sources, testing, docs, deployment. |
| D11 | PostgreSQL Docs: Constraints (PK, UK, FK) | PostgreSQL.org | https://www.postgresql.org/docs/current/ddl-constraints.html | Authoritative definitions for primary keys, unique constraints, and foreign keys. Use for modeling policies. |
| D12 | About protected branches | GitHub Docs | https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches | How branch protection works and what settings mean. |
| D13 | Managing labels | GitHub Docs | https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels | How to create/manage labels for issues/PRs. |
| D14 | Creating a release | GitHub Docs | https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository | How to create releases and tags. |
| D15 | Ignoring files | GitHub Docs | https://docs.github.com/en/get-started/getting-started-with-git/ignoring-files | How .gitignore works and patterns. |
| D16 | OpenDataPhilly — About | OpenDataPhilly | https://opendataphilly.org/about/ | Context on the portal and dataset access. For dataset cataloging approach. |
| D17 | ArcGIS REST API — Feature Service basics | Esri | https://developers.arcgis.com/rest/services-reference/enterprise/feature-service/ | Understand FeatureServer endpoints & fields conceptually. Reference-only. |
| D18 | Data engineering lifecycle (excerpt/overview page) | Joe Reis / O'Reilly excerpt | https://www.oreilly.com/library/view/fundamentals-of-data/9781098108298/ | Use as conceptual framing for scoping and lifecycle. |

---

## Datasets (S)

| ID | Title | Author/Org | URL | Why it matters |
|----|-------|------------|-----|----------------|
| S1 | Planning Districts (Feature Layer) | City of Philadelphia / ArcGIS | https://catalog.data.gov/dataset/planning-districts-6a446 | District spine (18 districts). Use land-only area from this. |
| S2 | L&I Building and Zoning Permits | OpenDataPhilly | https://opendataphilly.org/datasets/licenses-and-inspections-building-and-zoning-permits/ | Primary physical change time series (2007+). Very large dataset; note cadence. |
| S3 | Zoning Base Districts (vintages) | City of Philadelphia / ArcGIS | https://catalog.data.gov/dataset/zoning-base-districts | Zoning snapshots by year for year-to-year churn/composition. Check schema consistency across years. |

---

## Reference Repos (R)

| ID | Title | Author/Org | URL | Why it matters |
|----|-------|------------|-----|----------------|
| R1 | cookiecutter-data-science | DrivenData | https://github.com/drivendataorg/cookiecutter-data-science | Reference structure patterns (folders, docs, etc.). Reference only. |
| R2 | jaffle-shop | dbt Labs | https://github.com/dbt-labs/jaffle-shop | Reference doc patterns for dbt projects. Reference only. |

---

## Videos (V)

| ID | Title | Author/Org | URL | Why it matters |
|----|-------|------------|-----|----------------|
| V1 | How to create a dashboard (Getting started) | Metabase (YouTube) | https://www.youtube.com/watch?v=W-i9E5_Wjmw | Short overview of building dashboards in Metabase. Good for later. |
| V2 | Metabase for beginners (event) | Metabase | https://www.metabase.com/events/metabase-for-beginners | Intro walkthrough of Metabase instance + first dashboards. |
| V3 | PostGIS Introduction (Paul Ramsey) | Crunchy Data (YouTube) | https://www.youtube.com/live/g4DgAVCmiDE | Conceptual overview of PostGIS and spatial querying. Good primer. |
| V4 | Version control lecture (Missing Semester) | MIT Missing Semester | https://missing.csail.mit.edu/2026/version-control/ | Git workflows explained with practical demos. Watch alongside doing tasks. |
| V5 | Discovering the ACS: Guidance for data users | U.S. Census Bureau | https://www.census.gov/library/video/2023/discovering-the-acs.html | When to use 1-year vs 5-year, comparing estimates, MOE. Great ACS caveats. |
| V6 | Data 101: The American Community Survey | Population Reference Bureau (PRB) | https://www.prb.org/resources/video-data-101-tutorials-on-the-american-community-survey/ | Intro series; reliability + MOE concepts. Secondary ACS resource. |
| V7 | Branch protection rules overview | GitHub (YouTube) | https://www.youtube.com/watch?v=K67wYvYq8lA | Overview of branch protection concepts and settings. Optional. |
| V8 | (dbt/Mermaid resources — to be added in Week 3/4) | — | — | Supplement for Week 3 modeling and Week 4 diagrams. |
| V9 | (Mermaid ERD diagramming — to be added) | — | — | For Task 16.1 ERD diagram in Mermaid. |
