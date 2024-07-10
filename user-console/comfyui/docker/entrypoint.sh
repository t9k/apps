#!/bin/bash
set -e

if [ ! -f "/home/runner/.download-complete" ] ; then
    mv /home/runner_backup/* /home/runner
    touch /home/runner/.download-complete
fi ;

echo "########################################"
echo "[INFO] Starting ComfyUI..."
echo "########################################"

export PATH="${PATH}:/home/runner/.local/bin"
export PYTHONPYCACHEPREFIX="/home/runner/.cache/pycache"

cd /home/runner

python3 ./ComfyUI/main.py --listen --port 8188 ${CLI_ARGS}
