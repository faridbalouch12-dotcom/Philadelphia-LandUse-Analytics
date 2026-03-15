# Session Notes — Task 9.5: Boundary Alignment Note (ACS → Districts)

**Date:** 2026-03-08
**Task:** 9.5 — Boundary alignment note (ACS → Districts)
**Score:** 9/10 (PASS)
**Deliverable:** [`docs/feasibility/acs_to_district_alignment_note.md`](../../docs/feasibility/acs_to_district_alignment_note.md)

---

## What we worked through

### The core problem

ACS data comes at the census tract level. The warehouse needs it at the planning district level. Those two boundary systems don't line up — census tracts straddle planning district lines. This session was about nailing down *how* to bridge that gap and *what assumptions that introduces*.

### Why no crosswalk exists

Walked through why you can't just download a crosswalk table. The Census Bureau publishes relationship files for geographies it defines (counties, places, ZCTAs). Philadelphia planning districts are a city-defined boundary — the Census Bureau doesn't know they exist. The only path is to compute the allocation yourself using geometry.

### Area-weighted interpolation

The chosen approach: spatial overlay in PostGIS. Intersect census tract polygons with planning district polygons, compute the overlap area fraction, allocate values proportionally.

```
allocated_value = tract_value * (
    ST_Area(ST_Intersection(tract.geom, district.geom))
    / ST_Area(tract.geom)
)
```

Source: *Spatial SQL* (Forrest), Section 5.1 — the NYC census block group → neighborhood example is the direct analog.

### The uniform distribution assumption and MAUP

The clearest part of the conversation. The method assumes population is evenly spread within each census tract. In practice it isn't. the learner's Center City example was spot-on: a tract that's half commercial core / half residential, straddling a district boundary. Area weighting splits the population 50/50. The true split might be 90/10 because all the residents live on one side.

This is MAUP in action — the aggregated result depends on where the boundary was drawn, not just on the underlying population. It's documented in the limitations register as L10.

### Sanity checks

Worked through four checks through discussion:

1. **Geometry validity** — the learner's first instinct: make sure the district polygons themselves don't overlap or leave gaps. Right answer.
2. **Split-tract count per district** — How many tracts are being cut across district lines? High split-tract share = higher MAUP exposure.
3. **Split ratio for split tracts** — For tracts that do split, how even is the split? Near-50/50 tracts carry the most risk (the assumption is doing the most work there).
4. **Population total check** — Sum of all allocated district populations should equal Philadelphia's total ACS population, within ±1%. Classic control total.

### Slivers

Small polygon fragments at boundary edges from geometry misalignment. They're noise — near-zero area, negligible allocated values, but they inflate row counts. Filtered with a minimum area threshold.

---

## Meta-learning

**Q:** How does this task connect to earlier work you've done in the project?

**the learner's answer:** "this task connects to earlier work we've done as we discussed calculating land areas, mapping smaller things like polygons from the zoning dataset to the planning district"

Good connection. The zoning polygon → planning district assignment is the same PostGIS pattern at its core (point-in-polygon, centroid matching, or intersection). The difference here is that census tracts straddle planning district boundaries and need *proportional* allocation rather than binary assignment. Same toolbox, higher complexity. The land area work (land-only area note, denominator policy) also primes the skill of thinking carefully about what a geometry actually represents before computing with it.

---

## Concepts to revisit before upcoming tasks

- **Task 9.6 (MOE-aware messaging):** The uncertainty problem shifts from spatial (MAUP) to statistical (margin of error). ACS estimates have confidence intervals — small districts with sparse population have wide MOEs. The question becomes: when is a difference between two districts statistically meaningful vs. within the noise?
- **Area-weighted interpolation in practice:** When Month 2 pipeline work starts, this note becomes the spec for the actual PostGIS query. The sanity checks table becomes the QA checklist to run after the overlay.

---

## Learning System Highlights

- Discussion Partner mode walked through the spatial problem step-by-step, with the learner explaining concepts back before moving forward
- The learner's own Center City example was used to test the uniform distribution assumption — surfacing MAUP as a real project risk, not just a textbook concept
- Four sanity checks emerged from guided questioning rather than being prescribed — the learner generated the verification strategy

---

## Links

- **Deliverable:** [`docs/feasibility/acs_to_district_alignment_note.md`](../../docs/feasibility/acs_to_district_alignment_note.md)
- **Related notes:** [`notes/gis/postgis_spatial_primer_notes.md`](../gis/postgis_spatial_primer_notes.md)
- **Limitations register (L10):** [`docs/limitations_register.md`](../../docs/limitations_register.md)
