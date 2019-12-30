# dbt models for _data_warehouse_
This is an example dbt project to which I can refer to whenever setting new projects or playing
around with new stuff. 

TODO Describe model and pipeline.

## Configurations
I've made this to run on Google Cloud/Big Query. As such, the following configurations are required:
* Create a Google Cloud project. Instructions [here](https://cloud.google.com/resource-manager/docs/creating-managing-projects);
* Create a Google Cloud service account. Instructions [here](https://cloud.google.com/iam/docs/creating-managing-service-accounts);
* Create 2 environment variables:
    * `GCP_PROJECT`: Set it to your Google Cloud project ID.
    * `GCP_KEY_FILE`: Set it to the path where your service account json key file is.

## Issues

TODO Describe issues: 1) non-atomic transactions and 2) delete statement to guarantee idempotence fails on 1st run.

## Running
Seed source data by executing:
`dbt seed --full-refresh --profile-dir .`

Run Sales pipeline by executing:
`dbt run -m f_sales+ --vars '{"run_date":2019-10-06}' --profiles-dir .`
This incrementally processes sales for a specific day. If this is the first time you are
running the pipeline, all dates will be processed.