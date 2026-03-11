# Runbook: dbt docs site

**Author:** Farid
**Created:** 2026-03-11
**Status:** Active

---

## Prerequisites

- Docker stack running (`make up`)
- dbt connection verified (`dbt debug` passes)
- Run from `dbt/philly_dw/`

---

## Generate the docs

```bash
cd dbt/philly_dw
dbt docs generate
```

Expected output:

```
Found X data tests, 4 sources, N macros
Building catalog
Catalog written to .../target/catalog.json
```

`dbt docs generate` does two things:
- Builds `target/manifest.json` from the project code (models, sources, tests)
- Builds `target/catalog.json` by introspecting the live database for column types and row counts

The catalog requires a live database connection. If raw tables haven't been ingested yet, source nodes will appear but column type fields will be empty.

---

## Serve the docs locally

In a separate terminal (this command blocks):

```bash
cd dbt/philly_dw
dbt docs serve
```

Opens at: `http://localhost:8080`

---

## Navigating the docs site

**To find a source table:**
- Left nav → Project tab → Sources → `open_data_philly` → select a table
- Or: search bar → type the table name (e.g. `li_permits`)

**To view the lineage graph:**
- Open any node → expand the Lineage Graph panel (top right)
- Source nodes appear as circles; model nodes as rectangles

**What to verify after first generate:**
- All 4 source tables appear under `open_data_philly`: `planning_districts`, `li_permits`, `zoning_base_districts_2025`, `acs_tract_2025`
- Descriptions from `src_*.yml` render on each source page
- Data tests (`not_null`, `unique`) appear under "Referenced By > Data Tests" on each source

---

## Troubleshooting

**`Catalog not found` warning**
Run `dbt docs generate` before `dbt docs serve`. The serve command needs the generated catalog.

**Port 8080 already in use**
```bash
dbt docs serve --port 8081
```

**Column types missing**
Raw tables haven't been ingested yet. Column descriptions from YAML still render; type info requires live table introspection.
