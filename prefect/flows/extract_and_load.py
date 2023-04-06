import argparse
import requests
import datetime
from io import BytesIO

from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket


@task(timeout_seconds=60, retries=3)
def extract_from_web(url: str) -> bytes:
    """
    Task that downloads the file to bytes format from a given URL
    """
    r = requests.get(url)
    return r.content


@task(timeout_seconds=60, retries=3)
def save_to_cloud_storage(content: bytes, storage_path: str) -> None:
    """
    Task saves given bytes content to the Cloud Storage
    """
    gcs = GcsBucket.load('de-zoomcamp-project')
    gcs.upload_from_file_object(BytesIO(content), storage_path)


@task()
def get_next_datetime() -> tuple:
    gcs = GcsBucket.load('de-zoomcamp-project')
    
    folders = gcs.list_folders()
    folders = sorted([x for x in folders if x.startswith('github/raw_data')])

    if len(folders) == 0:
        next_datetime = datetime.datetime(2023, 1, 1)
        return (
            next_datetime.year,
            next_datetime.month,
            next_datetime.day,
            next_datetime.hour,
        )
    
    all_blobs = gcs.list_blobs(folders[-1])
    blobs = [int(x.name.split('/')[-1].split('.')[0].split('-')[-1]) for x in all_blobs]

    last_available_hour = max(blobs)
    last_available_date = folders[-1].split('=')[-1]
    year, month, day = [int(x) for x in last_available_date.split('-')]

    last_datetime = datetime.datetime(year, month, day, last_available_hour)
    next_datetime = last_datetime + datetime.timedelta(hours=1)
    
    return (
        next_datetime.year,
        next_datetime.month,
        next_datetime.day,
        next_datetime.hour,
    )


@flow(name='Get raw data from Github archive', log_prints=True)
def extract_and_save(year: int, month: int, day: int, hour: int) -> None:
    # parameters
    full_date = f'{year}-{month:02}-{day:02}'
    file_name = f'{full_date}-{hour}.json.gz'
    base_url = 'https://data.gharchive.org/'
    url = base_url + file_name
    target_folder = f"github/raw_data/year={year}/month={month:02}/date={full_date}"
    target_full_path = f"{target_folder}/{file_name}"
    # the pipeline
    print(f'Downloading {file_name} ...')
    content = extract_from_web(url)
    save_to_cloud_storage(content, target_full_path)


@flow(name='Load raw data to GCS')
def main_flow(target_date = None, target_hour = None) -> None:
    if target_date and target_hour:
        year, month, day = [int(x) for x in target_date.split('-')]
        hour = target_hour
    else:
        year, month, day, hour = get_next_datetime()
    # subflow
    extract_and_save(year, month, day, hour)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest Github Archive data')
    parser.add_argument('--target_date', required=False, help='Target date for processing')
    parser.add_argument('--target_hour', required=False, help='Target hour')
    args = parser.parse_args()

    main_flow(args.target_date, args.target_hour)
