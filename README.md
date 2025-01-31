# Repository Structure

## analyses
Folder containing the developed queries to analyze the data.


## models
Folder with the lineage

### models/sources/globalpay
- _globalpay.yml_: YAML file where sources are configurated
- _src_globalpay.yml_: YAML file declaring the initial models of our lineage
- _src_globalpay__acceptance_report_ and _src_globalpay__chargeback_report_: models with the raw data.
  Some companies do not allow Data Analysts to access Cloud Storage, so these models are materialized as tables to make it viable for Analysts to explore the raw data without needing a Data Engineer.

### models/staging/globepay
