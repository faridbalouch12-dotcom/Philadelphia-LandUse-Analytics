SELECT
    district_id,
    land_area_sqmi
FROM {{ ref('stg_planning_districts') }}
WHERE land_area_sqmi <= 0