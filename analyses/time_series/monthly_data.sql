with

src as (
  select *
  from {{ ref('globepay_transactions') }}
)

, summary as (
  select
    year * 100 + month as year_month
    -- , currency
    -- , country
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
    *
    , accepted_qty/transactions_qty as rate_qty
    , accepeted_value/transactions_value as rate_value
  from summary
)

select *
from percentages