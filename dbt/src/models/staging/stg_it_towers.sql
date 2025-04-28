with source as (
    select * from {{ ref('it_towers') }}
),

renamed as (
    select
        it_tower_id,
        it_tower_name,
        description
    from source
)

select * from renamed
