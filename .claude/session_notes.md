# Session notes — 2026-03-03

## Task 3.6 in progress — Data access notes

Access decisions locked for 3 of 4 datasets:

**S1 — Planning Districts**
- Access: ArcGIS FeatureServer API (AGO), GeoJSON, fetched at pipeline runtime
- Why: 18 static polygons, no file committed (preserves data storage policy), geometry preserved

**S2 — L&I Permits**
- Access: Carto SQL API, CSV format (includes lat/lng columns), date filter to last 5 years
- Why: 500k+ rows — full history too large; CSV + lat/lng sufficient for spatial join to districts in pipeline
- Warning: API does not paginate automatically; pipeline will need chunked requests

**S3 — Zoning Base Districts**
- Access: ArcGIS FeatureServer API (AGO), GeoJSON, one request per vintage year
- Vintages: 2020–2025 (5 separate API calls)
- Why: Multi-vintage dataset requires iterating over year list; geometry needed for spatial analysis

**ACS — OPEN / under reconsideration**

Original plan:
- Tabular data: Census Bureau ACS API, two non-overlapping 5-year windows (2016–2020 and most recent ~2019–2023)
- Tract boundaries: Census TIGER/Line API, GeoJSON, joined on GEOID
- ACS treated as "context only"

Reconsideration raised at end of session:
- Farid wants to explore whether **annual tract-level ACS estimates** exist for income/tenure variables
- If they do, ACS would no longer be "context only" — it could align temporally with permit activity and support stronger analytical statements
- NHGIS annual tract estimates were explored but only cover age/race/sex through 2019 — not sufficient
- **Action for tomorrow:** Check Census Bureau ACS pages for annual tract-level income/tenure estimates or other authoritative sources.
- If they don't exist → revert to 5-year window plan
- If they do exist → reconsider ACS access strategy and potentially update 03_mvp_datasets.md

## doc to write tomorrow
`docs/04_data_access_notes.md` — waiting on ACS decision before formatting
