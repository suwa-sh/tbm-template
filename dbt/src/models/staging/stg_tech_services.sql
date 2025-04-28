with source as (
    select * from {{ ref('tech_services') }}
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
