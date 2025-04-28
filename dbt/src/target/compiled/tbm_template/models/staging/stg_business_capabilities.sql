with source as (
    select * from "tbm_db"."public_raw"."business_capabilities"
),

renamed as (
    select
        capability_id,
        capability_name,
        description,
        capability_type
    from source
)

select * from renamed