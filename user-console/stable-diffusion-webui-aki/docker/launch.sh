#!/bin/bash

mv outputs_backup/* outputs
mv models_backup/* models

python launch.py $@
