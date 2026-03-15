# Planning Districts — Raw QA

**Author:** Farid
**Created:** 2026-03-14
**Last Updated:** 2026-03-14
**Status:** Draft

---

## Row Count

| Check | Expected | Actual | Status |
|-------|----------|--------|--------|
| Total rows in `raw.planning_districts` | 18 (one per planning district) | 18 | PASS |

Source evidence: Philadelphia has exactly 18 planning districts. Confirmed at API level (GeoDataFrame) and in-database (`SELECT COUNT(*) FROM raw.planning_districts`).

---

## Key Fields

| Field | Role | Unique? | Non-null? | Notes |
|-------|------|---------|-----------|-------|
| `objectid` | Natural key | Yes (18/18) | Yes (18/18) | `DIST_NUM` is absent from the API response. `objectid` is stable for 18 static districts; will be renamed to `dist_num` in intermediate layer as a self-assigned convenience key. |
| `dist_name` | Display label | Yes (18/18) | Yes (18/18) | Full district name. |
| `abbrev` | Short label | Yes (18/18) | Yes (18/18) | Abbreviation for charts and map tooltips. |

**Business key decision:** `objectid` is the sole candidate. No official Philadelphia district numbering system exists.

---

## Geometry

| Check | Result |
|-------|--------|
| Geometry present? | Yes — all 18 rows |
| Geometry type | Polygon / MultiPolygon |
| Null geometries | 0 |
| Invalid geometries | 0 |
| Overlapping boundaries | None observed |

---

## CRS / SRID

| Check | Result |
|-------|--------|
| Source CRS (API level) | EPSG:4326 (WGS 84) — confirmed via `gdf.crs` |
| In-database SRID | 4326 — confirmed via `SELECT ST_SRID(geometry) FROM raw.planning_districts` (all 18 rows) |
| SRID preserved by `to_postgis()`? | Yes |
| Reprojection needed? | Yes — EPSG:2272 (PA State Plane South) for area calculations. Deferred to staging/intermediate layer. |

**What is known:** CRS is EPSG:4326 at both API and DB level.
**What is inferred:** Nothing — CRS is explicitly confirmed at both layers.
**What still needs verification:** Area computation accuracy after reprojection to EPSG:2272 (Day 31).

---

## Fields Present in Raw Table

| Column | Type | Notes |
|--------|------|-------|
| `objectid` | integer | Natural key |
| `dist_name` | text | Full name |
| `abbrev` | text | Short label |
| `Shape__Area` | float | Source-provided area — units undocumented, will not be used as denominator |
| `Shape__Length` | float | Source-provided perimeter — not needed for MVP |
| `geometry` | geometry | Polygon/MultiPolygon, SRID 4326 |

---

## Links

- **Extract plan:** `docs/runbooks/planning_districts_extract_plan.md`
- **Critical fields dictionary:** `docs/data_dictionary/planning_districts_critical_fields.md`
- **Land-area denominator policy:** `docs/policies/land_area_denominator_policy.md`
- **Limitations register entries:** L1 (boundary versioning), L2 (near-boundary ambiguity), L11 (land-only area derivation)
