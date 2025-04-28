
  create view "tbm_db"."public"."stg_it_sub_towers__dbt_tmp"
    
    
  as (
    with source as (
    select * from "tbm_db"."public_raw"."it_sub_towers"
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
  );