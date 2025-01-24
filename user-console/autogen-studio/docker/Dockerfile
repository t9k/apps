FROM python:3.10-slim

RUN pip install -U "autogen-agentchat" "autogen-ext[openai]" "autogenstudio"

ENV GRADIO_SERVER_NAME=0.0.0.0
ENTRYPOINT [ "autogenstudio", "ui", "--port", "8080", "--host", "0.0.0.0" ]
