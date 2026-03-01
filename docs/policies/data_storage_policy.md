# Data storage policy

**Author:** Farid  
**Created:** 2026-02-28  
**Last Updated:** 2026-03-01  
**Status:** Final  

---

## Purpose

This policy defines which local data and development artifacts can be
committed to the repository and which must stay out of version control.
The goal is to keep the repo lightweight, reproducible, and free of
secrets.

---

## Scope

**In Scope:**
- Local data files and extracted source files
- Environment-specific development artifacts
- Exceptions for small samples and test fixtures

**Out of Scope:**
- Database retention policies
- Remote object storage or cloud bucket policies
- Secret rotation and credential management

---

## Storage rules

### 1. No shapefiles or GeoPackage files

**Core principle:** Raw shapefiles and GeoPackage files are not committed.

**Rationale:** These files can be tens or hundreds of megabytes each. If
committed, they permanently inflate Git history even after deletion.

**Rules:** `*.shp`, `*.gpkg`, `*.dbf`, `*.prj`, `*.shx`, and `*.cpg`
must be ignored via `.gitignore`.

**Exceptions:** None.

### 2. No `.env` files

**Core principle:** `.env` files are not committed.

**Rationale:** `.env` files may contain secrets such as API keys,
passwords, and connection strings.

**Rules:** `.env` files must be ignored via `.gitignore`. Commit an
example file such as `.env.example` instead.

**Exceptions:** None.

### 3. No local virtual environment folders

**Core principle:** Machine-specific virtual environments are not
committed.

**Rationale:** Virtual environments are local-only artifacts and can be
very large, which makes clones slower and history noisier.

**Rules:** Any `.venv` folder must be ignored via `.gitignore`.

**Exceptions:** None.

### 4. No raw `.csv` files

**Core principle:** Raw `.csv` files are not committed by default.

**Rationale:** CSV extracts can be large and can quickly bloat the
repository if committed directly.

**Rules:** `*.csv` files must be ignored via `.gitignore`.

**Exceptions:** Small representative samples may be committed under
`data/samples`, and CSV fixtures for tests are allowed under
`tests/fixtures`.

### 5. No Python cache artifacts

**Core principle:** Python cache files and notebook checkpoint artifacts
are not committed.

**Rationale:** These files are generated locally and do not belong in
source control.

**Rules:** `*.pyc`, `.ipynb_checkpoints`, and `__pycache__` must be
ignored via `.gitignore`.

**Exceptions:** None.

### 6. Ignore the `large_data` folder

**Core principle:** `large_data` is reserved for local-only large
extracts.

**Rationale:** This folder may hold large intermediate or source data
that should not enter Git history.

**Rules:** The `large_data/` folder must be ignored via `.gitignore`.

**Exceptions:** None.

---

## Change log

| Date       | Change Description                         | Author |
|------------|--------------------------------------------|--------|
| 2026-02-28 | Initial policy created                     | Farid  |
| 2026-03-01 | Added structure and clarified rule wording | Farid  |
