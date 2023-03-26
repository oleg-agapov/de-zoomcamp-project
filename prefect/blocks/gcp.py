import os
import json
from dotenv import load_dotenv
from prefect_gcp import GcpCredentials
from prefect_gcp.cloud_storage import GcsBucket


def read_json(path: str) -> dict:
    with open(path, 'r') as f:
        return json.load(f)

load_dotenv()

service_account_path = os.getenv('GOOGLE_APPLICATION_CREDENTIALS')
bucket_name = os.getenv('GCS_BUCKET_NAME')

service_account_info = read_json(service_account_path)

gcp_block = GcpCredentials(service_account_info=service_account_info)
gcp_block.save('de-zoomcamp-project', overwrite=True)

gcs_block = GcsBucket(gcp_credentials=gcp_block, bucket=bucket_name)
gcs_block.save('de-zoomcamp-project', overwrite=True)
