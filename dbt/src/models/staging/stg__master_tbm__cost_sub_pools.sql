with source as (
    select * from {{ ref('master_tbm__cost_sub_pools') }}
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
