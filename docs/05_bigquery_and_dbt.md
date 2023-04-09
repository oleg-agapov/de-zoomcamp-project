# BigQuery and dbt

Next step is to upload the data from Cloud Storage to BigQuery and transform the data with dbt.

## Steps to reproduce

1. Create an external table in BigQuery using data from Cloud Storage. For that you need to install dbt package `dbt_external_tables` and execute its macro:
    
    ```bash
    cd dbt

    # install packages
    dbt deps 

    # create external tables from staging/_staging_sources.yml
    dbt run-operation stage_external_sources

    # if you want to perform a full refresh of external sources
    dbt run-operation stage_external_sources --vars "ext_full_refresh: true"
    ```

2. Generate seeds. In our case it is a mapping of event names to their categories:

    ```bash
    dbt seed
    ```

3. Now build the models with:

    ```bash
    dbt build
    ```

## Working in dbt Cloud

1. Setup dbt Cloud account at https://cloud.getdbt.com/
2. Connect the repository with the code and put `/dbt` as the entrypoint for the project
3. During the first time of opening development IDE confirm that you want to run `dbt deps`
4. The rest of the instruction if the same as in "Steps to reproduce" section


Useful links:
- [Bigquery adapter configs (official doc)](https://docs.getdbt.com/reference/resource-configs/bigquery-configs)
- Bigquery incremental updates: [link 1](https://discourse.getdbt.com/t/bigquery-dbt-incremental-changes/982), [link 2](https://discourse.getdbt.com/t/benchmarking-incremental-strategies-on-bigquery/981)
