with source as (
    select * from {{ ref('entries_plan') }}
),

renamed as (
    select
        fiscal_year,
        fiscal_month,
        business_unit_id,
        business_unit_name,
        description,
        amount
    from source
)

select * from renamed
