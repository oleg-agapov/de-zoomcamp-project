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
		--build-arg prefect_api_key="${PREFECT_API_KEY}" \
		--build-arg prefect_api_url="${PREFECT_API_URL}" \
		-t de-zoomcamp/prefect:latest \
		./prefect

prefect-agent:
	@docker run --entrypoint prefect \
		de-zoomcamp/prefect:latest \
		agent start \
		--pool default-agent-pool \
		--work-queue default
