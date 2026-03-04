# Data access notes

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Status:** Draft

---

## Purpose

This document records the chosen access mode for each MVP dataset, the rationale for that choice, update cadence, and any size or access warnings. The goal is to prevent later surprises about data volume, format compatibility, or pipeline complexity when ingestion begins in Month 2.

---

## Scope

**In Scope:** Access decisions for the four MVP datasets defined in [03_mvp_datasets.md](./03_mvp_datasets.md).

**Out of Scope:** Actual pipeline implementation, authentication setup, and pagination logic — deferred to Month 2.

---

## Access decisions

### 1. Planning districts (S1)

| Field | Detail |
|-------|--------|
| **Available formats** | GeoJSON, CSV, SHP (Esri Open Data Portal); live API query (ArcGIS AGO); GeoService |
| **Chosen access mode** | ArcGIS FeatureServer API (AGO), GeoJSON format, fetched at pipeline runtime |
| **Why** | 18 static polygons — small enough to fetch at runtime. GeoJSON preserves polygon geometry and loads directly into PostGIS via geopandas without ESRI dependencies. Fetching via API avoids committing a data file to the repo, which would conflict with the data storage policy. AGO is the official City-maintained source. |
| **Update cadence** | No regular cycle; marked "as needed." Boundaries last updated 2015-05-26. Treated as static for MVP. |
| **Size warning** | None — 18 features, negligible payload. |

---

### 2. L&I building and zoning permits (S2)

| Field | Detail |
|-------|--------|
| **Available formats** | GeoJSON, CSV, SHP (Esri Open Data Portal); live API query (ArcGIS AGO); CSV, SHP, GeoJSON, API (Carto) |
| **Chosen access mode** | Carto SQL API, CSV format, with a date filter limiting to the last 5 years |
| **Why** | Full history (2007–present) is 500k+ rows — pulling the entire dataset at runtime is impractical. A date filter on the Carto SQL API reduces the payload to a manageable window. CSV format is sufficient because permit location is captured as lat/lng columns (`ST_Y(the_geom) AS lat, ST_X(the_geom) AS lng`); geometry can be reconstructed as PostGIS points in the pipeline. GeoJSON is not needed for raw ingest. |
| **Update cadence** | Updated daily. Pipeline should be designed for incremental loads in Month 2. |
| **Size warning** | **Large dataset.** Even filtered to 5 years, the result set may be large. The Carto API does not paginate automatically — the pipeline will need to handle chunked requests or set explicit row limits. Full history (2007–present) is explicitly out of scope for MVP. |

---

### 3. Zoning base districts (S3)

| Field | Detail |
|-------|--------|
| **Available formats** | GeoJSON, CSV, SHP (Esri Open Data Portal); live API query (ArcGIS AGO) |
| **Chosen access mode** | ArcGIS FeatureServer API (AGO), GeoJSON format, one request per vintage year |
| **Why** | Each vintage year is a separate layer with its own endpoint. The pipeline must iterate over a hardcoded list of years, fetching GeoJSON from each endpoint in turn. GeoJSON preserves polygon geometry needed for spatial analysis. Same reasoning as S1 — no file committed, geometry preserved, AGO is the official source. |
| **Update cadence** | Annual vintage snapshots. MVP scope: 2020–2025 (5 separate API calls). |
| **Size warning** | Each vintage is a full snapshot of all zoning polygons citywide. Not as large as S2, but 5 separate full-layer fetches — worth monitoring load time during pipeline development. |

---

### 4. ACS demographic context

| Field | Detail |
|-------|--------|
| **Available formats** | Census Bureau ACS API (tabular JSON); Census TIGER/Line API (boundaries, GeoJSON/SHP) |
| **Chosen access mode** | Two separate API calls: (1) Census Bureau ACS API for tabular demographic data; (2) Census TIGER/Line API for census tract boundaries (GeoJSON). Joined in pipeline on GEOID. |
| **Why** | The ACS API is optimized for tabular data and returns a GEOID column identifying each tract. TIGER/Line is the authoritative Census Bureau source for tract boundary geometry. Separating the two calls keeps each source responsible for what it does best, and the GEOID join is standard Census practice. |
| **Update cadence** | New 5-year estimates released annually, but valid comparisons require non-overlapping windows. **MVP windows: 2015-2019 and 2020-2024** (one ACS API call per window). TIGER/Line tract boundaries are fetched once. |
| **Size warning** | Modest payload — Philadelphia county census tracts only (~384 tracts). No pagination concerns. |
| **Important limitation** | Annual tract-level estimates for income/tenure variables do not exist from the Census Bureau — tracts (~4,000 people) are too small for reliable 1-year estimates. ACS is therefore used as **context only**, not for year-over-year trend analysis. This is a known limitation documented in the limitations register. |
| **Alternatives considered** | IPUMS NHGIS annual tract estimates were explored but only cover age/race/sex through 2019 — insufficient for income/tenure variables. IPUMS API considered but adds account/key complexity for MVP with no benefit over direct Census API. Deferred for future consideration. |

---

## References

- **[S1]** City of Philadelphia / ArcGIS. *Planning Districts (Feature Layer)*. See [Resources](../.claude/resources.md) for full details.
- **[S2]** OpenDataPhilly. *L&I Building and Zoning Permits*. See [Resources](../.claude/resources.md) for full details.
- **[S3]** City of Philadelphia / ArcGIS. *Zoning Base Districts*. See [Resources](../.claude/resources.md) for full details.
- **[D1]** U.S. Census Bureau. *Period Estimates in the American Community Survey*. See [Resources](../.claude/resources.md) for full details.
- **[D17]** Esri. *ArcGIS REST API — Feature Service basics*. See [Resources](../.claude/resources.md) for full details.

---

## Links

**Related documents:**
- [MVP datasets](./03_mvp_datasets.md)
- [Data storage policy](./policies/data_storage_policy.md)
- [Limitations register](./limitations_register.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-03 | Initial draft      | Farid  |
