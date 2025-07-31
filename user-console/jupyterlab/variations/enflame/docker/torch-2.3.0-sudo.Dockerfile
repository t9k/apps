FROM registry.cn-hangzhou.aliyuncs.com/t9k/build-sdk:1.78.7 AS buildsdk

FROM registry.qingyang.t9kcloud.cn/topsrider/ubuntu:amd64-22.04

COPY TopsRider_i3x_3.2.203_deb_amd64.run .
RUN ./TopsRider_i3x_3.2.203_deb_amd64.run -y -C torch-gcu-2 && \
 rm ./TopsRider_i3x_3.2.203_deb_amd64.run

ENV PATH=$PATH:/opt/tops/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/tops/lib

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV NB_PREFIX=/

# Use bash instead of sh
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -yq --no-install-recommends \
  apt-transport-https \
  bmon \
  build-essential \
  bzip2 \
  ca-certificates \
  curl \
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
  nano \
  openssh-client \
  openssh-server \
  rclone \
  rsync \
  s3cmd \
  screen \
  sudo \
  tmux \
  tree \
  unzip \
  vim \
  wget \
  zip \
  && apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
ENV SHELL=/bin/bash

# NOTE: Beyond this point be careful of breaking out
# or otherwise adding new layers with RUN, chown, etc.
# The image size can grow significantly.

RUN pip uninstall enum34 -y

# unset http proxy, pip --proxy="" doesn't work
ENV http_proxy= \
  HTTP_PROXY= \
  https_proxy= \
  HTTPS_PROXY=

# Install base python3 packages
RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip && \
  pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple --default-timeout=100 \
  datasets==3.0.1 \
  h5py==3.12.1 \
  huggingface-hub==0.26.0 \
  ipywidgets==8.1.5 \
  jupyter==1.1.1 \
  jupyterlab==4.2.5 \
  jupyterlab-language-pack-zh-CN==4.2.post3 \
  jupyterlab-tensorboard-pro==4.0.0 \
  jupyterlab-widgets==3.0.13 \
  lightning==2.4.0 \
  matplotlib==3.9.2 \
  modelscope==1.19.0 \
  modelscope[datasets]==1.19.0 \
  pytorch-lightning==2.4.0 \
  pandas==2.2.3 \
  sentencepiece==0.2.0 \
  torch-model-archiver==0.12.0 \
  torch-tb-profiler==0.4.3 \
  torch-workflow-archiver==0.2.15 \
  torchmetrics==1.5.0 \
  torchtext==0.18.0 \
  transformers==4.45.2

ARG GID=1000
ARG UID=1000
RUN groupadd --gid=$GID t9kuser && mkdir /t9k && \
  useradd -rm --create-home -d /t9k/mnt --shell /bin/bash \
  --uid=$UID --gid=$GID t9kuser

# https://unix.stackexchange.com/questions/4484/ssh-prompts-for-password-despite-ssh-copy-id
# sshd has strict requirements about permissions on $HOME, $HOME/.ssh
RUN chmod 755 /t9k/mnt
WORKDIR /t9k/mnt

# TODO: User should be refactored instead of hard coded t9kuser

COPY bashrc /etc/bash.bashrc

COPY --from=buildsdk /usr/local/bin/* /usr/local/bin/

RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple /usr/local/bin/t9k.tar.gz && \
      pip install -i https://pypi.tuna.tsinghua.edu.cn/simple /usr/local/bin/codepack.tar.gz && \
      rm -rf /usr/local/bin/t9k.tar.gz && \
      rm -rf /usr/local/bin/codepack.tar.gz && \
      chmod a+rx /usr/local/bin/*

ENV REGISTRY_AUTH_FILE=/t9k/mnt/.docker/config.json
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ssh_server.sh /t9k/app/ssh_server.sh
COPY entrypoint.sh /t9k/app/entrypoint.sh
RUN chown -R 1000:1000 /t9k/app && chmod 755 /t9k/app
RUN chmod u+rx /t9k/app/ssh_server.sh
RUN chmod u+rx /t9k/app/entrypoint.sh

RUN echo 't9kuser:tensorstack' | chpasswd && echo "t9kuser ALL=(ALL:ALL) ALL" >> /etc/sudoers

USER t9kuser

# Configure container startup
EXPOSE 2222
EXPOSE 8888

ENTRYPOINT ["tini", "--"]
CMD ["sh","-c", "/t9k/app/entrypoint.sh"]
