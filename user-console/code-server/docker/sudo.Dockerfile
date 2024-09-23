FROM codercom/code-server:4.92.2 as codeserver

ARG BUILD_SDK_RELEASE=1.78.7

FROM tsz.io/t9k/build-sdk:1.78.7 as buildsdk

FROM pytorch/pytorch:2.4.1-cuda12.1-cudnn9-devel

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-transport-https \
    dumb-init \
    emacs \
    git \
    git-lfs \
    graphviz \
    htop \
    locales \
    lsb-release \
    man-db \
    nano \
    openssh-client \
    openssh-server \
    rclone \
    rsync \
    s3cmd \
    sudo \
    tmux \
    unzip \
    vim \
    wget \
    zip \
    zsh \
  && git lfs install \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# https://wiki.debian.org/Locale#Manually
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
  && locale-gen
ENV LANG=en_US.UTF-8

RUN pip install --no-cache-dir --upgrade pip && \
  pip install --no-cache-dir --default-timeout=100 \
  accelerate==0.34.2 \
  datasets==2.21.0 \
  h5py==3.11.0 \
  huggingface-hub==0.25.0 \
  jupyter==1.0.0 \
  lightning==2.4.0 \
  pytorch-lightning==2.4.0 \
  matplotlib==3.9.2 \
  modelscope==1.18.0 \
  modelscope[datasets]==1.18.0 \
  pandas==2.2.2 \
  sentencepiece==0.2.0 \
  torch-model-archiver==0.11.1 \
  torch-tb-profiler==0.4.3 \
  torch-workflow-archiver==0.2.14 \
  torchmetrics==1.4.2 \
  torchtext==0.18.0 \
  transformers==4.44.2
  
RUN groupadd --gid=1000 t9kuser && mkdir /t9k && \
useradd -rm --create-home -d /t9k/mnt --shell /bin/bash \
--uid=1000 --gid=1000 t9kuser

RUN echo 't9kuser:tensorstack' | chpasswd && echo "t9kuser ALL=(ALL:ALL) ALL" >> /etc/sudoers

RUN chmod 755 /t9k/mnt
WORKDIR /t9k/mnt

COPY bashrc-conda /etc/bash.bashrc

COPY --chown=t9kuser:t9kuser --from=codeserver /usr/bin/code-server /usr/bin/code-server
COPY --chown=t9kuser:t9kuser --from=codeserver /usr/lib/code-server /usr/lib/code-server

COPY --from=buildsdk /usr/local/bin/* /usr/local/bin/
RUN pip install /usr/local/bin/t9k.tar.gz && \
      pip install /usr/local/bin/codepack.tar.gz && \
      rm -rf /usr/local/bin/t9k.tar.gz && \
      rm -rf /usr/local/bin/codepack.tar.gz && \
      chmod a+rx /usr/local/bin/*

ENV REGISTRY_AUTH_FILE=/t9k/mnt/.docker/config.json
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# COPY ssh_server.sh /t9k/app/ssh_server.sh
COPY entrypoint.sh /t9k/app/entrypoint.sh
COPY extensions.tar.gz /t9k/app/extensions.tar.gz
COPY clp.tar.gz /t9k/app/clp.tar.gz
COPY languagepacks.json /t9k/app/languagepacks.json
RUN chown -R 1000:1000 /t9k/app && chmod 755 /t9k/app
# RUN chmod u+rx /t9k/app/ssh_server.sh
RUN chmod u+rx /t9k/app/entrypoint.sh

USER t9kuser
EXPOSE 8080

ENTRYPOINT ["tini", "--"]
CMD ["sh","-c", "/t9k/app/entrypoint.sh"]
