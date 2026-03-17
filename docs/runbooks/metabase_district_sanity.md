# Runbook: Metabase district sanity question

**Author:** Farid
**Created:** 2026-03-15
**Status:** Active

---

## Purpose

A saved Metabase question that validates the district slice at a glance. Used as a lightweight smoke test after any re-run of the district pipeline — if the question looks wrong, something upstream broke.

---

## The question

**Location:** Philly_DW → marts → Dim District
**Question name:** Sum of Land Area Sqmi (grouped by District Name)

**Expression:**

```
round(sum([Land Area Sqmi]))
```

Grouped by: `District Name`

---

## Expected output

18 rows — one per planning district — with rounded land area in square miles.

| Check | Expected |
|-------|----------|
| Row count | 18 |
| Sum of all areas | ~142 sqmi (Philadelphia total land area) |
| Minimum area | > 0 for all rows |
| District names | All 18 Philadelphia planning districts present |

**Observed output (2026-03-15):**

| District Name | Total Land Area |
|---------------|----------------|
| Central | 6 |
| Central Northeast | 8 |
| Lower Far Northeast | 11 |
| Lower North | 6 |
| Lower Northeast | 6 |
| Lower Northwest | 9 |
| Lower South | 9 |
| Lower Southwest | 10 |
| North | 9 |
| North Delaware | 10 |
| River Wards | 8 |
| South | 6 |
| University Southwest | 5 |
| Upper Far Northeast | 10 |
| Upper North | 8 |
| Upper Northwest | 10 |
| West | 5 |
| West Park | 7 |

Sum: 142 sqmi ✓

Screenshot: `assets/screenshots/metabase_district_sanity.png`

---

## What this catches

- Missing districts (row count < 18)
- Bad geometry calculation in staging (area = 0 or implausibly small)
- Wrong CRS in the staging → marts transform (area wildly off — e.g. in square meters instead of square miles)
- Duplicate districts (row count > 18)
