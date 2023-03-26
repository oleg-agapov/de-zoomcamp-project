# Prefect

## Setup Prefect Cloud

1. Go to [prefect.io](https://www.prefect.io/) and register a free account.
1. Create a workspace, for example `de-zoomcamp-2023`
1. Go to [API Keys](https://app.prefect.cloud/my/api-keys) and create a new key. Copy the value of the key and workspace, and place that into `.env`:
    ```
    PREFECT_API_KEY=<your_prefect_key>
    PREFECT_WORKSPACE=<your_account_name>/<your_key_name>
    ```
1. From within your local dev environment run the following command to connect your Prefect Cloud with local setup:

    ```
    source .env
    prefect cloud login -k $PREFECT_API_KEY
    ```

## Setup Prefect Blocks

Create Prefect blocks manually:

```
python prefect/blocks/gcp.py
python prefect/blocks/github.py
python prefect/blocks/cloud_run.py
```

or with

```
make prefect-blocks
```

## Prefect Agent

Prefect Agent can be built as Docker image and run locally or in GCP (with VM or Cloud Run).

First, build the image:

```
make prefect-build
```

To start Prefect Agent locally:
```
make prefect-agent
```

To start Prefect Agent in the cloud using VM just run:

```
make prefect-vm
```

After that you need to check that work pool `default-agent-pool` has "Healthy" status.


## Useful links

- [Serverless Prefect Flows with Google Cloud Run Jobs](https://medium.com/the-prefect-blog/serverless-prefect-flows-with-google-cloud-run-jobs-23edbf371175)
- https://github.com/danilo-nzyte/real_world_python_tutorials
