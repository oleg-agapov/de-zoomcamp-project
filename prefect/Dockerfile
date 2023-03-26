FROM prefecthq/prefect:2.8.7-python3.9

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt --no-cache-dir

ARG prefect_api_key
ARG prefect_api_url

ENV PREFECT_API_KEY=$prefect_api_key
ENV PREFECT_API_URL=$prefect_api_url

COPY flows /opt/prefect/flows
