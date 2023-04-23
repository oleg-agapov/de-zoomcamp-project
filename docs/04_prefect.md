# Prefect

## Setup Prefect Cloud

1. Go to [prefect.io](https://www.prefect.io/) and register a free account.
1. Create a workspace, for example `de-zoomcamp-2023`
1. Go to [API Keys](https://app.prefect.cloud/my/api-keys) and create a new key. Copy the values of the key and the workspace, and place them to `.env`:
    ```
    PREFECT_API_KEY=<your_prefect_key>
    PREFECT_WORKSPACE=<your_account_name>/<your_key_name>
    ```
1. From within your local dev environment run the following command to connect your Prefect Cloud with local setup:

    ```
    source .env
    prefect cloud login -k $PREFECT_API_KEY
    ```

    or with Make

    ```
    make prefect-login
    ```

## Setup Prefect Blocks

Create Prefect blocks:

```
python prefect/blocks/gcp.py
python prefect/blocks/github.py
```

or with

```
make prefect-blocks
```

## Prefect Agent

Prefect Agent is built as a Docker image and in GCP as VM.

First, build the image:

```
make prefect-build
```

To start Prefect Agent locally (for testing and debugging):
```
make prefect-agent
```

To start Prefect Agent in the cloud using VM just run:

```
make prefect-vm
```

After that you need to check that work pool `default-agent-pool` has "Healthy" status.

## Setting up a schedule

1. Go to "Deployments" and click on "Load raw data" deployment
1. Now click on three dots (upper right corner) and "Edit"
1. Enable "Scheduler" and add cron interval:
    ```
    5 * * * *
    ```

During the initial bootstrap process, you can set it to run every minute until the data catch-up the current date. Then you can set it as in the instruction above.


## Useful links

- [Serverless Prefect Flows with Google Cloud Run Jobs](https://medium.com/the-prefect-blog/serverless-prefect-flows-with-google-cloud-run-jobs-23edbf371175)
- https://github.com/danilo-nzyte/real_world_python_tutorials
