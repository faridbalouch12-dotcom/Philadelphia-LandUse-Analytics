# Repository settings checklist

**Author:** Farid  
**Created:** 2026-02-28  
**Last Updated:** 2026-03-01  
**Status:** Final  

---

## Purpose

This checklist documents the intended GitHub repository settings for the Philly Data Warehouse project. It maps each setting to its location in the GitHub UI and requires evidence artifacts to verify application.

---

## Scope

**In Scope:**
- Branch protection rules for `main`
- Pull request requirements
- Status check requirements

**Out of Scope:**
- Deployment settings
- Webhooks and integrations
- Security and analysis features (will be addressed in future months if needed)

---

## Settings to apply

### 1. Branch protection rules

**Setting:** Enable branch protection for `main`  
**GitHub Path:** Settings → Branches → Branch protection rules → Add rule  
**Configuration:**
- Branch name pattern: `main`

**Evidence Required:** Screenshot or written confirmation in `docs/repo_settings_applied.md`

---

### 2. Require pull request before merging

**Setting:** Require a pull request before merging into `main`  
**GitHub Path:** Settings → Branches → Branch protection rules → `main` rule → "Require a pull request before merging"  
**Configuration:**
- ✅ Require a pull request before merging
- Require approvals: Disabled for this solo project
- Dismiss stale pull request approvals when new commits are pushed: Not applicable

**Evidence Required:** Screenshot or written confirmation in `docs/repo_settings_applied.md`

---

### 3. Require status checks

**Setting:** Require status checks to pass before merging  
**GitHub Path:** Settings → Branches → Branch protection rules → `main` rule → "Require status checks to pass before merging"  
**Configuration:**
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging

**Evidence Required:** Screenshot or written confirmation in `docs/repo_settings_applied.md`

---

## Evidence artifacts

All applied settings must be documented with evidence:

**Primary Evidence:**
- File: `docs/repo_settings_applied.md`
- Contains: List of applied settings with date applied
- Alternative: Screenshot at `assets/screenshots/branch_protection.png`

**Verification:**
- Evidence artifact must be dated
- Evidence artifact must clearly show the settings enabled
- Evidence must be traceable to this checklist

---

## References

- **[D12]** GitHub Docs: Branch protection rules. See [Resources](../claude/resources.md#d12) for link.
- **[V7]** Video tutorial on GitHub branch protection. See [Resources](../claude/resources.md#v7) for link.

---

## Links

**Related Documents:**
- [Repository Settings Applied](./repo_settings_applied.md) — Evidence that settings were configured
- [CONTRIBUTING.md](../CONTRIBUTING.md) — Workflow that depends on these settings

---

## Change log

| Date       | Change Description          | Author |
|------------|-----------------------------|--------|
| 2026-02-28 | Initial checklist created   | Farid  |
| 2026-03-01 | Updated PR requirement for solo-project workflow | Farid  |
