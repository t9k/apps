FROM yanwk/comfyui-boot:latest

USER root
RUN chmod +x /home/scripts/download.sh && \
  bash /home/scripts/download.sh && \
  mkdir /home/runner_backup && \
  mv /home/runner/* /home/runner_backup && \
  chown -R 1000:1000 /home/runner && \
  chown -R 1000:1000 /home/runner_backup
USER runner

COPY entrypoint.sh /home/scripts/entrypoint.sh
