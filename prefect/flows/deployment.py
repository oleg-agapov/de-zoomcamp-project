from extract_and_load import main_flow
from prefect.deployments import Deployment
from prefect.filesystems import GitHub


github_block = GitHub.load('de-zoomcamp-project')

deployment = Deployment.build_from_flow(
    flow=main_flow,
    name='Load raw data',
    storage=github_block,
)
deployment.apply()
