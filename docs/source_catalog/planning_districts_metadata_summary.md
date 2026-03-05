# Planning Districts — Metadata Summary (S1)

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

---

## Dataset header

- **Dataset name:** Planning Districts (Philadelphia)
- **Dataset ID:** S1
- **Files analyzed:** `Planning_Districts.geojson` (data), `fields (1).json` (field metadata)
- **Reviewer:** Farid
- **Date:** 2026-03-05
- **MVP role:** District spine — reporting unit and spatial join target for all other datasets

---

## Geometry

- **Geometry types present:** Polygon (n=18)
- **Notes:** District boundary layer used as the spatial spine for district-first rollups. Each feature represents one planning district.

---

## Feature count

- **Number of features (rows):** 18 (matching the expected 18 Philadelphia planning districts)

---

## Fields

### Fields present in GeoJSON properties

| Field | Type | Notes |
|---|---|---|
| `objectid` | Numeric | 1–18, non-null, unique in extract |
| `dist_name` | Text | Full district name (e.g., "River Wards"), non-null, unique |
| `abbrev` | Text | Short abbreviation (e.g., "RW", "NDEL"), non-null, unique |
| `Shape__Area` | Numeric | Area in projected coordinate units (unit unconfirmed — likely sq ft or sq meters) |
| `Shape__Length` | Numeric | Perimeter length in projected units |

### Field types (from fields.json — official schema)

| Field | Type |
|---|---|
| `AREA` | Numeric |
| `DIST_NAME` | Text |
| `DIST_NUM` | Text |
| `LABEL` | Text |
| `OBJECTID` | Numeric |
| `OBJECTID_1` | Numeric |
| `SEQUENCE` | Text |

> **Schema vs. extract mismatch:** The official schema lists `DIST_NUM`, `LABEL`, `SEQUENCE`, and `OBJECTID_1`, but none of these appear in the GeoJSON extract. Conversely, `abbrev` and `Shape__Area`/`Shape__Length` appear in the GeoJSON but not in the official schema. This discrepancy should be resolved when connecting to the authoritative API source in Month 2.

---

## Candidate key / label fields (project-relevant)

- **Confirmed in extract:** `objectid` (numeric, 1–18, unique), `abbrev` (text, unique — likely equivalent to `LABEL` or `DIST_NUM` in the schema)
- **In official schema but not in extract:** `DIST_NUM` (preferred natural key per schema)
- **Display label (confirmed):** `dist_name`

### Quick completeness/uniqueness checks (in this extract)

| Field | Non-null | Unique count | Unique? |
|---|---|---|---|
| `dist_name` | 18/18 | 18 | Yes |
| `objectid` | 18/18 | 18 | Yes |
| `abbrev` | 18/18 | 18 | Yes |

---

## Update cadence

- **Update cadence info in provided metadata:** Not present in `fields (1).json` or GeoJSON metadata.
- **Working assumption for MVP:** Treat as slow-changing boundary spine; validate cadence/version against authoritative source during ingestion.

---

## Top risks

- **Schema/extract mismatch:** The GeoJSON extract is missing official schema fields (`DIST_NUM`, `LABEL`, `SEQUENCE`) and includes fields not in the schema (`abbrev`, `Shape__Area`, `Shape__Length`). The natural key strategy depends on which fields are actually available from the authoritative API source.
- **Area unit unknown:** `Shape__Area` is in projected CRS units (unit unconfirmed); cannot be used as a sq mi denominator without CRS validation. Land-only area must be derived after confirming CRS.
- **Boundary version uncertainty:** No update cadence or version information in the provided metadata; if boundaries have changed since the extract, rollup comparability could be affected.

---

## Links

- **Source dataset:** S1 (OpenDataPhilly — Planning Districts)
- **Source catalog entry:** [`docs/source_catalog/planning_districts.md`](./planning_districts.md)
- **Source reference:** [`docs/03_mvp_datasets.md`](../03_mvp_datasets.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
| 2026-03-05 | Fixed fields.json section (had L&I permits data); replaced with correct planning districts schema; added header block, top risks, links, change log | Farid |
