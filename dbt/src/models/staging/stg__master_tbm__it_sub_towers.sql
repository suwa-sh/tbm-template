with source as (
    select * from {{ ref('master_tbm__it_sub_towers') }}
),

renamed as (
    select
        it_sub_tower_id,
        it_tower_id,
        it_sub_tower_name,
        description
    from source
)

select * from renamed
