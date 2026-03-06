# ACS (American Community Survey) — Metadata Summary (Project Fit)

**Prepared for:** Philly Planning District Change Explorer (district-first MVP)  
**Dataset ID:** D1 (ACS demographic context)  
**Prepared by:** Farid  
**Date:** 2026-03-05  

## What this dataset is
The **ACS 5-Year Data Profiles** provide tract-level demographic, social, economic, and housing estimates. In this project, ACS is used as **context** for district-level change metrics (permits, zoning), not as an explanatory/causal dataset.

## What geometry type is it (points, lines, polygons)?
- **Tabular only** via the Census API (no geometry returned).
- To map or spatially aggregate, you must join to **census tract polygons** (e.g., TIGER/Line) using tract GEOID.

## How many features/rows does it have?
- The API returns **one row per geography requested**.
- For the Philly use case: **all census tracts in Philadelphia County (PA, county 101)**. Exact count depends on the vintage and should be validated by a “NAME-only” pull and counting rows.

## What fields exist — which ones look like candidate keys or district name fields?
### Geography identifiers (candidate keys)
- `GEO_ID` (prefixed tract identifier, e.g., `1400000US...`)
- `state`, `county`, `tract` (FIPS components)
- Recommended canonical key for the warehouse: `geoid_tract = state + county + tract` (11-digit)

### Display fields
- `NAME` (tract label; display only, not stable as a key)

### Measures
- You select specific DPxx variables to pull (DP02, DP03, DP04, DP05). The ACS profile dataset contains many hundreds of variables; MVP should use a curated pack.

## Is there any update cadence info?
- **Update cadence:** annual release (new ACS 5-year vintage published each year).
- ACS 5-year values are **period estimates** (rolling 5-year), not point-in-time annual measurements.

## Fit to the project (district-first MVP)
- ✅ Works for **context panels** once tract values are aggregated to planning districts via an explicit tract→district method (overlay/crosswalk).
- ⚠️ Not appropriate for “monthly” or “true year-over-year” district demographics.
- ⚠️ Medians are **not additively aggregatable**; percentages should be recomputed from aggregated numerator/denominator counts where possible.

## Standard caveat phrasing (for dashboards and docs)
> “ACS estimates represent 5-year averages ending in [year] and should not be compared across overlapping periods (e.g., 2018–2022 vs. 2019–2023). Use non-overlapping windows only (e.g., 2015–2019 vs. 2020–2024).”
