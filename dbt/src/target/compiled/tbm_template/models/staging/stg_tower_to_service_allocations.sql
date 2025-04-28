with source as (
    select * from "tbm_db"."public_raw"."tower_to_service_allocations"
),

renamed as (
    select
        allocation_id,
        it_tower_id,
        it_sub_tower_id,
        service_id,
        allocation_method,
        allocation_value,
        description
    from source
)

select * from renamed