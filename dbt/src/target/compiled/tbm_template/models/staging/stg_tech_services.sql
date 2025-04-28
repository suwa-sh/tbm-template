with source as (
    select * from "tbm_db"."public_raw"."tech_services"
),

renamed as (
    select
        service_id,
        service_name,
        description,
        service_type
    from source
)

select * from renamed