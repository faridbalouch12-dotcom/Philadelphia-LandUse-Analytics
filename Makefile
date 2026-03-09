.PHONY: up down rebuild ingest-districts ingest-permits ingest-zoning ingest-acs ingest-all dbt-run test help

up: ## Start Postgres and Metabase services
	docker compose up -d

down: ## Stop all services
	docker compose down

rebuild: down up ingest-all dbt-run ## Full reset: stop, start, ingest all, run dbt

ingest-districts: ## Ingest planning districts data
	python -m philly_dw.ingest_districts

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

help: ## Show available commands
	@echo "Philadelphia Data Warehouse — available commands:"
	@echo ""
	@echo "  make up                 Start Postgres and Metabase services"
	@echo "  make down               Stop all services"
	@echo "  make rebuild            Full reset: stop, start, ingest all, run dbt"
	@echo "  make ingest-districts   Ingest planning districts data"
	@echo "  make ingest-permits     Ingest L&I permits data"
	@echo "  make ingest-zoning      Ingest zoning data"
	@echo "  make ingest-acs         Ingest ACS data"
	@echo "  make ingest-all         Ingest all datasets in sequence"
	@echo "  make dbt-run            Run dbt transformations"
	@echo "  make test               Run pytest suite"
	@echo "  make help               Show this message"
