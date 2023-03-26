import os
from dotenv import load_dotenv
from prefect.filesystems import GitHub

load_dotenv()

repo = os.getenv('GITHUB_REPOSITORY')

github_block = GitHub(
    name="de-zoomcamp-project",
    repository=repo
)
github_block.save('de-zoomcamp-project', overwrite=True)
