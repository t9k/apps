#!/bin/bash

# Default values
MODEL_NAME=${MODEL_NAME:-"mlflow-model"}
MODEL_URI=${MODEL_URI:-"/workspace/model"}

# Check if MODEL_URI exists
if [ ! -d "$MODEL_URI" ]; then
    echo "Error: Model directory $MODEL_URI does not exist"
    exit 1
fi

# Change to model directory
cd "$MODEL_URI"

# Create model settings JSON
cat > model-settings.json << EOF
{
    "name": "${MODEL_NAME}",
    "implementation": "mlserver_mlflow.MLflowRuntime",
    "parameters": {
        "uri": "${MODEL_URI}"
    }
}
EOF

# Start MLserver in the model directory
mlserver start .
