with service_costs as (
    select * from {{ ref('tower_to_service') }}
),

business_units as (
    select * from {{ ref('stg__master__business_units') }}
),

allocations as (
    select * from {{ ref('stg__allocations__service_to_business') }}
),

-- テクノロジーサービスコストとビジネスユニットへの配賦
service_to_business_allocation as (
    select
        sc.fiscal_year,
        sc.fiscal_month,
        sc.cost_pool_id,
        sc.cost_pool_name,
        sc.cost_sub_pool_id,
        sc.cost_sub_pool_name,
        sc.it_tower_id,
        sc.it_tower_name,
        sc.it_sub_tower_id,
        sc.it_sub_tower_name,
        sc.service_id,
        sc.service_name,
        sc.service_type,
        a.business_unit_id,
        bu.business_unit_name,
        bu.employee_count,
        bu.parent_id,
        a.allocation_method,
        a.allocation_value,
        ROUND((sc.allocated_amount * a.allocation_value)::numeric, 0) as allocated_amount,
        sc.vendor,
        sc.cost_description,
        sc.tower_allocation_description,
        sc.service_allocation_description,
        a.description as business_allocation_description
    from service_costs sc
    inner join allocations a 
        on sc.fiscal_year = a.fiscal_year
        and sc.fiscal_month = a.fiscal_month
        and sc.service_id = a.service_id
    left join business_units bu
        on a.fiscal_year = bu.fiscal_year
        and a.fiscal_month = bu.fiscal_month
        and a.business_unit_id = bu.business_unit_id
)

select * from service_to_business_allocation
