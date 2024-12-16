FROM python:3.10-slim

RUN pip install --no-cache-dir mlserver mlserver-mlflow

WORKDIR /workspace

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
