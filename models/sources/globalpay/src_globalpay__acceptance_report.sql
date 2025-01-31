{{ config(materialized='table') }}

select *
from {{ source('bq_sources', 'acceptance_report') }}