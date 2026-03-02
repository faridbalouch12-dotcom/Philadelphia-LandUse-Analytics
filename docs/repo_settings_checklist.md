# Repository Settings Checklist

**Author:** Farid  
**Created:** 2026-02-28  
**Last Updated:** 2026-02-28  
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
- `.gitignore` configuration for books folder

**Out of Scope:**
- Deployment settings
- Webhooks and integrations
- Security and analysis features (will be addressed in future months if needed)

---

## Settings to Apply

### 1. Branch Protection Rules

**Setting:** Enable branch protection for `main`  
**GitHub Path:** Settings → Branches → Branch protection rules → Add rule  
**Configuration:**
- Branch name pattern: `main`

**Evidence Required:** Screenshot or written confirmation in `docs/repo_settings_applied.md`

---

### 2. Require Pull Request Before Merging

**Setting:** Require a pull request before merging into `main`  
**GitHub Path:** Settings → Branches → Branch protection rules → `main` rule → "Require a pull request before merging"  
**Configuration:**
- ✅ Require a pull request before merging
- Require approvals: 1
- Dismiss stale pull request approvals when new commits are pushed: (optional, depends on preference)

**Evidence Required:** Screenshot or written confirmation in `docs/repo_settings_applied.md`

---

### 3. Require Status Checks

**Setting:** Require status checks to pass before merging  
**GitHub Path:** Settings → Branches → Branch protection rules → `main` rule → "Require status checks to pass before merging"  
**Configuration:**
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging

**Evidence Required:** Screenshot or written confirmation in `docs/repo_settings_applied.md`

---

### 4. Configure .gitignore for Books Folder

**Setting:** Add `books/` folder to `.gitignore` to prevent committing copyrighted PDFs to public repo  
**Location:** Root directory `.gitignore` file  
**Configuration:**
```
# Books and reference materials (copyrighted PDFs)
books/
books/*.pdf
```

**Rationale:** 
- Books in `books/` folder are for personal educational use
- Should not be distributed via public GitHub repos
- Learner should maintain their own local copy

**Evidence Required:** `.gitignore` file exists with books/ entry

---

## Evidence Artifacts

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

- **[D12]** GitHub Docs: Branch protection rules. See [Resources](../resources.md#d12) for link.
- **[V7]** Video tutorial on GitHub branch protection. See [Resources](../resources.md#v7) for link.

---

## Links

**Related Documents:**
- [Repository Settings Applied](./repo_settings_applied.md) — Evidence that settings were configured
- [CONTRIBUTING.md](../CONTRIBUTING.md) — Workflow that depends on these settings

---

## Change Log

| Date       | Change Description          | Author |
|------------|-----------------------------|--------|
| 2026-02-28 | Initial checklist created   | Farid  |
