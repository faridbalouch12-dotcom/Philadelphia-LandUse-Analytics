# Checklist: District slice QA

**Author:** Farid
**Created:** 2026-03-15
**Status:** Active

Run this after any change to the district pipeline (raw ingest, staging model, or marts model). These are checks you would realistically rerun — not exhaustive, not automated.

---

## Automated checks (run first)

```bash
cd dbt/philly_dw
dbt test --select stg_planning_districts dim_district dim_date
```

- [ ] All dbt tests pass (6/6 for `dim_district`)
- [ ] `assert_18_districts` passes (row count = 18)

---

## Data checks

Run in Metabase SQL editor or psql:

```sql
SELECT count(*) FROM marts.dim_district;
```
- [ ] Count = 18

```sql
SELECT round(sum(land_area_sqmi)) FROM marts.dim_district;
```
- [ ] Sum ≈ 142 sqmi (Philadelphia total land area — should not drop below 140)

```sql
SELECT district_name, land_area_sqmi FROM marts.dim_district ORDER BY land_area_sqmi;
```
- [ ] No district has land_area_sqmi = 0 or NULL
- [ ] Smallest district (University Southwest ~5 sqmi) is not implausibly small

```sql
SELECT district_name, district_abbrev FROM marts.dim_district ORDER BY district_name;
```
- [ ] All 18 district names present and correctly spelled
- [ ] No duplicate names

---

## Geometry check

```sql
SELECT district_name, ST_IsValid(polygon_geometry) FROM marts.dim_district;
```
- [ ] All 18 rows return `true` for `ST_IsValid`

```sql
SELECT ST_SRID(polygon_geometry) FROM marts.dim_district LIMIT 1;
```
- [ ] SRID = 4326 (WGS 84 — confirms CRS transform from staging happened correctly)

---

## Baseline values (from 2026-03-15 verified run)

| Check | Expected |
|-------|----------|
| Row count | 18 |
| Total land area (rounded) | 142 sqmi |
| Smallest district | University Southwest, ~5 sqmi |
| Largest district | Lower Far Northeast, ~11 sqmi |
| SRID | 4326 |
