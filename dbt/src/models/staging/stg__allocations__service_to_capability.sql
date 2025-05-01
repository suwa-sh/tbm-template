with source as (
    select * from {{ ref('allocations__service_to_capability') }}
),

renamed as (
    select
        fiscal_year,
        fiscal_month,
        service_id,
        capability_id,
        allocation_method,
        allocation_value,
        description
    from source
)

select * from renamed
