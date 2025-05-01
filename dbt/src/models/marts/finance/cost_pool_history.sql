with entries_cost as (
    select * from {{ ref('stg__entries_cost') }}
),

cost_pools as (
    select * from {{ ref('stg__master_tbm__cost_pools') }}
),

cost_sub_pools as (
    select * from {{ ref('stg__master_tbm__cost_sub_pools') }}
),

-- コストプール別の集計
cost_pool_summary as (
    select
        MAKE_TIMESTAMP(fiscal_year, fiscal_month, 1, 0, 0, 0) as time,
        ce.fiscal_year,
        ce.fiscal_month,
        ce.cost_pool_id,
        cp.cost_pool_name,
        ce.cost_sub_pool_id,
        csp.cost_sub_pool_name,
        sum(ce.amount) as total_amount,
        count(*) as entry_count
    from entries_cost ce
    left join cost_pools cp on ce.cost_pool_id = cp.cost_pool_id
    left join cost_sub_pools csp on ce.cost_sub_pool_id = csp.cost_sub_pool_id
    group by 1, 2, 3, 4, 5, 6, 7
)

select * from cost_pool_summary
