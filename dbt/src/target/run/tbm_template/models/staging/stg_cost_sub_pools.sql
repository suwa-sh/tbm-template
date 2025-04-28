
  create view "tbm_db"."public"."stg_cost_sub_pools__dbt_tmp"
    
    
  as (
    with source as (
    select * from "tbm_db"."public_raw"."cost_sub_pools"
),

renamed as (
    select
        cost_sub_pool_id,
        cost_pool_id,
        cost_sub_pool_name,
        description
    from source
)

select * from renamed
  );