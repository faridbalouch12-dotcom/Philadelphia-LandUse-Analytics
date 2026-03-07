# MVP Metrics Definitions — Conceptual Note

**Author:** Farid
**Created:** 2026-03-06
**Last Updated:** 2026-03-06
**Status:** Draft

---

## How the Permitting Process Works

In Philadelphia, a permit is required before making most non-exempt changes to a
property. The Department of Licenses and Inspections (L&I) issues permits in
several categories — construction, electrical, mechanical, zoning, and others.

**Crucially, permits are a compliance mechanism, not a change mechanism.**
A permit does not change what a property is zoned as. It confirms that the
proposed work or use is consistent with the property's existing zoning
classification. There are three paths to obtaining a zoning permit:

- **By right / as-of-right:** The proposed use complies with all zoning
  provisions. L&I issues the permit without any board action required.
- **By special exception:** The use is conditionally permitted; the Zoning Board
  of Adjustment grants approval if the project is compatible with the surrounding
  neighborhood.
- **By variance:** The applicant cannot comply with zoning standards due to
  special circumstances, and the ZBA grants a deviation from the code.

Zoning changes themselves — reclassifying land from one base district to another
— happen through a separate legislative process: City Council ordinances proposed
as bills, referred to committee, and enacted as law. The `pendingbillurl` field
in the zoning base district dataset links to exactly this kind of pending
legislation.

---

## How It Relates to MVP Metrics

This project tracks neighborhood change in Philadelphia's planning districts
through two independent analytical questions:

### Question 1 — Physical change over time (Permits dataset)

> "How is each planning district changing physically over time?"

Permit activity is a proxy for physical development and construction pressure.
When permits are filed and issued, it signals that physical changes are being
made to properties in that area — new construction, renovations, additions,
changes of use.

The permits dataset answers this question by tracking:
- **Monthly permit counts** per planning district
- **Permit intensity** (permits per land square mile) per district
- **Permit composition** by coarse category (e.g., construction vs. zoning vs.
  electrical) per district

The spatial join required: **permits (points) → planning districts (polygons)**
Each permit is assigned to a planning district via point-in-polygon spatial join
on geocoded permit coordinates.

### Question 2 — Regulatory change over time (Zoning dataset)

> "How is zoning policy changing year-to-year within each district?"

Zoning base district snapshots — pulled as annual vintages — track how the
regulatory classification of land is shifting. When land is rezoned (e.g., from
industrial to commercial mixed-use), it reflects a policy decision about what
kind of development is permitted in that area going forward.

The zoning dataset answers this question by tracking:
- **District-year zoning composition** (share of land area by zoning class per
  district per year)
- **Year-to-year zoning churn** (how much land area changed classification
  between vintage years)

The spatial join required: **zoning polygons → planning districts (polygons)**
Each zoning polygon is assigned to a planning district via polygon overlay
(intersection), with area-weighted aggregation to compute class shares per
district.

### Key distinction

These two questions are answered through **separate analytical paths**. Permits
do not record zoning changes, and zoning vintages do not record permit activity.
They are parallel signals that together paint a picture of how Philadelphia's
planning districts are evolving — physically and regulatorily.

---

## How MVP Metrics Will Be Calculated

For a detailed walkthrough of the spatial join mechanics — including schematic
diagrams and concrete examples for both joins — see:

[Spatial Join Mechanics — Visual Explainer](./spatial_join_mechanics.html)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-06 | Initial draft      | Farid  |
