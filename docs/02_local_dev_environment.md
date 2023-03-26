# Local development environment

> This is only for Mac/Linux

## Python virtual environment

Run the following to bootstrap a virtual environment:

```
make env
``` 

Activate the environment afterwards:

```
source .venv/bin/activate
```

Alternatively, create a new virtual environment manually:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

## Required additional CLIs

Make sure that you have the following apps installed and working.

### gcloud

1. Install [gcloud CLI](https://cloud.google.com/sdk/docs/install-sdk) 
1. Initialize it:
    
    ```bash
    gcloud init
    ```

### Terraform

Install [terraform CLI](https://developer.hashicorp.com/terraform/downloads)

### Docker

Install [docker CLI](https://docs.docker.com/get-docker/)
