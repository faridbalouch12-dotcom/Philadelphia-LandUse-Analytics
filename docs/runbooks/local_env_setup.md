# Local Environment Setup

**Purpose:** Configure local environment variables for the Philadelphia Land Use Analytics warehouse.
**Audience:** Any developer running the project locally.
**Last updated:** 2026-03-09

---

## Overview

Runtime configuration (database credentials, connection settings) is managed via a `.env` file that is **never committed to version control**. The `.env.example` file in the repo root documents all required variables with safe placeholder values.

---

## Setup Steps

### 1. Copy the example file

```bash
cp .env.example .env
```

### 2. Fill in your local values

Open `.env` and set each variable for your environment:

| Variable | Description | Local default |
|---|---|---|
| `POSTGRES_HOST` | Postgres server hostname | `localhost` (host) or `db` (inside Compose) |
| `POSTGRES_PORT` | Postgres port | `5432` |
| `POSTGRES_DB` | Database name | `philly_dw` |
| `POSTGRES_USER` | Database user | `philly` |
| `POSTGRES_PASSWORD` | Database password | *(set your own)* |

> **Note on `POSTGRES_HOST`:** When running Python loaders from your host machine, use `localhost`. When a service inside Docker Compose connects to the `db` service, use `db` (the Compose service name).

### 3. Verify the file is gitignored

Confirm `.env` appears in `.gitignore` before proceeding. It should already be listed. Never force-add it.

---

## How variables are consumed

**Python loaders** — `src/philly_dw/config.py` reads these variables via `os.environ`. Load the `.env` file before running any loader script (e.g. with `python-dotenv` or by sourcing the file in your shell).

**dbt** — `profiles.yml` references these variables via dbt's `env_var()` function. The same `.env` values apply; ensure they are exported in your shell when running `dbt run` or `dbt test`.

---

## Troubleshooting

**`ModuleNotFoundError: No module named 'philly_dw'`** — Run `pip install -e .` from the repo root inside your virtual environment.

**`connection refused` on port 5432** — Confirm the Docker Compose stack is running (`docker compose up db`) before executing Python loaders or dbt commands from the host.
