# /reconcile — Architectural Decision Reconciliation

Reconcile a proposed or recently made architectural change against existing locked decisions, assumptions, and downstream documentation.

Usage: `/reconcile [description of the change]`

Auto-triggered when Claude detects an architectural change during conversation (see CLAUDE.md trigger conditions).

---

## Step 1: Classify the change type

Read the description (from $ARGUMENTS or conversation context) and classify into exactly one primary category:

| Category | Description | Example |
|----------|-------------|---------|
| **LAYER** | Schema layer structure, table placement, naming | Adding an intermediate layer, moving a table between schemas |
| **GRAIN** | Grain statement change for any table | Changing fct_permits from one-per-permit to one-per-permit-event |
| **TABLE** | Adding, removing, renaming, restructuring a table | Adding int_li_permits_issued, removing dim_permit_type |
| **SCD** | Changing the SCD strategy for a dimension | Switching dim_zoning from Type 1 to Type 2 |
| **KEY** | Changing PK, FK, or surrogate key strategy | Switching from natural key to surrogate key on a fact table |
| **METRIC** | Changing a metric formula, grain, source table, or dimension | Changing permits_monthly_count source from stg to fct |
| **POLICY** | Changing an established policy | Allowing district-level ACS aggregation |
| **DIAGRAM** | Changes that affect ERD or dataflow structure | Adding a new entity, changing relationship cardinality |

If the change spans multiple categories, identify the primary and note secondary impacts.

---

## Step 2: Load the change impact map

Based on the category, read **only** these files:

### LAYER changes
- `docs/modeling/table_inventory.md` — check layer assignments
- `docs/diagrams/dataflow.mmd` — check layer subgraphs
- `docs/decision_log.md` — search for decisions mentioning layers or schemas
- `docs/modeling/erd_text_draft.md` — check entity descriptions for layer references

### GRAIN changes
- `docs/modeling/grain_spec.md` — the canonical grain statements
- `docs/modeling/column_contracts.md` — DDL specs that encode grain
- `docs/metrics/` — read only metric specs that reference the affected table
- `docs/decision_log.md` — decisions referencing the affected table name

### TABLE changes
- `docs/modeling/table_inventory.md` — table existence, type, grain, consumers
- `docs/modeling/erd_text_draft.md` — entity and relationship definitions
- `docs/modeling/grain_spec.md` — if the table has a grain statement
- `docs/modeling/column_contracts.md` — if the table has a column contract
- `docs/diagrams/erd.mmd` — entity and relationship diagram
- `docs/diagrams/dataflow.mmd` — dataflow references
- `docs/decision_log.md` — decisions mentioning the table name

### SCD changes
- `docs/modeling/table_inventory.md` — SCD Strategy column
- `docs/decision_log.md` — search for the SCD decision (likely D17)
- `docs/modeling/column_contracts.md` — check if versioning columns are needed

### KEY changes
- `docs/modeling/grain_spec.md` — PK definitions and schema contracts
- `docs/modeling/column_contracts.md` — key strategy sections
- `docs/modeling/erd_text_draft.md` — PK/FK definitions
- `docs/diagrams/erd.mmd` — PK/FK annotations
- `docs/decision_log.md` — decisions about key strategy (D12, D14, D16)

### METRIC changes
- The specific metric spec file(s) in `docs/metrics/`
- `docs/modeling/grain_spec.md` — if grain is affected
- `docs/modeling/table_inventory.md` — if source table references change
- `docs/limitations_register.md` — limitations tied to the metric
- `docs/decision_log.md` — decisions tied to the metric

### POLICY changes
- The specific policy file in `docs/policies/`
- `docs/decision_log.md` — decisions that reference the policy
- `docs/assumptions_log.md` — assumptions that depend on the policy
- `docs/limitations_register.md` — limitations mitigated by the policy
- `docs/metrics/` — metric specs that reference the policy

### DIAGRAM changes
- `docs/modeling/erd_text_draft.md` — canonical entity/relationship definitions
- `docs/modeling/table_inventory.md` — table existence
- `docs/diagrams/erd.mmd` — current ERD
- `docs/diagrams/dataflow.mmd` — current dataflow

### All changes
 - Read all files above. 
---

## Step 3: Check for contradictions

For each file loaded in Step 2, check:

1. **Direct contradiction:** Does the file contain a statement that the proposed change would make false?
   - Example: Decision D7 says "the warehouse will have two fact tables" but the change adds a third.

2. **Stale reference:** Does the file reference a table name, layer, column, or concept that the change would rename or remove?
   - Example: A metric spec references `stg_permits` but the change renames it to `int_li_permits_issued`.

3. **Assumption violation:** Does the change invalidate an assumption in `docs/assumptions_log.md`?
   - Example: A10 assumes non-overlapping ACS windows, but the change introduces overlapping comparisons.

4. **Limitation impact:** Does the change resolve or create an entry in `docs/limitations_register.md`?

---

## Step 4: Check for superseded decisions

Search `docs/decision_log.md` for any locked decision whose content is contradicted by the proposed change. For each:

1. **Quote the conflicting decision** — show the decision ID, date, and the specific statement that conflicts.
2. **Ask the learner:** "Your proposed change contradicts D[X], which says [quote]. Is this intentional? If so, what's your rationale for superseding it?"
3. **Do NOT approve the change or update the decision.** The learner must articulate:
   - Why the old decision no longer applies
   - What changed (new information, implementation experience, design evolution)
   - What the replacement decision is

---

## Step 5: Report the reconciliation findings

Present a structured report:

```
### Reconciliation Report: [short description of change]

**Change type:** [LAYER / GRAIN / TABLE / SCD / KEY / METRIC / POLICY / DIAGRAM]

**Contradictions found:** [count]
- **File:** [path] — **What conflicts:** [specific statement] — **Severity:** BLOCKING or UPDATE-NEEDED

**Superseded decisions:** [count]
- **Decision:** D[X] — [quote the conflicting statement] — **Status:** Awaiting learner rationale

**Stale references:** [count]
- **File:** [path] — **What's stale:** [the specific reference that needs updating]

**Assumptions at risk:** [count]
- **Assumption:** A[X] — **Impact:** [how the change affects it]

**No issues found:** [if clean, say so explicitly]
```

---

## Step 6: Decide next action

Based on the report:

- **If BLOCKING contradictions or superseded decisions exist:** Pause. Do not update any docs until the learner has defended or revised the change. Ask them to address each BLOCKING item.
- **If only UPDATE-NEEDED / stale references exist:** Present the list and ask: "These docs need updating to reflect your change. Want to work through them now, or defer?"
- **If clean:** Confirm: "No contradictions found. This change is consistent with existing decisions and docs."

---

## Step 7: Handle decision amendments (when the learner confirms supersession)

When the learner provides rationale for superseding a locked decision:

1. **Do not delete the old entry.** Add a supersession notice at the top of the old decision entry:

   > **SUPERSEDED by D[new] on [date].** See D[new] for current decision.

2. **Create the new decision entry** following the existing format (Date, Decision, Alternatives, Rationale, Implications). The learner must author the substantive content; Claude formats it.

3. **Update the change log** at the bottom of `docs/decision_log.md`.

4. **Then update downstream docs** identified in Step 5 (stale references, metric specs, etc.).

---

## Guardrails

- **Do NOT make design decisions.** Surfacing contradictions is governance. Choosing which option is better is the learner's job.
- **Do NOT read every doc.** Only read the files specified by the change impact map for the classified category.
- **Do NOT trigger on trivial changes.** Fixing a typo, reformatting a table, or adding a comment is not an architectural change.
- **Do NOT block the learner.** If contradictions exist, flag them and let the learner decide. The learner can acknowledge a contradiction and defer resolution (e.g., "I'll update D7 after this task").
