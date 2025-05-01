with

entries as (
  SELECT
    fiscal_year,
    sum(amount) as entry_sum
  FROM
    {{ ref('stg__entries_cost') }}
  GROUP BY
      fiscal_year
),

twoers as (
  SELECT
      fiscal_year,
      sum(allocated_amount) as tower_sum
  FROM
    {{ ref('cost_to_tower') }}
  GROUP BY
      fiscal_year
),

services as (
  SELECT
      fiscal_year,
      sum(allocated_amount) as service_sum
  FROM
    {{ ref('tower_to_service') }}
  GROUP BY
      fiscal_year
),

business_unit as (
  SELECT
      fiscal_year,
      sum(allocated_amount) as business_unit_sum
  FROM
    {{ ref('service_to_business') }}
  GROUP BY
      fiscal_year
),

capability as (
  SELECT
      fiscal_year,
      round(sum(allocated_amount)::numeric, 0) as capability_sum
  FROM
    {{ ref('service_to_capability') }}
  GROUP BY
      fiscal_year
),

final as (
  SELECT
      e.fiscal_year,
      e.entry_sum,
      t.tower_sum,
      s.service_sum,
      b.business_unit_sum,
      c.capability_sum,
      t.tower_sum - e.entry_sum as tower_diff,
      s.service_sum - t.tower_sum as service_diff,
      b.business_unit_sum - s.service_sum as business_unit_diff,
      c.capability_sum - b.business_unit_sum as capability_diff
  FROM
    entries e
  LEFT JOIN twoers t ON e.fiscal_year = t.fiscal_year
  LEFT JOIN services s ON e.fiscal_year = s.fiscal_year
  LEFT JOIN business_unit b ON e.fiscal_year = b.fiscal_year
  LEFT JOIN capability c ON e.fiscal_year = c.fiscal_year
)

-- 丸め誤差は許容
SELECT
    fiscal_year,
    'tower_diff' as problem_area,
    tower_diff as difference
FROM
    final
WHERE
    ABS(tower_diff) >= 10

UNION ALL

SELECT
    fiscal_year,
    'service_diff' as problem_area,
    service_diff as difference
FROM
    final
WHERE
    ABS(service_diff) >= 10

UNION ALL

SELECT
    fiscal_year,
    'business_unit_diff' as problem_area,
    business_unit_diff as difference
FROM
    final
WHERE
    ABS(business_unit_diff) >= 10

UNION ALL

SELECT
    fiscal_year,
    'capability_diff' as problem_area,
    capability_diff as difference
FROM
    final
WHERE
    ABS(capability_diff) >= 10
