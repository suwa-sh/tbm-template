with

tower_sum as (
    select
        fiscal_year,
        it_tower_id,
        round(sum(allocation_value)::numeric, 0) as allocation_value
    from
        {{ ref('stg__allocations__tower_to_service') }}
    group by
        fiscal_year, it_tower_id
),

sub_tower_sum as (
    select
        fiscal_year,
        it_tower_id,
        it_sub_tower_id,
        round(sum(allocation_value)::numeric, 0) as allocation_value
    from
        {{ ref('stg__allocations__tower_to_service') }}
    group by
        fiscal_year, it_tower_id, it_sub_tower_id
),

final as (
    select
        ts.fiscal_year,
        ts.it_tower_id,
        ts.allocation_value as sum,
        ss.it_sub_tower_id,
        ss.allocation_value as sub_sum
    from
        tower_sum ts
    left join
        sub_tower_sum ss on
            ts.fiscal_year = ss.fiscal_year
            and ts.it_tower_id = ss.it_tower_id
)

select * from final order by 1, 2
