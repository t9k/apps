FROM registry.qy.t9kcloud.cn/topsrider/ubuntu:amd64-22.04-3.3.112

COPY TopsRider_i3x_3.3.112_deb_amd64.run .
RUN ./TopsRider_i3x_3.3.112_deb_amd64.run -y -C vllm && \
 rm ./TopsRider_i3x_3.3.112_deb_amd64.run

ENV PATH=$PATH:/opt/tops/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/tops/lib
WORKDIR /workspace
ENTRYPOINT ["python3", "-m", "vllm.entrypoints.openai.api_server"]
