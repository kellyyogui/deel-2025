# Repository Structure

## analyses
Folder containing the developed queries to analyze the data.

### analyses/overview.sql
Query used to compute the big numbers per country. It allows for calculating the Total Acceptance Rate and the volume of declined payments in USD per country.

### analyses/time_series
This folder has three queries developed to explore time series data and display the acceptance rate over time (_rate_qty_) for different periodicities (monthly, weekly, and daily).

### analyses/overview.sql
This SQL query checks if there are missing values for the _chargeback_ field. Moreover, it computes the chargeback relevance.

## models
Folder with the lineage based mainly on dbt best practices - [How we structure our dbt projects updated on Jan 28, 2025](https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview). It has three layers: Sources, Staging, and Mart as described below.

### models/sources/globalpay

The naming _globalpay_ refers to the _source_ field that originated from the raw data. Therefore, all names in this folder mention this source.

- _globalpay.yml_: YAML file where sources are configurated
- _src_globalpay.yml_: YAML file declaring the initial models of our lineage
- _src_globalpay__acceptance_report_ and _src_globalpay__chargeback_report_: models with the raw data


  Some companies do not allow Data Analysts to access Cloud Storage, so the models are materialized as tables to make it viable for Analysts to explore the raw data without needing a Data Engineer. 


  Further, creating these initial tables may facilitate maintenance (for example, when necessary to merge additional data with similar structures such as historical data, or change references).

### models/staging/globepay

At the staging level, the Subdirectories are based on the source system which is Globepay in this case. In this layer, only simpler transformations are made (field filtering and currency calculations) to keep the one-to-one relation with source tables.

- _globepay.yml_: YAML file declaring the staging models and their corresponding tests
- _stg_globepay__acceptance_report_: staging with selected fields and computation of amounts in USD
- _src_globalpay__chargeback_report_: staging with selected fields

  The staging models are not intended to be shared with final users. Therefore, to avoid wasting space in the warehouse and to keep freshness, they are materialized as views.

### models/mart/finance

As it refers to transactions, the final model is allocated in the Finance Mart. 

- _finance.yml_: YAML file declaring and testing the final model
- _globepay_transactions_: this table joins the two available datasets using the external_ref as the match key

  Given that _globepay_transactions_ evolves data joining, it is crucial to test uniqueness to guarantee no duplicities.
  
  For this case, this is the final model. However, in a real scenario, probably more transaction data could be brought together to enhance it.
