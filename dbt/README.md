# dbt models for philly_dw

philly_dw is a data warehouse to analyze zoning and permitting in Philadelphia. The dbt models transform raw data from OpenDataPhilly's APIs into a zoning and permitting model ready for analytics.

## Raw sources

The following raw tables are expected in the `raw` schema, loaded via Python ingestion:

| Table | Source |
|-------|--------|
| `raw.planning_districts` | ArcGIS FeatureServer |
| `raw.li_permits` | CARTO SQL API |
| `raw.zoning_base_districts_YEAR` | ArcGIS FeatureServer (5 vintages) |
| `raw.acs_tract_PERIOD` | Census Bureau API |

## Models

### Staging (`models/staging/`)

Light cleaning and renaming of raw source tables. One `stg_*` model per source — column renames, type standardization, CRS validation. No business logic.

### Intermediate (`models/intermediate/`)

Pipeline-only transforms: spatial joins, area computations, vocabulary crosswalk application. These models exist to break complex logic into steps. Never queried directly by analysts.

### Marts (`models/marts/`)

The star schema — conformed dimensions (`dim_district`, `dim_date`, `dim_zoning`), fact tables (`fct_permits`, `fct_district_year_zoning_composition`, `fct_tract_acs`), the spatial bridge (`bridge_tract_district_overlap`), and the geometry table (`geo_district_boundaries`). This is the primary query layer.

### Analytics (`models/analytics/`)

Pre-aggregated rollups for dashboard consumption. Currently: `agg_district_acs_attributes_hist` — tract-count histograms per district per ACS attribute, used for distribution charts in Metabase.

## Running the project

See [docs/runbooks/dbt_local_setup.md](../../docs/runbooks/dbt_local_setup.md) for full setup instructions.

Quick reference:

```bash
cd dbt/philly_dw
dbt debug        # verify connection
dbt run          # run all models
dbt test         # run all tests
dbt docs serve   # browse the docs site
```
