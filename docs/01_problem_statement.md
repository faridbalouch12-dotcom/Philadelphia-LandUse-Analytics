# Problem Statement — Philadelphia District Change Explorer

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Status:** Draft

---

## Purpose

This document defines the problem this platform is built to solve, the users it serves, the questions it answers, and what it explicitly does not address. It serves as the non-technical anchor for all design decisions in this project.

---

## The Problem

Philadelphia's change data — building permits, zoning classifications, and demographic trends — is publicly available but scattered across separate portals, updated on inconsistent schedules, and requires significant technical work to combine into a coherent picture. There is no ready-made place to track how Philadelphia's planning districts change over time.

This leaves non-technical stakeholders — residents, advocates, journalists, and city staff — unable to answer basic questions about their district without hiring analysts or doing the data work themselves.

---

## Target Users

This platform is built for people who care about Philadelphia's neighborhoods but cannot build their own analyses.

| User | Context | Primary Need |
|------|---------|--------------|
| Residents and neighborhood associations | Want to understand what's happening in their district | Accessible trend summaries without GIS or SQL |
| Community-based organizations and nonprofits | Advocacy, grant narratives, planning meetings | District-level evidence that is defensible and citable |
| Journalists and local policy writers | Covering development, zoning, or neighborhood change | Quick, comparable trend summaries with clear caveats |
| City staff in non-analyst roles | Communications, engagement, program management | Dashboards and briefs they can use without building analyses |

---

## The Three Questions This Platform Answers

**1. How is each planning district changing physically over time?**

Monthly permitting activity and intensity (permits per land square mile), including how permit composition breaks down by coarse category — tracking the pace and type of physical change district by district.

**2. How is zoning policy changing year-to-year within each district?**

Annual zoning base-district composition and a year-to-year measure of how much land area changed zoning classification — tracking whether the regulatory environment is shifting and where.

**3. What demographic and housing context is changing alongside physical change?**

ACS-based trends for income proxy and owner vs. renter tenure at the district level, labeled by ACS period and presented with explicit caveats about what the data can and cannot show.

---

## Why District-First

Philadelphia's 18 planning districts are the natural unit of analysis for these questions. "How is this district changing?" and "Which districts are changing fastest?" are inherently district-level questions — the district is the level at which long-range planning, development policy, and zoning decisions are made and communicated.

Sub-district grain (ZIP codes, census tracts, parcels) adds complexity without improving the core answers at this stage and is deferred to a future phase.

---

## What This Platform Does Not Address

The following are out of scope for the current version and will not be addressed until a future phase:

- **Drivers and attribution** — identifying developers, ownership networks, nonprofit actors, funding sources, or lobbying activity behind changes
- **Amenities change over time** — grocery stores, pharmacies, parks, or retail; most public point-of-interest datasets do not have reliable historical records
- **Transit access change over time** — versioned, time-series transit accessibility metrics are not available in the current dataset scope
- **Causation and causal modeling** — this platform describes trends and correlations; it does not claim to explain why changes happened
- **Map-first as the primary product** — parcel-level drilldowns, corridor/buffer analyses, and hotspot mapping are not the primary interface for this version

---

## Links

**Related Documents:**
- Scope memo: [`docs/00_scope_memo.md`](./00_scope_memo.md)
- Month-1 success criteria: [`docs/02_success_criteria.md`](./02_success_criteria.md)
- MVP datasets: [`docs/03_mvp_datasets.md`](./03_mvp_datasets.md)
- Docs index: [`docs/README.md`](./README.md)

---

## Change Log

| Date | Change Description | Author |
|------|--------------------|--------|
| 2026-03-03 | Initial draft | Farid |
