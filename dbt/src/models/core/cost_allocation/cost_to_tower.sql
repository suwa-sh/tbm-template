with cost_entries as (
    select * from {{ ref('stg_cost_entries') }}
),

cost_pools as (
    select * from {{ ref('stg_cost_pools') }}
),

cost_sub_pools as (
    select * from {{ ref('stg_cost_sub_pools') }}
),

it_towers as (
    select * from {{ ref('stg_it_towers') }}
),

it_sub_towers as (
    select * from {{ ref('stg_it_sub_towers') }}
),

allocations as (
    select * from {{ ref('stg_cost_to_tower_allocations') }}
),

-- コスト項目とコストプール・サブプールの結合
cost_entries_with_pools as (
    select
        ce.cost_entry_id,
        ce.fiscal_year,
        ce.fiscal_month,
        ce.cost_pool_id,
        cp.cost_pool_name,
        ce.cost_sub_pool_id,
        csp.cost_sub_pool_name,
        ce.vendor,
        ce.description,
        ce.amount
    from cost_entries ce
    left join cost_pools cp on ce.cost_pool_id = cp.cost_pool_id
    left join cost_sub_pools csp on ce.cost_sub_pool_id = csp.cost_sub_pool_id
),

-- コスト項目とITタワーへの配賦
cost_to_tower_allocation as (
    select
        ce.cost_entry_id,
        ce.fiscal_year,
        ce.fiscal_month,
        ce.cost_pool_id,
        ce.cost_pool_name,
        ce.cost_sub_pool_id,
        ce.cost_sub_pool_name,
        a.it_tower_id,
        it.it_tower_name,
        a.it_sub_tower_id,
        ist.it_sub_tower_name,
        a.allocation_method,
        a.allocation_value,
        ce.amount * a.allocation_value as allocated_amount,
        ce.vendor,
        ce.description,
        a.description as allocation_description
    from cost_entries_with_pools ce
    inner join allocations a 
        on ce.cost_pool_id = a.cost_pool_id 
        and ce.cost_sub_pool_id = a.cost_sub_pool_id
    left join it_towers it on a.it_tower_id = it.it_tower_id
    left join it_sub_towers ist on a.it_sub_tower_id = ist.it_sub_tower_id
)

select * from cost_to_tower_allocation
