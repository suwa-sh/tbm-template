with source as (
    select * from {{ ref('cost_sub_pools') }}
),

renamed as (
    select
        cost_sub_pool_id,
        cost_pool_id,
        cost_sub_pool_name,
        description
    from source
)

select * from renamed
