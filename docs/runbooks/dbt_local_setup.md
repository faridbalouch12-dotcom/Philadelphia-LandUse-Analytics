# Runbook: dbt local setup

**Author:** Farid
**Created:** 2026-03-11
**Status:** Active

---

## Prerequisites

- Python 3.11+ with `dbt-postgres` installed (`pip install dbt-postgres`)
- Docker Desktop running
- Repo cloned locally

Verify dbt is installed:

```bash
dbt --version
```

Expected: `dbt version: 1.11.x` or later.

---

## Setup steps

### 1. Configure environment variables

Copy the example env file and fill in your values:

```bash
cp .env.example .env
```

The dbt profile reads these variables at runtime:

| Variable | Default | Description |
|----------|---------|-------------|
| `POSTGRES_HOST` | `localhost` | Postgres host |
| `POSTGRES_PORT` | `5432` | Postgres port |
| `POSTGRES_USER` | `philly` | Database user |
| `POSTGRES_PASSWORD` | `changeme` | Database password |
| `POSTGRES_DB` | `philly_dw` | Database name |

### 2. Start the stack

```bash
make up
```

Wait for both services to report `healthy`:

```bash
docker compose ps
```

### 3. Verify the dbt connection

```bash
cd dbt/philly_dw
dbt debug
```

Expected output ends with `All checks passed!`

### 4. Ingest source data

```bash
make ingest-all
```

This runs all Python ingestion scripts and lands raw data into the `raw` schema.

### 5. Run dbt models

```bash
dbt run
```

Run a single model:

```bash
dbt run --select stg_planning_districts
```

Run with tests:

```bash
dbt build
```

---

## Troubleshooting

**`Connection refused` on `dbt debug`**
The Postgres container is not running or not yet healthy. Check `docker compose ps` and wait for the healthcheck to pass.

**`profile not found`**
Run `dbt debug` from inside `dbt/philly_dw/`, not from the repo root. The profiles dir is co-located with the project.

**`schema "raw" does not exist`**
The database bootstrap SQL hasn't run yet. Run `make db-bootstrap` or see [db_bootstrap_verification.md](./db_bootstrap_verification.md).
