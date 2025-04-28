
  create view "tbm_db"."public"."stg_it_towers__dbt_tmp"
    
    
  as (
    with source as (
    select * from "tbm_db"."public_raw"."it_towers"
),

renamed as (
    select
        it_tower_id,
        it_tower_name,
        description
    from source
)

select * from renamed
  );