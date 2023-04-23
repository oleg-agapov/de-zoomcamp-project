include .env
export

dev:
	rm -rf .venv
	python3 -m venv .venv
	. .venv/bin/activate && \
	pip install --upgrade pip && \
	pip install -r requirements.txt


prefect-login:
	prefect cloud login -k ${PREFECT_API_KEY}


prefect-build:
	docker build \
		--platform linux/amd64 \
		--build-arg prefect_api_key="${PREFECT_API_KEY}" \
		--build-arg prefect_api_url="${PREFECT_API_URL}" \
		-t gcr.io/${GCP_PROJECT_ID}/prefect-agent:latest ./prefect
	docker push gcr.io/${GCP_PROJECT_ID}/prefect-agent

prefect-agent:
	@docker run \
		--entrypoint prefect \
		gcr.io/${GCP_PROJECT_ID}/prefect-agent \
		agent start \
		--pool default-agent-pool \
		--work-queue default

prefect-blocks:
	python prefect/blocks/gcp.py
	python prefect/blocks/github.py

prefect-vm:
	gcloud compute instances create-with-container vm-prefect-agent \
		--project=${GCP_PROJECT_ID} \
		--zone=europe-west6-a \
		--machine-type=e2-medium \
		--network-interface=network-tier=PREMIUM,subnet=default \
		--maintenance-policy=MIGRATE \
		--provisioning-model=STANDARD \
		--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
		--tags=https-server \
		--boot-disk-size=10GB \
		--boot-disk-type=pd-balanced \
		--boot-disk-device-name=prefect-agent \
		--container-image=gcr.io/${GCP_PROJECT_ID}/prefect-agent \
		--container-command=prefect \
		--container-arg=agent \
		--container-arg=start \
		--container-arg=--pool \
		--container-arg=default-agent-pool \
		--container-arg=--work-queue \
		--container-arg=default \
		--container-restart-policy=always \
		--no-shielded-secure-boot \
		--shielded-vtpm \
		--shielded-integrity-monitoring
