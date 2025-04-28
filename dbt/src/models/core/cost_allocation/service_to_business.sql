with service_costs as (
    select * from {{ ref('tower_to_service') }}
),

business_units as (
    select * from {{ ref('stg_business_units') }}
),

allocations as (
    select * from {{ ref('stg_service_to_business_allocations') }}
),

-- テクノロジーサービスコストとビジネスユニットへの配賦
service_to_business_allocation as (
    select
        sc.cost_entry_id,
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
        sc.allocated_amount * a.allocation_value as allocated_amount,
        sc.vendor,
        sc.cost_description,
        sc.tower_allocation_description,
        sc.service_allocation_description,
        a.description as business_allocation_description
    from service_costs sc
    inner join allocations a on sc.service_id = a.service_id
    left join business_units bu on a.business_unit_id = bu.business_unit_id
)

select * from service_to_business_allocation
