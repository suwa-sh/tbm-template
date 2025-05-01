with source as (
    select * from {{ ref('master_tbm__cost_pools') }}
),

renamed as (
    select
        cost_pool_id,
        cost_pool_name,
        description
    from source
)

select * from renamed
