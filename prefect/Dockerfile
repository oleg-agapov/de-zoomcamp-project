FROM prefecthq/prefect:2.8.7-python3.9

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt --no-cache-dir

COPY flows /opt/prefect/flows
