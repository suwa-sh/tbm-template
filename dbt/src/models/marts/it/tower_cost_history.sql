with tower_costs as (
    select * from {{ ref('cost_to_tower') }}
),

-- ITタワー別の集計
tower_cost_summary as (
    select
        MAKE_TIMESTAMP(fiscal_year, fiscal_month, 1, 0, 0, 0) as time,
        fiscal_year,
        fiscal_month,
        it_tower_id,
        it_tower_name,
        it_sub_tower_id,
        it_sub_tower_name,
        sum(allocated_amount) as total_allocated_amount,
        count(*) as entry_count
    from tower_costs
    group by 1, 2, 3, 4, 5, 6, 7
)

select * from tower_cost_summary
