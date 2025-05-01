with source as (
    select * from {{ ref('master__business_units') }}
),

renamed as (
    select
        fiscal_year,
        fiscal_month,
        business_unit_id,
        business_unit_name,
        description,
        employee_count,
        parent_id
    from source
)

select * from renamed
