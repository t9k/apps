FROM lengyue233/fish-speech:latest

RUN huggingface-cli download fishaudio/fish-speech-1.2-sft --local-dir checkpoints/fish-speech-1.2-sft
COPY webui.py /exp/tools/webui.py
RUN python -m tools.webui --exit --device cpu

ENV GRADIO_SERVER_NAME=0.0.0.0
ENTRYPOINT [ "python", "-m", "tools.webui" ]
