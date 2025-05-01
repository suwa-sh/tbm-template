with source as (
    select * from {{ ref('entries_cost') }}
),

renamed as (
    select
        fiscal_year,
        fiscal_month,
        cost_pool_id,
        cost_sub_pool_id,
        vendor,
        description,
        amount
    from source
)

select * from renamed
