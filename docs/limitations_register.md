# Limitations register

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

## Purpose
This register documents project pitfalls up front so the platform remains credible to non-technical stakeholders. It records limitations, their severity, the likely impact on analysis, mitigations, and when they will be addressed (Month 2/3/6).

This register is informed by the MVP dataset risks, the problem statement scope boundaries, the assumptions log, and the ACS and land-area policies.

---

## Limitations

| ID | Limitation | Severity | Impact on analysis/product | Mitigation | Addressed |
|---|---|---|---|---|---|
| L1 | Planning district boundaries are last updated in 2015 and treated as static for MVP. | High | If boundaries changed materially, district rollups over time may not be comparable; trends could reflect boundary artifacts, not real change. | Confirm whether a newer district boundary version exists; document boundary version used; if boundaries change later, introduce boundary versioning and rerun rollups. | Month 2 (validate) / Month 6 (versioning if needed) |
| L2 | Boundary-edge uncertainty: permits, tracts, and zoning polygons near district borders may be assigned inconsistently. | Medium | District counts/rates may be slightly biased; comparisons between adjacent districts could be noisy. | Quantify a "near-boundary share" metric (how many records fall within a small buffer); include this as a quality indicator; avoid over-interpreting small differences between neighboring districts. | Month 2 |
| L3 | Permit geocoding quality: permits are geocoded to addresses; some records may lack reliable coordinates or be mislocated. | High | Unassigned/misassigned permits distort district-month rollups and any map-first exploration. | Track and publish an "unassigned permits" count/share by district-month; add a quality flag; clearly caveat district comparisons where unassigned share is high. | Month 2 |
| L4 | Permit category drift: new permit types introduced over time and label drift (e.g., "Res" vs "Residential") break longitudinal composition metrics. | High | Composition charts may be misleading; time trends by category can be artifacts of taxonomy changes. | Use coarse, stable groupings; maintain a mapping table with an "unknown/unmapped" bucket; track unmapped share over time and suppress overly granular breakdowns. | Month 2 (initial mapping) / Month 3 (metric specs + drift monitoring) |
| L5 | Permit "event date" ambiguity: multiple date fields may exist (application/issue/completion); choosing the wrong one changes month-level trends. | High | Trend conclusions can flip depending on date choice; "recent surges" could be processing lag. | Explicitly select and document one canonical event date; run comparison checks across candidate date fields; disclose date semantics in metric specs. | Month 2 |
| L6 | Permits may include duplicates or revisions/amendments that share a permit number or represent updates to a prior record. | Medium | Double-counting inflates activity; month-to-month deltas may reflect administrative updates rather than new work. | Validate uniqueness over a sample; define a deduping/revision rule (e.g., latest status only); track revision share as a quality metric. | Month 2 |
| L7 | Zoning label drift across vintages: same zoning class represented differently across years; schema inconsistency across annual layers. | High | Year-to-year churn may be partly an artifact of schema changes; composition comparisons can be invalid without harmonization. | Build a comparability plan: normalize classes via mapping; explicitly flag "unmappable" classes; document "do not claim" statements for years where drift is high. | Month 3 |
| L8 | Zoning polygon geometry changes (slivers/topology differences) can create false "change" when comparing year-to-year. | Medium | Churn metrics can be inflated by geometry segmentation changes rather than actual rezoning. | Use area-weighted change measures; add minimum-area thresholds for reporting transitions; track "sliver" share; include interpretability caveats in zoning churn specs. | Month 3 / Month 6 (refinements) |
| L9 | ACS is a 5-year period estimate at tract geography; it cannot support annual demographic change at district level. | High | Users may misinterpret demographic lines as year-specific; apparent "year-to-year" change could be noise or overlap artifacts. | Enforce ACS usage policy: 5-year only, explicit period labels, and only non-overlapping comparisons; include the standard disclaimer on every demographic view. | Month 3 (final metric specs + disclaimer enforcement) |
| L10 | ACS-to-district aggregation uncertainty: tracts can straddle district boundaries; assigning a tract to a single district introduces error. | Medium | District demographic context may be biased near borders; small differences between districts may be unreliable. | Use area-weighted allocation where possible; track "split-tract share" per district; disclose that district demographics are approximations. | Month 3 / Month 6 (improved allocation + sensitivity checks) |
| L11 | Area normalization depends on accurate land-only area. If geometry errors cause null/zero land area, density metrics must be suppressed. | Medium | Permits-per-sq-mi metrics could be wrong or unavailable for affected districts; comparisons become incomplete. | Follow land-area policy: suppress density metrics when land area is null/zero; surface a visible flag; log instances for remediation. | Month 2 (compute/store area) / Month 3 (metric integration) |
| L12 | Platform intentionally does not answer "drivers/attribution," amenities change, transit access change, or causal claims until later phases. | Medium | Users may expect explanations ("who caused this?") and deeper neighborhood detail; risk of over-promising. | Make out-of-scope explicit in the UI/docs; provide a backlog section for Phase 2+; restrict narratives to descriptive trends and context only. | Month 2 (messaging) / Month 6 (begin Phase 2 expansions) |
| L13 | Natural key (`DIST_NUM`) for planning districts is listed in the official schema but absent from the GeoJSON extract; interim key (`objectid`) may not be stable across republishes of the dataset. | Medium | If `objectid` values change in a future dataset pull, joins between the staging table and warehouse dimensions will silently break or require a full reload. | Confirm `DIST_NUM` availability from the authoritative ArcGIS FeatureServer API in Month 2; use `DIST_NUM` as `district_id` if confirmed; document the chosen key in the decision log and update all downstream joins accordingly. | Month 2 |
| L14 | CRS of the planning districts geometry layer is unconfirmed; land-only area cannot be reliably computed until the coordinate reference system is validated. | High | All density metrics (e.g., permits per sq mi) depend on `land_area_sqmi`; an incorrect CRS would produce wrong area values and systematically distort comparisons across all 18 districts. | Validate CRS from authoritative API metadata in Month 2 before computing `land_area_sqmi`; suppress all density metrics until area is confirmed; log the validated CRS in the decision log. | Month 2 |

---

## Notes
- "Severity" is rated relative to the MVP's three questions (permits trends, zoning churn, ACS context) and whether the limitation can materially change conclusions.
- Each limitation should be linked to a corresponding metric spec and/or policy doc as those are written in Month 3.

---

## Links

- MVP datasets (source risks): [`docs/03_mvp_datasets.md`](./03_mvp_datasets.md)
- Assumptions log: [`docs/assumptions_log.md`](./assumptions_log.md)
- ACS usage policy: [`docs/policies/acs_usage_policy.md`](./policies/acs_usage_policy.md)
- Land-area denominator policy: [`docs/policies/land_area_denominator_policy.md`](./policies/land_area_denominator_policy.md)
- Decision log: [`docs/decision_log.md`](./decision_log.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
| 2026-03-05 | Added L13 (natural key uncertainty) and L14 (CRS unconfirmed) from Day 6 district spine catalog work | Farid  |
