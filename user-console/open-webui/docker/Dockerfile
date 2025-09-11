FROM ghcr.io/open-webui/open-webui:v0.6.25

COPY . .

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/app/backend/entrypoint.sh"]
