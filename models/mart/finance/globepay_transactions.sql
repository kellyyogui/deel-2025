{{ config(materialized='table') }}

with

-- 1. Reference upstream models
acceptance as (
    select *
    from {{ ref('stg_globepay__acceptance_report') }}
)

, chargeback as (
    select *
    from {{ ref('stg_globepay__chargeback_report') }}
)

-- 2. Join data
, transactions as (
    select
        acc.*
        , cha.chargeback
    from acceptance as acc
        left join chargeback as cha
            on acc.external_ref = cha.external_ref
)

select *
from transactions