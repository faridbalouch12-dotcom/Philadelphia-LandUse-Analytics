# Pull Request

## Purpose

Describe the change in 2-5 sentences. State what changed, why it changed,
and what outcome this PR should produce.

- Issue: Closes #
- Scope: Explain the smallest viable scope this PR is meant to cover.
- Definition of Done: List the specific deliverables or acceptance criteria
  this PR satisfies.

### Change type

- [ ] Docs/specification update
- [ ] Policy or workflow update
- [ ] Repository/configuration update
- [ ] Data model design update
- [ ] Ingestion / pipeline code
- [ ] dbt / warehouse code
- [ ] Other (describe above)

## Artifacts Updated

List the main files changed and what role each one plays.

- `path/to/file.md` - why it changed

## Checklist

Describe what you actually checked before opening this PR.

### Documentation checks

- [ ] Verified required sections/fields are present
- [ ] Verified file names follow project conventions
- [ ] Verified internal links and cross-references resolve
- [ ] Updated `docs/README.md` if a new long-lived doc was added
- [ ] Updated root `README.md` links if needed

### Implementation checks

- [ ] Not applicable (documentation-only PR)
- [ ] Relevant local checks ran successfully
- [ ] If checks were skipped, the reason is documented below

### Pre-merge checks

- [ ] PR is scoped to one logical change
- [ ] Deliverable artifacts exist at the intended file paths
- [ ] Pass/fail gates for this task are satisfied
- [ ] Related documentation is updated for any behavior, model, metric, or
      source changes
- [ ] No secrets, raw data, or local-only artifacts were committed
- [ ] Diff has been read end-to-end as a self-review

Commands run / review steps:

```text
# Example:
# - Reviewed diff end-to-end
# - Clicked all new or changed links
# - Ran local commands (if applicable)
```

### Self-review rubric

Score each criterion from 0-2. The merge bar in `CONTRIBUTING.md` is 7+.

| Criterion | Score (0-2) | Notes |
|-----------|-------------|-------|
| Clarity | | |
| Completeness | | |
| Traceability | | |
| Consistency | | |
| Task objective mastery | | |
| **Total** | | |

## Risks/Assumptions

- Known risks, caveats, or assumptions introduced by this PR
- Follow-up work that should happen in a later PR

## Links

- Related issue:
- Related docs:
- Related PRs:
- Evidence (screenshots, logs, notes):
