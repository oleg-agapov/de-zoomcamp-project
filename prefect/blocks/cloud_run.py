import os
from dotenv import load_dotenv
from prefect_gcp import GcpCredentials
from prefect_gcp.cloud_run import CloudRunJob


load_dotenv()

docker_repo = os.getenv('GCP_DOCKER_REPO_PATH')
docker_image = os.getenv('GCP_DOCKER_IMAGE')
region = os.getenv('GCP_REGION')

cloud_run_block = CloudRunJob(
    image=f'{docker_repo}/{docker_image}',
    region=region,
    credentials=GcpCredentials.load('de-zoomcamp-project'),
)
cloud_run_block.save('de-zoomcamp-project', overwrite=True)
