-- Immutable landed source data from APIs — written by Python ingestion pipeline only
CREATE SCHEMA IF NOT EXISTS raw;

-- Cleaned, renamed, type-standardized source tables — written by dbt stg_* models
CREATE SCHEMA IF NOT EXISTS staging;

-- Spatial joins, district assignment, overlap calculations — written by dbt int_* models
CREATE SCHEMA IF NOT EXISTS intermediate;

-- Conformed dimensions, fact tables, bridge tables — analyst-facing; written by dbt dim_*, fct_*, bridge_* models
CREATE SCHEMA IF NOT EXISTS marts;

-- Purpose-built dashboard aggregations — Metabase-only consumers; written by dbt agg_* models
CREATE SCHEMA IF NOT EXISTS analytics;
