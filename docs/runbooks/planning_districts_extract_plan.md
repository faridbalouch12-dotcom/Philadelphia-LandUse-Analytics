# Planning Districts — Extract Plan

**Author:** Farid
**Created:** 2026-03-14
**Status:** Draft

---

## Source Endpoint

- **URL:** `https://hub.arcgis.com/api/v3/datasets/0960ea0f38f44146bb562f2b212075aa_0/downloads/data?format=geojson&spatialRefId=4326&where=1%3D1`
- **Type:** ArcGIS Hub download — returns GeoJSON
- **Access method:** HTTP GET, no authentication required

---

## Expected Response

- **Row count:** 18 (one row per planning district)
- **Response format:** GeoJSON (FeatureCollection with polygon geometries)

---

## Fields Available at Source

| Field | Keep? | Notes |
|-------|-------|-------|
| `objectid` | Yes | Natural key — unique, non-null; `DIST_NUM` is absent from API response |
| `dist_name` | Yes | Full district name; display label |
| `abbrev` | Yes | Short district label; useful for charts and map tooltips |
| `Shape__Area` | No | Unit unknown; will derive `land_area_sqmi` from geometry instead |
| `Shape__Length` | No | Not needed for MVP |
| `geometry` | Yes | Polygon geometries; all 18 rows present, no nulls or invalids |

---

## CRS

- **Source CRS:** EPSG:4326 (WGS 84 — geographic, degrees)
- **Raw data stored as-is** in EPSG:4326; no transformation at ingestion
- **Reprojection to EPSG:2272** (Pennsylvania State Plane South) deferred to staging/intermediate layer for area computation

---

## Key Decisions

- `objectid` used as natural key and will be renamed to `dist_num` in the intermediate layer. Philly planning districts have no official numeric identifier; `dist_num` is a self-assigned convenience key.
- `Shape__Area` and `Shape__Length` dropped downstream — units are not documented by the source; `land_area_sqmi` will be derived from geometry in a standardized projected CRS.
- Raw snapshot stored immutably; all field filtering, renaming, and CRS transformation happen in intermediate/staging.

---

## Geometry QA (pre-load)

- All 18 rows have valid, non-null geometries
- No overlapping boundaries observed
- Geometry type: Polygon / MultiPolygon

---

## Links

- **Source catalog:** `docs/source_catalog/planning_districts.md`
- **Critical fields dictionary:** `docs/data_dictionary/planning_districts_critical_fields.md`
- **Land-area denominator policy:** `docs/policies/land_area_denominator_policy.md`
