# ACS (American Community Survey) - Metadata Summary (Project Fit)

**Prepared for:** Philly Planning District Change Explorer (district-first MVP)
**Dataset ID:** D1 (ACS demographic context)
**Prepared by:** Farid
**Date:** 2026-03-08

## What this dataset is
The **ACS 5-Year Data Profiles** provide tract-level demographic, social, economic, and housing estimates. In this project, ACS is used as **context** for district change metrics (permits, zoning), not as an explanatory/causal dataset.

## What geometry type is it (points, lines, polygons)?
- **Tabular only** via the Census API (no geometry returned).
- To map or group by district, join to **census tract polygons** (e.g., TIGER/Line) using tract GEOID.

## How many features/rows does it have?
- The API returns **one row per geography requested**.
- For this project: **all census tracts in Philadelphia County (PA, county 101)**. Exact tract count depends on the selected vintage and should be validated per pull.

## What fields exist - which ones look like candidate keys or district name fields?
### Geography identifiers (candidate keys)
- `GEO_ID` (prefixed tract identifier, e.g., `1400000US...`)
- `state`, `county`, `tract` (FIPS components)
- Recommended canonical key for the warehouse: `geoid_tract = state + county + tract` (11-digit)

### Display fields
- `NAME` (tract label; display only, not stable as a key)

### Measures
- Selected DPxx variables (DP02, DP03, DP04, DP05), including paired estimate + MOE fields in the tract mart.

## Is there any update cadence info?
- **Update cadence:** annual release (new ACS 5-year vintage published each year).
- ACS 5-year values are **period estimates** (rolling 5-year), not point-in-time annual measurements.

## Fit to the project (district-first MVP)
- Works for **district context panels** when district interactions are built from tract-level distributions.
- Not appropriate for monthly or true year-over-year district demographics.
- Medians are not additive, and MOE handling must remain explicit.

## Decision alignment (D8-D10)
- Store tract-level ACS estimates with raw MOE columns in the mart.
- Use district interactions to show tract-level distributions (ranges, histogram bins, tract counts).
- Do not publish single-value district ACS KPIs in MVP dashboards.

## Standard caveat phrasing (for dashboards and docs)
> ACS estimates represent 5-year averages ending in [year] and should not be compared across overlapping periods (e.g., 2018-2022 vs 2019-2023). Use non-overlapping windows only (e.g., 2015-2019 vs 2020-2024). Values are shown as tract-level distributions for district context, not single-value district ACS KPIs.
