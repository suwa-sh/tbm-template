
  create view "tbm_db"."public"."stg_cost_to_tower_allocations__dbt_tmp"
    
    
  as (
    with source as (
    select * from "tbm_db"."public_raw"."cost_to_tower_allocations"
),

renamed as (
    select
        allocation_id,
        cost_pool_id,
        cost_sub_pool_id,
        it_tower_id,
        it_sub_tower_id,
        allocation_method,
        allocation_value,
        description
    from source
)

select * from renamed
  );