{{ config(materialized='table') }}

select *
from {{ source('bq_sources', 'chargeback_report') }}