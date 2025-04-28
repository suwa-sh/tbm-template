with source as (
    select * from {{ ref('cost_to_tower_allocations') }}
),

renamed as (
    select
        allocation_id,
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
