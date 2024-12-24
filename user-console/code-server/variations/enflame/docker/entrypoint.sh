#!/bin/bash

mkdir -p /t9k/mnt/.local/share/code-server/
tar -zxvf /t9k/app/extensions.tar.gz -C /t9k/mnt/.local/share/code-server/
tar -zxvf /t9k/app/clp.tar.gz -C /t9k/mnt/.local/share/code-server/
cp /t9k/app/languagepacks.json /t9k/mnt/.local/share/code-server/

dumb-init /usr/bin/code-server --bind-addr=0.0.0.0:8080 --locale=zh-cn --auth=none --disable-telemetry /t9k/mnt
