with tower_costs as (
    select * from {{ ref('cost_to_tower') }}
),

tech_services as (
    select * from {{ ref('stg__master__it_services') }}
),

allocations as (
    select * from {{ ref('stg__allocations__tower_to_service') }}
),

-- ITタワーコストとテクノロジーサービスへの配賦
tower_to_service_allocation as (
    select
        tc.fiscal_year,
        tc.fiscal_month,
        tc.cost_pool_id,
        tc.cost_pool_name,
        tc.cost_sub_pool_id,
        tc.cost_sub_pool_name,
        tc.it_tower_id,
        tc.it_tower_name,
        tc.it_sub_tower_id,
        tc.it_sub_tower_name,
        a.service_id,
        ts.service_name,
        ts.service_type,
        a.allocation_method,
        a.allocation_value,
        tc.allocated_amount * a.allocation_value as allocated_amount,
        tc.vendor,
        tc.description as cost_description,
        tc.allocation_description as tower_allocation_description,
        a.description as service_allocation_description
    from tower_costs tc
    inner join allocations a 
        on tc.fiscal_year = a.fiscal_year
        and tc.fiscal_month = a.fiscal_month
        and tc.it_tower_id = a.it_tower_id 
        and tc.it_sub_tower_id = a.it_sub_tower_id
    left join tech_services ts on a.service_id = ts.service_id
)

select * from tower_to_service_allocation
