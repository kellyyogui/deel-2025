with

src as (
  select *
  from {{ ref('globepay_transactions') }}
)

, missing_cb as (
    select
        *
    from src
    where chargeback is null
)

, summary as (
    select
        chargeback
        , state
        , count(external_ref) as transactions_qty
        , sum(amount_usd) as transactions_value
    from src
    group by all
)

select *
from summary