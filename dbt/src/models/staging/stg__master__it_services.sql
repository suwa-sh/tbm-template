with source as (
    select * from {{ ref('master__it_services') }}
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
