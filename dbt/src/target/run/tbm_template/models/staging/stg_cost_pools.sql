
  create view "tbm_db"."public"."stg_cost_pools__dbt_tmp"
    
    
  as (
    with source as (
    select * from "tbm_db"."public_raw"."cost_pools"
),

renamed as (
    select
        cost_pool_id,
        cost_pool_name,
        description
    from source
)

select * from renamed
  );