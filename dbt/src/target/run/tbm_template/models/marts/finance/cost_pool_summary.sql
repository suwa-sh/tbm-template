
  
    

  create  table "tbm_db"."public_finance"."cost_pool_summary__dbt_tmp"
  
  
    as
  
  (
    with cost_entries as (
    select * from "tbm_db"."public"."stg_cost_entries"
),

cost_pools as (
    select * from "tbm_db"."public"."stg_cost_pools"
),

cost_sub_pools as (
    select * from "tbm_db"."public"."stg_cost_sub_pools"
),

-- コストプール別の集計
cost_pool_summary as (
    select
        ce.fiscal_year,
        ce.fiscal_month,
        ce.cost_pool_id,
        cp.cost_pool_name,
        ce.cost_sub_pool_id,
        csp.cost_sub_pool_name,
        sum(ce.amount) as total_amount,
        count(distinct ce.cost_entry_id) as entry_count
    from cost_entries ce
    left join cost_pools cp on ce.cost_pool_id = cp.cost_pool_id
    left join cost_sub_pools csp on ce.cost_sub_pool_id = csp.cost_sub_pool_id
    group by 1, 2, 3, 4, 5, 6
)

select * from cost_pool_summary
  );
  