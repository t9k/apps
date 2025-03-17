FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-devel

RUN apt-get update && \
  apt-get install -yq --no-install-recommends openssh-server pdsh git libaio-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/hiyouga/LLaMA-Factory.git && \
  cd LLaMA-Factory && \
  pip install --no-cache-dir --upgrade pip && \
  pip install -r requirements.txt && \
  pip install ".[metrics,deepspeed,liger-kernel,bitsandbytes,hqq,gptq,awq,aqlm,vllm,galore,apollo,badam,adam-mini,qwen,minicpm_v,modelscope,swanlab]" && \
  cd .. && \
  rm -rf LLaMA-Factory && \
  git clone https://github.com/NetEase-FuXi/EETQ.git && \
  cd EETQ && \
  git reset --hard a6c5110 && \
  git submodule update --init --recursive && \
  pip install . && \
  cd .. && \
  rm -rf EETQ

RUN mkdir /run/sshd
RUN chown root:root /usr/lib

ARG GID=1000
ARG UID=1000
RUN groupadd --gid=$GID t9kuser && mkdir /t9k && \
    useradd -rm --create-home -d /t9k/mnt --shell /bin/bash --uid=$UID --gid=$GID t9kuser && \
    chown $UID:$GID /t9k/mnt
USER t9kuser

WORKDIR /t9k/backup
RUN git clone --depth 1 https://github.com/hiyouga/LLaMA-Factory.git && \
  mv LLaMA-Factory/data . && \
  rm -rf LLaMA-Factory
COPY launch.sh ./launch.sh

WORKDIR /t9k/mnt
ENTRYPOINT [ "/t9k/backup/launch.sh" ]
