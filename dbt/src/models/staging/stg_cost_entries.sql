with source as (
    select * from {{ ref('cost_entries') }}
),

renamed as (
    select
        cost_entry_id,
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
