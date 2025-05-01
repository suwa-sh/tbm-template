with
plan_history as (
    select * from {{ ref('stg__entries_plan') }}
),
cost_history as (
    select * from {{ ref('business_unit_cost_history') }}
),

-- 全社で集計
company_cost as (
    select
        fiscal_year,
        fiscal_month,
        sum(employee_count) as employee_count,
        sum(total_allocated_amount) as amount
    from cost_history
    group by 1, 2
),
company_plan as (
    select
        fiscal_year,
        fiscal_month,
        sum(amount) as amount
    from plan_history
    group by 1, 2
),

final as (
    select
        MAKE_TIMESTAMP(cp.fiscal_year, cp.fiscal_month, 1, 0, 0, 0) as time,
        cp.fiscal_year,
        cp.fiscal_month,
        cc.employee_count,
        cp.amount as plan_amount,
        cc.amount as cost_amount,
        case 
            when cc.employee_count > 0 then ROUND((cp.amount / cc.employee_count::numeric)::numeric, 0)
            else 0
        end as unit_cost_per_employee
    from company_plan as cp
    inner join company_cost as cc on cc.fiscal_year = cp.fiscal_year
)

select * from final
