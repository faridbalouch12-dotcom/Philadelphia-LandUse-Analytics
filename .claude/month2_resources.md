# Resources Reference — Month 2

This file contains the curated books, official documentation, reference repos, and optional video/interactive resources for Month 2.

Use the IDs in `month2_syllabus.md`.

## How to use this file
- Prioritize **official docs** first for setup, configuration, and syntax.
- Use **books** for concepts and tradeoffs, not as the first place to look up command syntax.
- Use **reference repos** to study structure and conventions, not to copy blindly.
- Use **videos/interactive resources** only when a concept is still fuzzy after reading.

---

## Books (B)

| ID | Title | Author/Org | URL | Why it matters |
|----|-------|------------|-----|----------------|
| B1 | The Data Warehouse Toolkit (3rd ed.) | Ralph Kimball, Margy Ross | https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/books/data-warehouse-dw-toolkit/ | Still the most useful book here for grain, facts, dimensions, surrogate keys, SCD patterns, and why marts break when modeling is sloppy. |
| B2 | Fundamentals of Data Engineering | Joe Reis, Matt Housley | https://mitpressbookstore.mit.edu/book/9781098108304 | Strong end-to-end framing for ingestion, transformation, orchestration, quality, and platform tradeoffs. Good reality check against overbuilding. |
| B3 | PostgreSQL: Up and Running | Regina Obe, Leo Hsu | https://www.oreilly.com/library/view/postgresql-up-and/9781491963401/ | Practical Postgres reference for schemas, permissions, indexes, loading, and day-to-day usage. |
| B4 | PostGIS in Action (3rd ed.) | Leo S. Hsu, Regina O. Obe | https://www.manning.com/books/postgis-in-action-third-edition | The most project-relevant spatial implementation book in this stack. Use for SRIDs, spatial joins, area calculations, and performance. |
| B5 | SQL Antipatterns | Bill Karwin | https://www.oreilly.com/library/view/sql-antipatterns/9781680500073/ | Good for avoiding bad keys, fragile schemas, and awkward “shortcut” SQL that causes downstream warehouse pain. |
| B6 | The Art of PostgreSQL | Dimitri Fontaine | https://theartofpostgresql.com/ | Strong practical SQL and Postgres design guidance once you have the basics working. |
| B7 | Designing Data-Intensive Applications | Martin Kleppmann | https://dataintensive.net/ | Broader systems thinking: reliability, correctness, storage tradeoffs, and data system design principles. |
| B8 | Architecture Patterns with Python | Harry Percival, Bob Gregory | https://www.oreilly.com/library/view/architecture-patterns-with/9781492052197/ | Useful when the pipeline code grows and you need cleaner structure, boundaries, and testability. |
| B9 | Data Pipelines Pocket Reference | James Densmore | https://www.oreilly.com/library/view/data-pipelines-pocket/9781492087823/ | Short, practical framing for pipeline design, failure modes, and reproducibility. |

---

## Documentation / Articles (D)

| ID | Title | Author/Org | URL | Why it matters |
|----|-------|------------|-----|----------------|
| D1 | Multi-container applications | Docker Docs | https://docs.docker.com/get-started/docker-concepts/running-containers/multi-container-applications/ | Best conceptual starting point for why your project should use multiple containers instead of ad hoc local installs. |
| D2 | Docker Compose quickstart | Docker Docs | https://docs.docker.com/compose/gettingstarted/ | Hands-on guide for standing up a Compose-based local stack. |
| D3 | Docker build best practices | Docker Docs | https://docs.docker.com/build/building/best-practices/ | Helps you avoid slow, bloated, or fragile images. |
| D4 | Volumes | Docker Docs | https://docs.docker.com/engine/storage/volumes/ | Required reading before you decide what data should persist across container rebuilds. |
| D5 | Compose file reference | Docker Docs | https://docs.docker.com/reference/compose-file/ | Canonical reference for service definitions, healthchecks, env files, volumes, and networks. |
| D6 | PostgreSQL constraints | PostgreSQL | https://www.postgresql.org/docs/current/ddl-constraints.html | The authoritative source for PK, UK, FK, CHECK, and NOT NULL behavior. |
| D7 | PostgreSQL schemas | PostgreSQL | https://www.postgresql.org/docs/current/ddl-schemas.html | Needed for designing `raw`, `staging`, `marts`, and `analytics` cleanly. |
| D8 | PostgreSQL indexes | PostgreSQL | https://www.postgresql.org/docs/current/indexes.html | Use once performance problems appear; do not guess blindly. |
| D9 | Populating a database | PostgreSQL | https://www.postgresql.org/docs/current/populate.html | Practical loading guidance that matters when you start landing larger tables. |
| D10 | PostGIS manual | PostGIS Project | https://postgis.net/docs/ | Primary reference for spatial types, functions, indexing, and SRID handling. |
| D11 | How do I use spatial indexes? | PostGIS Project | https://postgis.net/documentation/faq/spatial-indexes/ | Concise explanation of when and how spatial indexes matter. |
| D12 | ST_Transform | PostGIS Project | https://postgis.net/docs/ST_Transform.html | Essential for correct CRS transformations before area and distance calculations. |
| D13 | ST_Area | PostGIS Project | https://postgis.net/docs/ST_Area.html | Required for defensible area calculations in the zoning and district geometry workflows. |
| D14 | Reading and writing files | GeoPandas | https://geopandas.org/en/stable/docs/user_guide/io.html | Helpful for reading FeatureServer exports, GeoJSON, GeoPackage, and shapefiles into Python. |
| D15 | Basic module usage | psycopg | https://www.psycopg.org/psycopg3/docs/basic/usage.html | Cleanest starting point for Python ↔ Postgres reads/writes without unnecessary abstraction. |
| D16 | SQLAlchemy unified tutorial | SQLAlchemy | https://docs.sqlalchemy.org/en/20/tutorial/ | Use only if you choose SQLAlchemy intentionally for connection/session management; do not adopt it by default just because it exists. |
| D17 | What is dbt? | dbt Developer Hub | https://docs.getdbt.com/docs/introduction | Good overview of what dbt should and should not own in your stack. |
| D18 | Add sources to your DAG | dbt Developer Hub | https://docs.getdbt.com/docs/build/sources | Required for declaring raw tables properly before building staging models. |
| D19 | Add data tests to your DAG | dbt Developer Hub | https://docs.getdbt.com/docs/build/data-tests | Core reference for uniqueness, not-null, accepted-values, and relationship tests. |
| D20 | About documentation | dbt Developer Hub | https://docs.getdbt.com/docs/build/documentation | Required for making the dbt project reviewable, not just runnable. |
| D21 | How we structure our dbt projects | dbt Developer Hub | https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview | Good default structure guidance so your dbt project does not turn into one flat SQL pile. |
| D22 | Staging: Preparing our atomic building blocks | dbt Developer Hub | https://docs.getdbt.com/best-practices/how-we-structure/2-staging | Strong practical guidance for staging model naming and responsibilities. |
| D23 | Marts: Business-defined entities | dbt Developer Hub | https://docs.getdbt.com/best-practices/how-we-structure/4-marts | Directly relevant to your metric tables and analyst-facing layer. |
| D24 | Get started | pytest | https://docs.pytest.org/en/stable/getting-started.html | Minimal testing reference for your Python loaders and validators. |
| D25 | Building and testing Python | GitHub Docs | https://docs.github.com/en/actions/tutorials/build-and-test-code/python | Use for setting up a small CI workflow that runs tests and catches breakage early. |
| D26 | Running Metabase on Docker | Metabase | https://www.metabase.com/docs/latest/installation-and-operation/running-metabase-on-docker | Fastest route to a local BI layer in the same stack. |
| D27 | Models | Metabase Documentation | https://www.metabase.com/docs/latest/data-modeling/models | Useful once you want reusable analyst-facing tables without cluttering the warehouse. |
| D28 | Census Data API User Guide | U.S. Census Bureau | https://www.census.gov/data/developers/guidance/api-user-guide.html | Canonical reference for ACS API usage, parameters, and request patterns. |
| D29 | American Community Survey 5-Year Data (2009-2024) | U.S. Census Bureau | https://www.census.gov/data/developers/data-sets/acs-5year.html | Official ACS 5-year dataset entry point for variables, examples, and endpoint structure. |
| D30 | Query (Feature Service/Layer) | Esri Developer | https://developers.arcgis.com/rest/services-reference/enterprise/query-feature-service-layer/ | Required for reliable extraction from ArcGIS FeatureServer endpoints, especially pagination and field selection. |

---

## Reference Repos (R)

| ID | Title | Author/Org | URL | Why it matters |
|----|-------|------------|-----|----------------|
| R1 | jaffle-shop | dbt Labs | https://github.com/dbt-labs/jaffle-shop | Best small dbt reference repo for sources, staging, marts, tests, and docs. |
| R2 | dbt-project-evaluator | dbt Labs | https://github.com/dbt-labs/dbt-project-evaluator | Useful after your project exists; it shows what “healthy dbt project structure” looks like. |
| R3 | cookiecutter-data-science | DrivenData | https://github.com/drivendataorg/cookiecutter-data-science | Reference only for folder structure and project hygiene. |
| R4 | awesome-compose | Docker | https://github.com/docker/awesome-compose | Good place to look at Compose patterns without inventing everything from scratch. |

---

## Videos / Interactive Resources (V)

| ID | Title | Author/Org | URL | Why it matters |
|----|-------|------------|-----|----------------|
| V1 | dbt Learn | dbt Labs | https://www.getdbt.com/dbt-learn | Official interactive entry point if the docs alone feel too abstract. |
| V2 | Learn Metabase | Metabase | https://www.metabase.com/learn/ | Guided walkthroughs for questions, dashboards, and models. |
| V3 | PostGIS Introduction | Crunchy Data / Paul Ramsey | https://www.youtube.com/live/g4DgAVCmiDE | Helpful visual primer for PostGIS mental models before you implement spatial joins. |
| V4 | Version control lecture | MIT Missing Semester | https://missing.csail.mit.edu/2026/version-control/ | Good refresher when your branch/PR discipline starts slipping. |
| V5 | Census API video tutorials hub | U.S. Census Bureau | https://www.census.gov/data/developers/guidance/api-user-guide.html | Use when the API docs feel too dry and you need examples. |
| V6 | Metabase getting started guides | Metabase | https://www.metabase.com/learn/ | Useful during dashboard assembly at the end of the month. |

---

## Suggested default reading order

### Before writing code
- B1
- D1, D2, D5
- D6, D7
- D17, D21

### Before building geospatial pieces
- B4
- D10, D11, D12, D13, D14, D30

### Before building dbt models
- D18, D19, D20, D22, D23
- R1

### Before CI and tests
- D24, D25
- B8 (selected chapters only)

### Before ACS implementation
- D28, D29
- Re-read Month 1 ACS policy and notes first