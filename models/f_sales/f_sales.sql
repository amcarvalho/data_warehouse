{{
    config(
        materialized='incremental',
        unique_key='datetime',
        partition_by='DATE(datetime)',
        schema='datamart',
        pre_hook='delete from {{ this }} where date(datetime) = \'{{ var("run_date", "1990-01-01") }}\''
    )
}}

with ranked_user_dim_by_sales_records as (
    select  s.datetime as datetime,
            u.id as user_id,
            u.name as user_name,
            u.postcode as user_postcode,
            s.product_id as product_id,
            s.qty as qty,
            s.price as price,
            dense_rank() over(partition by s.user_id, s.datetime order by load_date desc) as rn
    from    {{ ref('sales') }} s
    join    {{ ref('dim_user') }} u on (u.id=s.user_id and timestamp(u.load_date) <= s.datetime)
{% if is_incremental() %}
    -- this filter will only be applied on an incremental run
    where   date(datetime) = '{{ var("run_date", "1990-01-01") }}'
{% endif %}
)
select  datetime,
        user_id,
        user_name,
        user_postcode,
        product_id,
        qty,
        price
from    ranked_user_dim_by_sales_records
where   rn = 1