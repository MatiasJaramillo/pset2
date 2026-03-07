-- Docs: https://docs.mage.ai/guides/sql-blocks
SELECT
  source_month AS year_month,
  service_type,
  COUNT(*) AS row_count
FROM bronze.trips_raw
GROUP BY 1, 2
ORDER BY 1, 2;