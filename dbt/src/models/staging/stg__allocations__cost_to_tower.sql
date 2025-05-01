with source as (
    select * from {{ ref('allocations__cost_to_tower') }}
),

renamed as (
    select
        fiscal_year,
        fiscal_month,
        cost_pool_id,
        cost_sub_pool_id,
        it_tower_id,
        it_sub_tower_id,
        allocation_method,
        allocation_value,
        description
    from source
)

select * from renamed
