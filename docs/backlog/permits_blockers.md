# Permits Blocker List

**Author:** Farid
**Created:** 2026-03-15
**Status:** Active

Blockers and risks identified before permits implementation begins. Written after notebook EDA of the L&I permits ArcGIS endpoint — before any ingest code is committed. Ordered by dependency/risk: items that must be resolved before coding starts come first.

---

## B2 — WHERE clause has a typo in `systemofrecord` value

**Severity:** High (silent data quality risk — must fix before writing ingest code)
**Observed:** Notebook WHERE clause uses `systemofrecord = 'ECLPISE'` — missing the second 'E'. Should be `'ECLIPSE'`.
**Why:** If the filter matches nothing, `gpd.read_file()` returns an empty GeoDataFrame and `to_postgis()` writes an empty table without raising an error. The pipeline would appear to succeed while ingesting zero rows.
**Fix path:** Correct the value to `'ECLIPSE'` before writing the ingest script. Add a row count assertion (`assert len(gdf) > 0`) immediately after the fetch to catch empty returns.

---

## B1 — Fetch time is non-trivial

**Severity:** Medium (operational, not a data quality issue)
**Observed:** Filtered fetch (systemofrecord = ECLIPSE, status = Issued, last 10 years) took ~1.5 minutes at a batch size of 1000 rows/request. Total filtered set: 58,229 rows.
**Why:** The raw dataset is ~900k rows. The filtered set requires many paginated API calls. Offset-based pagination means each batch is a separate HTTP round-trip with no parallelism.
**Fix path:** Accepted for initial ingest — 1.5 min is tolerable for a one-time or periodic load. Document expected runtime in the ingest script. If re-runs become painful, evaluate increasing `resultRecordCount` to 5000 or partitioning by year.

---

## B3 — Geometry null rate measured: 2.1% (below threshold)

**Severity:** Low (measured, below R3 threshold — no action required before coding)
**Observed:** 1,246 of 58,229 filtered rows (2.1%) have null geometry. Permits use native ArcGIS geometry — no geocoding step needed.
**Why:** Null geometry rows cannot be assigned a district via point-in-polygon. They pass through staging and enter `fct_permits` with `district_id IS NULL`, excluded from all district-level rollups (per C5 in `docs/policies/map_first_readiness_contract.md`). At 2.1%, this is well below the R3 quality warning threshold of 10%.
**Fix path:** No blocking action needed. Document 2.1% as the baseline null rate in the permits QA checklist. Monitor in subsequent fetches — if null rate climbs above 10%, flag as a data quality risk.

---

## B4 — `typeofwork` has nulls; use `permittype` as primary category FK

**Severity:** Low (known, manageable)
**Observed:** At least one null value found in `typeofwork` during unique value scan. `permittype` is clean: 13 distinct values, no nulls.
**Why:** `typeofwork` is a granular sub-category (~60+ combinations) with constrained vocabulary but inconsistent completeness. Using it as a FK without null handling would break `not_null` dbt tests.
**Fix path:** Use `permittype` as the primary category dimension in staging and marts. `typeofwork` is available as a descriptive column for drill-down but should not carry a `not_null` test. Add a null count check for `typeofwork` to the permits QA checklist.

---

## Non-blockers (documented, no action needed before coding)

### District assignment for unmatched permits
Permits whose geometry falls outside all 18 district polygons receive `district_id IS NULL` and remain in `fct_permits` as auditable records. They do not contribute to district-level rollups. This is documented policy — see C5 and R3 in `docs/policies/map_first_readiness_contract.md`. No implementation decision needed here; follow the contract.

---

## Status summary

| ID | Description | Severity | Status |
|----|-------------|----------|--------|
| B2 | `'ECLPISE'` typo in WHERE clause | High | Must fix before ingest code |
| B1 | Fetch time ~1.5 min (58,229 rows) | Medium | Accepted — document runtime |
| B3 | Geometry null rate 2.1% (1,246 / 58,229) | Low | Below R3 threshold — log baseline in QA checklist |
| B4 | `typeofwork` nulls | Low | Use `permittype` as primary FK |
