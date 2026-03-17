SELECT
    TO_CHAR(datum, 'YYYYMMDD')::INT AS date_key,
    datum AS date_actual,
    TO_CHAR(datum, 'TMDay') AS day_name,
    EXTRACT(ISODOW FROM datum)::INT AS day_of_week,
    EXTRACT(MONTH FROM datum)::INT AS month_actual,
    TO_CHAR(datum, 'TMMonth') AS month_name,
    EXTRACT(QUARTER FROM datum)::INT AS quarter_actual,
    EXTRACT(YEAR FROM datum)::INT AS year_actual,
    CASE WHEN EXTRACT(ISODOW FROM datum) IN (6, 7) THEN TRUE ELSE FALSE END AS weekend_indr
FROM GENERATE_SERIES('2020-01-01'::DATE, '2030-12-31'::DATE, '1 day'::INTERVAL) AS datum

