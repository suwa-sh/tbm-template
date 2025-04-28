
  create view "tbm_db"."public"."stg_business_capabilities__dbt_tmp"
    
    
  as (
    with source as (
    select * from "tbm_db"."public_raw"."business_capabilities"
),

renamed as (
    select
        capability_id,
        capability_name,
        description,
        capability_type
    from source
)

select * from renamed
  );