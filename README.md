# Philadelphia-LandUse-Analytics

An analytics platform that explains how Philadelphia's 18 planning districts change over time, using public datasets — building permits (L&I), zoning reclassifications, and ACS demographic context.

## Current status

> **Month 2 in progress — building the local MVP.**
> Month 1 (design & documentation) is complete. Now implementing Dockerized Postgres/PostGIS, Python ingestion, dbt models, and Metabase dashboards.

| Component | Status |
|-----------|--------|
| Warehouse design (grain, schema contracts, ERD) | ✅ Complete |
| Dataset cataloging (4 datasets) | ✅ Complete |
| Metric specifications (7 metrics) | ✅ Complete |
| Product specs (district brief, compare view) | ✅ Complete |
| Docker Compose stack (Postgres + PostGIS + Metabase) | ✅ Running |
| Database bootstrap (schemas, extensions) | ✅ Verified |
| Python project scaffold | ✅ Complete |
| dbt project scaffold | 🔧 In progress (Day 26) |
| Planning districts vertical slice | 🔲 Week 6 |
| Permits vertical slice | 🔲 Week 7 |
| Zoning vertical slice | 🔲 Week 8 |
| ACS + dashboards | 🔲 Week 9 |

## Locked decisions

- **Stack:** Postgres + PostGIS + Python + dbt + Metabase + Docker
- **Modeling:** dbt `stg_*` → `dim_*/fct_*` with district-time grain
- **Metric normalization:** By land area (e.g., permits per sq mi)
- **Time scope:** Last 5 years
- **Comparison period:** Year-over-year
- **MVP scope:** Permits + zoning + ACS + district boundaries
- **Environment:** Local dev via Docker Compose; cloud out of scope

## Repo layout

```
├── docker/          # Compose file, service configs
├── src/philly_dw/   # Python ingestion package
├── dbt/philly_dw/   # dbt project
├── data/            # Local dev samples (not committed)
├── docs/            # Curated documentation (see docs index)
├── notes/           # Reading notes, scratch work
└── sql/             # Bootstrap SQL, ad-hoc queries
```

## Quick start

```bash
# Copy environment template
cp .env.example .env

# Start the stack
docker compose up -d

# Verify services
docker compose ps
make db-check
```

See [local dev runbook](docs/runbooks/local_dev.md) for full setup instructions.

## Documentation

Full docs index with one-line summaries: **[docs/README.md](docs/README.md)**

Key entry points:
- [Grain spec](docs/modeling/grain_spec.md) — row-level grain for all warehouse tables
- [ERD diagram](docs/diagrams/erd.mmd) — full MVP schema (Mermaid)
- [Decision log](docs/decision_log.md) — 17 locked architectural decisions
- [Limitations register](docs/limitations_register.md) — known constraints and mitigations

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for workflow, branch naming, PR checklist, and local checks.
