FROM cr.metax-tech.com/public-ai-release/c500/deepspeed:maca2.29.0.7-py310-ubuntu22.04-amd64

RUN apt-get update && \
  apt-get install -yq --no-install-recommends openssh-server pdsh git libaio-dev ca-certificates && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN chown root:root /usr/lib

# ARG GID=1000
# ARG UID=1000
# RUN groupadd --gid=$GID t9kuser && mkdir /t9k && \
#     useradd -rm --create-home -d /t9k/mnt --shell /bin/bash --uid=$UID --gid=$GID t9kuser && \
#     chown $UID:$GID /t9k/mnt && \
#     mkdir -p /t9k/backup && chown $UID:$GID /t9k/backup

# USER t9kuser

WORKDIR /t9k/backup
RUN git clone --depth 1 https://github.com/hiyouga/LLaMA-Factory.git && \
  mv LLaMA-Factory/data . && \
  rm -rf LLaMA-Factory
COPY launch.sh ./launch.sh

WORKDIR /t9k/mnt
ENV PATH=$PATH:/opt/conda/bin
ENTRYPOINT [ "/t9k/backup/launch.sh" ]
