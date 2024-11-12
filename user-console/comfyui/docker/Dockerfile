FROM yanwk/comfyui-boot:cu124-cn-20241111

COPY download.sh /runner-scripts/download.sh
COPY entrypoint.sh /runner-scripts/entrypoint.sh

RUN cd /root && \
  chmod +x /runner-scripts/download.sh && \
  bash /runner-scripts/download.sh && \
  mv /root/{.,}* /home
