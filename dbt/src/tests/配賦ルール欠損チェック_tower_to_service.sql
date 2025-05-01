-- タワーからサービスへの配賦ルールの欠損をチェック
SELECT 
    tc.fiscal_year,
    tc.it_tower_id,
    tc.it_sub_tower_id
FROM {{ ref('cost_to_tower') }} tc
LEFT JOIN {{ ref('stg__allocations__tower_to_service') }} a
   ON tc.fiscal_year = a.fiscal_year
   AND tc.fiscal_month = a.fiscal_month
   AND tc.it_tower_id = a.it_tower_id
   AND tc.it_sub_tower_id = a.it_sub_tower_id
WHERE a.it_tower_id IS NULL
GROUP BY tc.fiscal_year, tc.it_tower_id, tc.it_sub_tower_id