{{
    config(
        materialized='incremental',
        unique_key='date',
        partition_by='date',
        schema='datamart',
        pre_hook='delete from {{ this }} where date = \'{{ var("run_date", "1990-01-01") }}\''
    )
}}

select      CAST(s.datetime AS DATE) as date,
            s.user_postcode as postcode,
            sum(s.price*qty) as total
from        {{ ref('f_sales') }} s
{% if is_incremental() %}
    -- this filter will only be applied on an incremental run
where       date(s.datetime) = '{{ var("run_date", "1990-01-01") }}'
{% endif %}
group by    1, 2
