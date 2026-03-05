# Feasibility Checklist — Planning Districts (District Spine)

## Dataset header
- Dataset name: Planning Districts
- Files reviewed: `Planning_Districts.geojson`, `fields.json`
- Reviewer: Farid
- Date: 2026-03-05
- MVP role: District spine (reporting unit + geometry for spatial joins)

---

## 1) Time field selection
**Does this dataset have a usable time field to aggregate by month/year?**
- Candidate time fields: None (boundary layer).
- MVP approach: Treat as static dimension for MVP; not used for time aggregation.

Pass criteria: ✅ PASS (not applicable; acceptable for boundary spine)
Mitigation: If boundaries change, introduce boundary versioning and treat as SCD2 (Month 6).

---

## 2) Geo linkage approach
**Can records be linked to a planning district via geometry or address?**
- Geometry present: Yes — Polygon.
- Role: district polygons used for point-in-polygon assignment of permits and overlays for zoning/ACS.
- Key risks: boundary-edge ambiguity; geometry validity.

Pass criteria: ✅ PASS
Mitigation: Validate geometry validity and CRS during ingestion; track near-boundary sensitivity in permits assignment (Month 2).

---

## 3) Key field completeness
**Are the key fields complete enough to be trustworthy?**
- `dist_name`: non-null 18/18, unique_if_present=True
- `objectid`: non-null 18/18, unique_if_present=True

- Preferred natural key: `DIST_NUM`
- Display fields: `DIST_NAME` and/or `LABEL`

Pass criteria: ✅ PASS (keys appear complete and unique in this extract)
Mitigation: If `DIST_NUM` isn’t stable across official versions, create a surrogate key and maintain mapping (Month 6).

---

## 4) Category stability
**Are category values stable enough to group over time?**
- Not applicable (fixed boundary set). Stability risk is boundary changes, not label drift.

Pass criteria: ✅ PASS

---

## 5) Known blockers
**Are there any known blockers that would prevent MVP use?**
- No blockers observed.
- Missing cadence/version metadata is not a blocker but requires validation.

Verdict: ✅ Use for MVP
Next steps (Month 2): confirm authoritative update cadence/version; validate CRS and geometry validity.
