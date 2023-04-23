# Instructions on how to reproduce the project

This instruction will guide you step-by-step throught the reproduction of the project.

The instructions are tested on MacOS. However with minimal changes it should be possible to do the same from Linux.

# Step 0. Preparation

Clone the repository to your machine:

```
git clone git@github.com:oleg-agapov/de-zoomcamp-project.git
```

If you want to make changes and save them for yourself, it is recommended to first [make a fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) of the repo and then clone the fork.

Now you can proceed for the rest of the instruction.

# Step 1. Google Cloud

![](./logos/gcp-logo.svg.png)

[Step-by-step instruction](./01_google_cloud_setup.md).

Here you need to make an initial setup of **GCP**:

- create an account
- generate credentials (service account)
- create `.env` file with settings
- enable needed services

# Step 2. Create a local dev environment

[Step-by-step instruction](./02_local_dev_environment.md).

To develop, test, and deploy the pipeline you will need additional software, such as
- **Python** for creating avirtual environment with all the dependencies
- `gcloud` CLI to operate with GCP
- `terraform` to bootstrap the cloud setup
- `docker` CLI to run containers

# Step 3. Bootstrapping cloud services with Terraform

![](./logos/terraform-logo.svg.png)

[Step-by-step instruction](./03_terraform.md).

**Terraform** is needed to bootstrap some essential services, such as cloud storage and data warehouse schemas.

To make it work, don't forget to change configuration in `variables.tf` file.

# Step 4. Setting up Prefect

![](./logos/prefect-logo.png)

[Step-by-step instruction](./04_prefect.md).

**Prefect** setup consists of two parts:
1. Setting up a Prefect Cloud
2. Starting a Prefect Agent

While setting up Prefect Cloud is a straightforward process, for Prefect Agent you will need to do some steps like:
- building a Docker comntainer with all the dependencies
- pushing this container to Container registry
- creating a VM out of the container

Everything is automated through `make` scripts.

Lastly, don't forget to enable the schedule for the pipeline flow. Initially you will want to setup the pipeline to run every minute, so the it bootstrap the data from the beginning till the current day. Beware that it is a long process because of the amount of the data (for me it was about 1.5 days for 3 month of data).

You can check the volume of the data in GCS with:

```
gsutil du -sh gs://full_path_to_data_lake
```

In my case it was:
```
192.9 GiB    gs://de-zoomcamp-2023-project-datalake
```

When the pipeline catch up the current date and time, you can change the schedule to update every hour.

# Step 5. Setting up BigQuery and dbt

![](./logos/dbt-logo.png)

[Step-by-step instruction](./05_bigquery_and_dbt.md).

Most of **BigQuery** setup is already done on the 3rd step. So you will mainly focus on the **dbt** part.

You will need to:

1. Create a dbt Cloud account
2. Connect your repository
3. Create a hourly job and start it

Initial bootstrapping of all the tables will take a couple of minutes as the amount of data is quite big.

# The dashboard

Unfortunately, it is impossible to make a template for the dashboard for the fast recreation. You can try th following:
1. Open [this dashboard](https://lookerstudio.google.com/u/0/reporting/7f008b05-874b-4ca2-8115-bdfb30b16a00/page/rE5LD), I made it public
1. Make a copy to yourself
1. Replace the data sources with your tables
