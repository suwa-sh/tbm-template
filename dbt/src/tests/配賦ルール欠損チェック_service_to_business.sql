-- サービスからビジネスユニットへの配賦ルールの欠損をチェック 
SELECT 
    ts.fiscal_year,
    ts.service_id,
    COUNT(*) as missing_records
FROM {{ ref('tower_to_service') }} ts
LEFT JOIN {{ ref('stg__allocations__service_to_business') }} bu
  ON ts.service_id = bu.service_id
  AND ts.fiscal_year = bu.fiscal_year
WHERE bu.service_id IS NULL
GROUP BY ts.fiscal_year, ts.service_id
