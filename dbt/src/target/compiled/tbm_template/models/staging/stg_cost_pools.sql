with source as (
    select * from "tbm_db"."public_raw"."cost_pools"
),

renamed as (
    select
        cost_pool_id,
        cost_pool_name,
        description
    from source
)

select * from renamed