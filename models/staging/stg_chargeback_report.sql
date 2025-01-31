{{ config(materialized='table') }}

with

-- 1. Reference upstream model
src as (
    select
        *
    from {{ ref('src_chargeback_report') }}
)

-- 2. Cleanup
, clean_dt as (
    select
        external_ref
        -- , status > always true, so it does not add up any information
        -- , source > may be irrelevant to the final users
        , chargeback
    from src
)

select *
from clean_dt

