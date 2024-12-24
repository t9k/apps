FROM registry.cn-hangzhou.aliyuncs.com/t9k/code-server:4.92.2 AS codeserver

FROM registry.cn-hangzhou.aliyuncs.com/t9k/build-sdk:1.78.7 AS buildsdk

FROM registry.qingyang.t9kcloud.cn/topsrider/ubuntu:amd64-22.04

COPY TopsRider_i3x_3.2.203_deb_amd64.run .
RUN ./TopsRider_i3x_3.2.203_deb_amd64.run -y -C torch-gcu-2 && \
 rm ./TopsRider_i3x_3.2.203_deb_amd64.run

ENV PATH=$PATH:/opt/tops/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/tops/lib

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
  apt-transport-https \
  bmon \
  build-essential \
  bzip2 \
  ca-certificates \
  curl \
  dumb-init \
  emacs \
  g++ \
  git \
  git-lfs \
  gnupg \
  graphviz \
  htop \
  less \
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
  tree \
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
  datasets==3.0.1 \
  h5py==3.12.1 \
  huggingface-hub==0.26.0 \
  jupyter==1.1.1 \
  lightning==2.4.0 \
  pytorch-lightning==2.4.0 \
  matplotlib==3.9.2 \
  modelscope==1.19.0 \
  modelscope[datasets]==1.19.0 \
  pandas==2.2.3 \
  sentencepiece==0.2.0 \
  torch-model-archiver==0.12.0 \
  torch-tb-profiler==0.4.3 \
  torch-workflow-archiver==0.2.15 \
  torchmetrics==1.5.0 \
  torchtext==0.18.0 \
  transformers==4.45.2

RUN groupadd --gid=1000 t9kuser && mkdir /t9k && \
useradd -rm --create-home -d /t9k/mnt --shell /bin/bash \
--uid=1000 --gid=1000 t9kuser

RUN chmod 755 /t9k/mnt
WORKDIR /t9k/mnt

COPY bashrc /etc/bash.bashrc

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
