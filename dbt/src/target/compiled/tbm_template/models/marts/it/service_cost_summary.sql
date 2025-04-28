with service_costs as (
    select * from "tbm_db"."public"."tower_to_service"
),

-- テクノロジーサービス別の集計
service_cost_summary as (
    select
        fiscal_year,
        fiscal_month,
        service_id,
        service_name,
        service_type,
        sum(allocated_amount) as total_allocated_amount,
        count(distinct cost_entry_id) as entry_count
    from service_costs
    group by 1, 2, 3, 4, 5
)

select * from service_cost_summary