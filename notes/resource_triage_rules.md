# Resource triage rules — Notes

**Author:** Farid
**Created:** 2026-02-28
**Last Updated:** 2026-02-28
**Source:** [D2], [D11]

---

## Purpose

This document defines the rules for evaluating source quality in this project. The goal is to ensure that claims used in specs and policy documents are backed by appropriately credible sources, and to prevent low-quality rabbit holes from influencing design decisions.

---

## Key takeaways

- Sources are classified into three tiers based on authority, accountability, and domain adoption
- Tier 1 sources can be used directly in specs; Tier 2 requires tracing back to the primary source; Tier 3 is not permitted in specs
- The tier describes the *source type* — the corroboration rules describe *how you use it*
- Lower-tier sources are pointers, not proof — follow the chain until you reach a Tier 1 or strong Tier 2 source

---

## Tier definitions and examples

### Tier 1 — Authoritative and industry-standard sources

**Definition:** Official or canonical sources that are widely adopted as the standard reference in their domain. Their findings and methodologies are accepted across the field without requiring additional validation. Claims from Tier 1 sources can be used directly in specs.

**What makes a source Tier 1:**
- Produced by an authoritative organization (government agency, standards body, canonical textbook author)
- Widely adopted as the industry standard in its domain
- No meaningful dispute about its credibility within the field

**Examples:**
1. **ACS (American Community Survey)** — U.S. Census Bureau. The gold standard for demographic data across the social sciences; universally cited in urban planning, public policy, and sociology research. See [D1], [D2].
2. **The Data Warehouse Toolkit** — Ralph Kimball & Margy Ross. The canonical reference for dimensional modeling and data warehouse design; industry-standard methodology adopted across the data engineering field. See [B1].

---

### Tier 2 — Accountable but not industry-standard sources

**Definition:** Sources that have an accountability mechanism — peer review, editorial oversight, or organizational reputation — but are not the universal standard in their domain. A single Tier 2 source is not sufficient to commit a claim to a spec; the primary source it cites must be traced and confirmed first.

**What makes a source Tier 2:**
- Subject to some form of editorial or peer-review gatekeeping
- Produced by a reputable organization or established publication with reputational accountability
- May include subjectivity, interpretation, or limited replication

**Examples:**
1. **Philadelphia Inquirer articles** — Reputable local journalism with editorial oversight (e.g., reporting on Chinatown demographic shifts or gentrification patterns). Credible as leads but must be traced back to the underlying report or study cited before use in a spec.
2. **Educational content from domain-credible organizations** — e.g., PostGIS tutorials from Crunchy Data. Produced by organizations with domain expertise and reputational accountability; suitable for learning and concept formation but should be cross-checked against official documentation (e.g., PostGIS docs) for any claim used in a spec.

---

### Tier 3 — Unaccountable sources

**Definition:** Sources with no editorial gatekeeping, no peer review, and no organizational accountability. These may be useful for discovering topics or getting initial orientation, but they are **not permitted as evidence in any spec, policy, or design decision** in this project.

**What makes a source Tier 3:**
- No editorial or peer-review process
- Author has no verifiable domain credentials or institutional accountability
- Cannot be traced back to a primary source

**Examples:**
1. **Unattributed YouTube tutorials** — Informal video content with no institutional backing or editorial review. Useful for orientation only; never cite in specs.
2. **Personal blogs and Medium posts** — No peer review, no editorial gatekeeping. May contain accurate information but cannot be verified as credible without tracing to a Tier 1/2 source — at which point you should cite the primary source directly.

---

## Corroboration rules

| Tier | Rule |
|------|------|
| **Tier 1** | Use directly in specs without confirmation. No corroboration required. |
| **Tier 2** | Before using a claim in a spec, trace back to the primary source (report, study, or official doc) that the Tier 2 source is citing. Confirm the claim at that primary source. Cite the primary source in the spec, not the Tier 2 intermediary. |
| **Tier 3** | Do not use in specs at all. May be used as an orientation lead only — follow any references to find a Tier 1 or Tier 2 source if the topic is relevant. |

---

## Application to project

- **ACS data** (Tier 1) → use D1, D2 directly in specs; no additional confirmation needed
- **Philly Inquirer or similar journalism** (Tier 2) → trace to the underlying report before citing any demographic or land-use claim in a spec
- **YouTube tutorials / blog posts** (Tier 3) → acceptable for self-education only; never appears in a spec or policy document

---

## References

- **[D2]** U.S. Census Bureau. n.d. "Comparing ACS Data." See [Bibliography](../docs/bibliography.md).
- **[D11]** PostgreSQL.org. n.d. "PostgreSQL Docs: Constraints (PK, UK, FK)." See [Bibliography](../docs/bibliography.md).

---

## Change log

| Date       | Change description                          | Author |
|------------|---------------------------------------------|--------|
| 2026-02-28 | Initial rules defined (Task 2.3)            | Farid  |
