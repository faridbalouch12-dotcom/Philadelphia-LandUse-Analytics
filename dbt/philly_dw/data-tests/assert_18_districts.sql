SELECT 1 
FROM {{ ref('dim_district') }}
HAVING count(*) != 18