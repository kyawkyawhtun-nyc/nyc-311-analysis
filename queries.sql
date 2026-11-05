-- NYC 311 Damaged Tree analysis — BigQuery
-- Dataset: bigquery-public-data.new_york_311.311_service_requests
-- NOTE: this BigQuery copy is frozen (last modified 2021-11-09, data through 2021).
-- For current data, use the NYC Open Data API (Socrata / SoQL).

-- Top Damaged Tree ZIP code per borough, 2021
-- (CTE + window function: rank ZIPs inside each borough, keep rank 1)
WITH counts AS (
  SELECT
    borough,
    incident_zip,
    COUNT(*) AS n
  FROM `bigquery-public-data.new_york_311.311_service_requests`
  WHERE EXTRACT(YEAR FROM created_date) = 2021
    AND complaint_type = 'Damaged Tree'   -- spelling must be exact; a typo returns zero rows
    AND incident_zip IS NOT NULL
  GROUP BY borough, incident_zip
),
ranked AS (
  SELECT
    borough,
    incident_zip,
    n,
    ROW_NUMBER() OVER (PARTITION BY borough ORDER BY n DESC) AS rn
  FROM counts
)
SELECT borough, incident_zip, n
FROM ranked
WHERE rn = 1
ORDER BY borough;

-- Result (2021): Bronx 10465 · Brooklyn 11234 · Manhattan 10031 · Queens 11385 · Staten Island 10314
-- 2024 comparison (NYC Open Data API, SoQL): Bronx 10469 (336) · Brooklyn 11234 (973) ·
-- Manhattan 10031 (112) · Queens 11385 (693) · Staten Island 10312 (674)
-- 3 of 5 boroughs identical across both years -> hotspots are sticky.
