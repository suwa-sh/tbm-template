with capability_costs as (
    select * from {{ ref('service_to_capability') }}
),

-- ビジネスケイパビリティ別の集計
final as (
    select
        MAKE_TIMESTAMP(fiscal_year, fiscal_month, 1, 0, 0, 0) as time,
        fiscal_year,
        fiscal_month,
        capability_id,
        capability_name,
        capability_type,
        sum(allocated_amount) as total_allocated_amount,
        count(distinct service_id) as service_count
    from capability_costs
    group by 1, 2, 3, 4, 5, 6
)

select * from final
