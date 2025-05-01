with business_costs as (
    select * from {{ ref('service_to_business') }}
),

plan as (
    select * from {{ ref('stg__entries_plan') }}
),

-- ビジネスユニット別の集計
summary as (
    select
        MAKE_TIMESTAMP(fiscal_year, fiscal_month, 1, 0, 0, 0) as time,
        fiscal_year,
        fiscal_month,
        business_unit_id,
        business_unit_name,
        parent_id,
        employee_count,
        sum(allocated_amount) as total_allocated_amount,
        case 
            when employee_count > 0 then ROUND((sum(allocated_amount) / employee_count::numeric)::numeric, 0)
            else 0
        end as unit_cost_per_employee,
        count(distinct service_id) as service_count
    from business_costs bc
    where business_unit_id is not null
    group by 1, 2, 3, 4, 5, 6, 7
),


final as (
    select
        s.time,
        s.fiscal_year,
        s.fiscal_month,
        s.business_unit_id,
        s.business_unit_name,
        s.parent_id,
        s.employee_count,
        plan.amount as plan_amount,
        s.total_allocated_amount,
        s.unit_cost_per_employee,
        s.service_count
    from summary s
    inner join plan
        on s.fiscal_year = plan.fiscal_year
        and s.fiscal_month = plan.fiscal_month
        and s.business_unit_id = plan.business_unit_id
)

select * from final
