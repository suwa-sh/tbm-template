with source as (
    select * from {{ ref('service_to_capability_allocations') }}
),

renamed as (
    select
        allocation_id,
        service_id,
        capability_id,
        allocation_method,
        allocation_value,
        description
    from source
)

select * from renamed
