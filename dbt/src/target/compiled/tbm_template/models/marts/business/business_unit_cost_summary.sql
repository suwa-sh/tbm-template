with business_costs as (
    select * from "tbm_db"."public"."service_to_business"
),

-- ビジネスユニット別の集計
business_unit_cost_summary as (
    select
        fiscal_year,
        fiscal_month,
        business_unit_id,
        business_unit_name,
        parent_id,
        employee_count,
        sum(allocated_amount) as total_allocated_amount,
        count(distinct service_id) as service_count
    from business_costs
    group by 1, 2, 3, 4, 5, 6
)

select * from business_unit_cost_summary