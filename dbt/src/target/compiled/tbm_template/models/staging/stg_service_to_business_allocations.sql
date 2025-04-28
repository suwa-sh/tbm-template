with source as (
    select * from "tbm_db"."public_raw"."service_to_business_allocations"
),

renamed as (
    select
        allocation_id,
        service_id,
        business_unit_id,
        allocation_method,
        allocation_value,
        description
    from source
)

select * from renamed