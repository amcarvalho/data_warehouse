select postcode, sum(total)
from {{ ref('f_sales_by_postcode') }}
where postcode = 'SW19'
group by postcode
having sum(total) != 254