include .env
export

dev:
	rm -rf .venv
	python3 -m venv .venv
	. .venv/bin/activate && \
	pip install --upgrade pip && \
	pip install -r requirements.txt


prefect-build:
	@docker image build \
		-t de-zoomcamp/prefect:latest \
		./prefect

prefect-agent:
	@docker run \
		-e PREFECT_API_KEY="${PREFECT_API_KEY}" \
		-e PREFECT_API_URL="${PREFECT_API_URL}" \
		--entrypoint prefect \
		de-zoomcamp/prefect:latest \
		agent start \
		--pool default-agent-pool \
		--work-queue default

prefect-blocks:
	python prefect/blocks/gcp.py
	python prefect/blocks/github.py
	@#python prefect/blocks/cloud_run.py
