# vLLM (Llama 3)

[vLLM](https://github.com/vllm-project/vllm) 是一个快速、灵活且易用的开源 LLM 推理和服务库。[Llama 3](https://llama.meta.com/llama3/) 是 Meta 最新开源的系列 LLM，在开源模型中取得了 SOTA 的性能（2024/04），包含 8B 和 70B 参数的版本（预训练和指令微调）。

请按照以下步骤使用 vLLM 部署 Llama 3 系列模型：

1. 创建一个名为 `vllm-llama3`、大小 18GiB（对于 8B 模型）或 150GiB（对于 70B 模型）的存储卷，然后创建一个任意的 Jupyter Lab 应用挂载该存储卷。

2. 进入 Jupyter Lab 应用，启动一个终端，执行以下命令以下载模型文件：

```bash
pip install modelscope

MODEL_NAME=Meta-Llama-3-8B-Instruct  # 或 Meta-Llama-3-70B-Instruct
python -c "from modelscope.models import Model; Model.from_pretrained('LLM-Research/$MODEL_NAME')"
mv .cache/modelscope/hub/LLM-Research/$MODEL_NAME .
```

3. 创建此应用，注意需要将 `model.deployName` 字段的值修改为想要的名称，将`model.subPath` 字段的值修改为上一步中的 `$MODEL_NAME`。

4. 回到 Jupyter Lab 应用，启动一个终端，执行以下命令以验证推理服务可用：

```bash
APP_NAME=<YOUR_APP_NAME>
address=$(kubectl get smls $APP_NAME-vllm-llama3 -ojsonpath='{.status.address.url}')

DEPLOY_NAME=<YOUR_DEPLOY_NAME>
# 聊天
curl $ADDRESS:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "'"$DEPLOY_NAME"'",
    "messages": [{"role": "user", "content": "hello"}],
    "temperature": 0.5,
    "stop_token_ids": [128001, 128009]
  }'
# 生成文本
curl $ADDRESS:8000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "'"$DEPLOY_NAME"'",
    "prompt": "Long long ago, there was",
    "temperature": 0.5,
    "stop_token_ids": [128001, 128009]
  }'
```

5. 验证成功，此时 vLLM 可以作为使用 OpenAI API 的应用程序的即插即用替代品，即可以使用 `http://$ADDRESS:8000` 替代 `https://api.openai.com`。
