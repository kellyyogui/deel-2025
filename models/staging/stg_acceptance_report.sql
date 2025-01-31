{{ config(materialized='table') }}

with

-- 1. Reference upstream model and rename columns
src as (
    select
        * EXCEPT(amount)
        , amount as amount_local
    from {{ ref('src_globalpay__acceptance_report') }}
)

-- 2. Compute amount values in USD

-- 2.1. Get exchange rate for corresponding currency
, exg_rates as (
    select
        *

        -- The JSON parsing results in 20 null values, which should be further investigated
        -- , SAFE.PARSE_JSON(rates)[currency] AS exchange_rate_json
        -- , SAFE.PARSE_JSON(rates) AS parsed_json
        
        -- REGEX_EXTRACT works for all cases, therefore is the used approach
        , SAFE_CAST(
            REGEXP_EXTRACT(rates, CONCAT(r'"', currency, r'"\s*:\s*([\d.]+)')) 
            AS FLOAT64) as exchange_rate
    from src
)

-- 2.2. Calculate the final amount value in USD
, usd_values as (
    select
        *
        , SAFE_DIVIDE(
            amount_local,
            -- Treat 0 and NULL values to not break the lineage
            -- But test exchange_rate to ensure it is working properly 
            IFNULL(NULLIF(exchange_rate, 0), 1)
         ) as amount_usd
    from exg_rates
)

-- 3. Create date fields to facilitate analysis for final users
, date_fields as (
    select
        *
        , EXTRACT(YEAR FROM date_time) AS year
        , EXTRACT(MONTH FROM date_time) AS month
        , EXTRACT(DAY FROM date_time) AS day
    from usd_values
)

-- 4. Cleanup
, clean_dt as (
    select
        external_ref
        -- , status > always true, so it does not add up any information
        -- , source > may be irrelevant to the final users
        , ref
        , date_time
        , state
        , cvv_provided
        , country
        , currency
        -- , rates > remove to avoid misunderstanding
        , amount_local
        , exchange_rate
        , amount_usd
        , year
        , month
        , day
    from date_fields
)

select *
from clean_dt