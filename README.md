# Repository Structure

## analyses
Folder containing the developed queries to analyze the data.


## models
Folder with the lineage

### models/sources/globalpay

The naming _globapay_ refers to the _source_ field that originated from the raw data. Therefore, all names in this folder mention this source.

- _globalpay.yml_: YAML file where sources are configurated
- _src_globalpay.yml_: YAML file declaring the initial models of our lineage
- _src_globalpay__acceptance_report_ and _src_globalpay__chargeback_report_: models with the raw data


  Some companies do not allow Data Analysts to access Cloud Storage, so the models are materialized as tables to make it viable for Analysts to explore the raw data without needing a Data Engineer. 


  Further, creating these initial tables may facilitate maintenance (for example, when necessary to merge additional data with similar structures such as historical data, or change references).

### models/staging/globepay

At the staging level, the Subdirectories are based on the source system which is Globepay in this case. In this layer only simpler transformations are made (fields filtering and currency calculations) to keep the one-to-one relation with source tables.

- _globepay.yml_: YAML file declaring the staging models and their corresponding tests
- _stg_globepay__acceptance_report_: staging with selected fields and computation of amounts in USD
- _src_globalpay__chargeback_report_: staging with selected fields

  The staging models are not intended to be shared with final users. Therefore, to avoid wasting space in the warehouse and keep freshness, they are materialized as views.
