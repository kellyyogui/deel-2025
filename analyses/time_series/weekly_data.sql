with

src as (
  select *
  from {{ ref('globepay_transactions') }}
)

, summary as (
  select
    year * 100 + month as year_month
    , case
        when day >= 1 and  day < 8 then 1
        when day >= 8 and  day < 16 then 2
        when day >= 16 and  day < 24 then 3
        when day >= 24 then 4
      end as week        
    , currency
    , country
    , count(external_ref) as transactions_qty
    , sum(amount_usd) as transactions_value
    , count(case when state = "ACCEPTED" then external_ref end) as accepted_qty
    , sum(case when state = "ACCEPTED" then amount_usd end) as accepeted_value
    , count(case when state = "DECLINED" then external_ref end) as declined_qty
    , sum(case when state = "DECLINED" then amount_usd end) as declined_value
  from src
  group by all
)

, percentages as (
  select
    * except(year_month, week)
    , concat(cast(year_month as string), "_", week) as week
    , accepted_qty/transactions_qty as rate_qty
    , accepeted_value/transactions_value as rate_value
  from summary
)

select *
from percentages
-- where year_month >= 201904
order by country, week