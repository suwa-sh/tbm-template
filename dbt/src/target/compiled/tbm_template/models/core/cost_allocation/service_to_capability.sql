with service_costs as (
    select * from "tbm_db"."public"."tower_to_service"
),

business_capabilities as (
    select * from "tbm_db"."public"."stg_business_capabilities"
),

allocations as (
    select * from "tbm_db"."public"."stg_service_to_capability_allocations"
),

-- テクノロジーサービスコストとビジネスケイパビリティへの配賦
service_to_capability_allocation as (
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
        a.capability_id,
        bc.capability_name,
        bc.capability_type,
        a.allocation_method,
        a.allocation_value,
        sc.allocated_amount * a.allocation_value as allocated_amount,
        sc.vendor,
        sc.cost_description,
        sc.tower_allocation_description,
        sc.service_allocation_description,
        a.description as capability_allocation_description
    from service_costs sc
    inner join allocations a on sc.service_id = a.service_id
    left join business_capabilities bc on a.capability_id = bc.capability_id
)

select * from service_to_capability_allocation