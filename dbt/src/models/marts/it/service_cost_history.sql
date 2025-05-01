with service_costs as (
    select * from {{ ref('tower_to_service') }}
),

-- テクノロジーサービス別の集計
service_cost_summary as (
    select
        MAKE_TIMESTAMP(fiscal_year, fiscal_month, 1, 0, 0, 0) as time,
        fiscal_year,
        fiscal_month,
        service_id,
        service_name,
        service_type,
        sum(allocated_amount) as total_allocated_amount,
        count(*) as entry_count
    from service_costs
    group by 1, 2, 3, 4, 5, 6
)

select * from service_cost_summary
