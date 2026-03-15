.PHONY: up down reset-analytics reset-transforms reset-data reset-nuclear ingest-districts ingest-permits ingest-zoning ingest-acs ingest-all dbt-run test lint help

up: ## Start Postgres and Metabase services
	docker compose -f docker/docker-compose.yml up -d

down: ## Stop all services
	docker compose -f docker/docker-compose.yml down

reset-analytics: ## Drop analytics schema and rebuild — use when agg output is wrong
	docker compose -f docker/docker-compose.yml exec -T postgres_philly_dw \
	  psql -U philly -d philly_dw \
	  -c "DROP SCHEMA IF EXISTS analytics CASCADE; CREATE SCHEMA analytics;"
	python -m philly_dw.agg_district_acs_attributes_hist

reset-transforms: ## Drop intermediate+marts+analytics and re-run dbt — use when dbt model is broken
	docker compose -f docker/docker-compose.yml exec -T postgres_philly_dw \
	  psql -U philly -d philly_dw \
	  -c "DROP SCHEMA IF EXISTS analytics CASCADE; CREATE SCHEMA analytics;" \
	  -c "DROP SCHEMA IF EXISTS marts CASCADE; CREATE SCHEMA marts;" \
	  -c "DROP SCHEMA IF EXISTS intermediate CASCADE; CREATE SCHEMA intermediate;"
	dbt run --profiles-dir .
	python -m philly_dw.agg_district_acs_attributes_hist

reset-data: ## Drop all schemas and re-ingest from APIs — use when source data is stale
	docker compose -f docker/docker-compose.yml exec -T postgres_philly_dw \
	  psql -U philly -d philly_dw \
	  -c "DROP SCHEMA IF EXISTS analytics CASCADE; CREATE SCHEMA analytics;" \
	  -c "DROP SCHEMA IF EXISTS marts CASCADE; CREATE SCHEMA marts;" \
	  -c "DROP SCHEMA IF EXISTS intermediate CASCADE; CREATE SCHEMA intermediate;" \
	  -c "DROP SCHEMA IF EXISTS staging CASCADE; CREATE SCHEMA staging;" \
	  -c "DROP SCHEMA IF EXISTS raw CASCADE; CREATE SCHEMA raw;"
	$(MAKE) ingest-all
	dbt run --profiles-dir .
	python -m philly_dw.agg_district_acs_attributes_hist

reset-nuclear: ## Destroy Docker volume and rebuild from scratch — last resort
	docker compose -f docker/docker-compose.yml down -v
	docker compose -f docker/docker-compose.yml up -d --wait
	$(MAKE) ingest-all
	dbt run --profiles-dir .
	python -m philly_dw.agg_district_acs_attributes_hist

ingest-districts: ## Ingest planning districts data
	python -m philly_dw.ingest.planning_districts

ingest-permits: ## Ingest L&I permits data
	python -m philly_dw.ingest_permits

ingest-zoning: ## Ingest zoning data
	python -m philly_dw.ingest_zoning

ingest-acs: ## Ingest ACS data
	python -m philly_dw.ingest_acs

ingest-all: ingest-districts ingest-permits ingest-zoning ingest-acs ## Ingest all datasets in sequence

dbt-run: ## Run dbt transformations
	dbt run --profiles-dir .

test: ## Run pytest suite
	pytest tests/

lint: ## Run pylint on source and tests
	pylint src/ tests/

help: ## Show available commands
	@echo "Philadelphia Data Warehouse — available commands:"
	@echo ""
	@echo "  make up                   Start Postgres and Metabase services"
	@echo "  make down                 Stop all services"
	@echo ""
	@echo "  Reset commands (see docs/runbooks/local_reset.md for when to use each):"
	@echo "  make reset-analytics      Drop analytics schema and rebuild agg model"
	@echo "  make reset-transforms     Drop intermediate+marts+analytics and re-run dbt"
	@echo "  make reset-data           Drop all schemas and re-ingest from APIs"
	@echo "  make reset-nuclear        Destroy Docker volume and rebuild from scratch"
	@echo ""
	@echo "  make ingest-districts     Ingest planning districts data"
	@echo "  make ingest-permits       Ingest L&I permits data"
	@echo "  make ingest-zoning        Ingest zoning data"
	@echo "  make ingest-acs           Ingest ACS data"
	@echo "  make ingest-all           Ingest all datasets in sequence"
	@echo "  make dbt-run              Run dbt transformations"
	@echo "  make test                 Run pytest suite"
	@echo "  make lint                 Run pylint on source and tests"
	@echo "  make help                 Show this message"
