CREATE TABLE raw.ingestion_logs (
    log_id SERIAL PRIMARY KEY,
    schema_name VARCHAR NOT NULL,
    table_name VARCHAR NOT NULL,
    source_url VARCHAR NOT NULL,
    row_count INTEGER NOT NULL,
    loaded_at  TIMESTAMP NOT NULL DEFAULT NOW()
);
