with source as (
    select * from {{ ref('business_units') }}
),

renamed as (
    select
        business_unit_id,
        business_unit_name,
        description,
        employee_count,
        parent_id
    from source
)

select * from renamed
