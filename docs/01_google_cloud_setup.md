# Setup of Google Cloud Patform

## Initial setup

1. Create new project in Google Cloud and put its "Project ID" into `.env`:
1. Go to [Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts) management and create a new service account:
    - name: Terraform Service Account
    - roles: Basic -> Editor
1. Now generate a service key:
    - click on the "Terraform Service Account" -> Keys 
    - click "ADD KEY" -> Create new key -> JSON format
    - a file with credentials will be downloaded automatically
1. Copy downloaded key to `.google` folder
1. Create `.env` file with environment variables:

    ```
    GCP_PROJECT_ID=de-zoomcamp-2023-project-v2
    GCP_REGION=europe-west6
    GOOGLE_APPLICATION_CREDENTIALS=.google/terraform-service-account.json
    GITHUB_REPOSITORY=<URL-of-your-repository>
    GCS_BUCKET_NAME=de-zoomcamp-2023-project-v2-datalake
    ```

## Additional services

- Enable [Compute Engine](https://console.cloud.google.com/marketplace/product/google/compute.googleapis.com) API
