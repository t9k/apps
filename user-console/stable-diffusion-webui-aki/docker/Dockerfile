FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-runtime

WORKDIR /workspace
COPY . ./sd-webui-aki
WORKDIR /workspace/sd-webui-aki
RUN mv .cache /root

ENV DEBIAN_FRONTEND=noninteractive

ENV NB_PREFIX=/

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -yq --no-install-recommends \
  build-essential \
  ffmpeg \
  libsm6 \
  libxext6 \
  git \
  && apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip && \
  pip install --no-cache-dir --default-timeout=100 -r requirements_versions.txt
RUN python launch.py --exit --skip-torch-cuda-test

COPY launch.sh ./launch.sh
ENTRYPOINT [ "./launch.sh" ]
