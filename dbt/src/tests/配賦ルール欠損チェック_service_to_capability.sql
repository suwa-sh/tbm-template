-- サービスからケイパビリティへの配賦ルールの欠損をチェック
SELECT 
    ts.fiscal_year,
    ts.fiscal_month,
    ts.service_id,
    COUNT(*) as missing_records
FROM {{ ref('tower_to_service') }} ts
LEFT JOIN {{ ref('stg__allocations__service_to_capability') }} cap
  ON ts.service_id = cap.service_id
  AND ts.fiscal_year = cap.fiscal_year
  AND ts.fiscal_month = cap.fiscal_month
WHERE cap.service_id IS NULL
GROUP BY ts.fiscal_year, ts.fiscal_month, ts.service_id