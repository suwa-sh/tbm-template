with source as (
    select * from {{ ref('allocations__tower_to_service') }}
),

renamed as (
    select
        fiscal_year,
        fiscal_month,
        it_tower_id,
        it_sub_tower_id,
        service_id,
        allocation_method,
        allocation_value,
        description
    from source
)

select * from renamed
