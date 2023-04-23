# BigQuery and dbt

This step will help you to upload the data from Cloud Storage to BigQuery and transform it with dbt.

## Working in dbt Cloud

1. Setup a dbt Cloud account at https://cloud.getdbt.com/
1. Connect the repository with the code and put `/dbt` as the entrypoint for the project
1. Enter credentials for the BigQuery (you need to upload the service account file)
1. During the first time of opening the development IDE, confirm that you want to run `dbt deps`
1. Now proceed to the next section of this instruction

## Creating data models

1. Navigate to dbt folder and run all commands from there:
    ```
    cd dbt
    ```
1. Create an external table in BigQuery using the data from Cloud Storage. 
    - For that you need to install dbt package `dbt_external_tables` and execute its macro:
        ```bash
        dbt deps 
        ```
    - Now create external tables from staging/_staging_sources.yml
        
        ```
        dbt run-operation stage_external_sources
        ```

    - If you want to perform a full refresh of external sources
        ```
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

## Create a job in dbt Cloud

1. Navigate to Deploy -> Jobs
1. Click "Create Job"
1. Name it "Hourly job"
1. Most of the configuration you can leave with defaults, however you can tweak them if you want to
1. In the "Triggers" section enable "Run on schedule", put a cron schedule in the format:
    ```
    15 * * * *
    ```
1. You can try to trigger your job manually to check that it works


Useful links:
- [Bigquery adapter configs (official doc)](https://docs.getdbt.com/reference/resource-configs/bigquery-configs)
- Bigquery incremental updates: [link 1](https://discourse.getdbt.com/t/bigquery-dbt-incremental-changes/982), [link 2](https://discourse.getdbt.com/t/benchmarking-incremental-strategies-on-bigquery/981)
