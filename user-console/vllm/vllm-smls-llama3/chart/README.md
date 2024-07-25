# vLLM (Llama 3)

[vLLM](https://github.com/vllm-project/vllm) 是一个快速、灵活且易用的开源 LLM 推理和服务库。[Llama 3](https://llama.meta.com/llama3/) 是 Meta 最新开源的系列 LLM，在开源模型中取得了 SOTA 的性能（2024/04），包含 8B 和 70B 参数的版本（预训练和指令微调）。

## 使用方法

请按照以下步骤使用 vLLM 部署 Llama 3 系列模型为推理服务：

1. 创建一个名为 `vllm-llama3`、大小 18GiB（对于 8B 模型）或 150GiB（对于 70B 模型）的存储卷，然后部署一个任意的 Jupyter Lab 应用挂载该存储卷。

2. 进入 Jupyter Lab 应用，启动一个终端，执行以下命令以下载模型文件：

```bash
pip install modelscope

MODEL_NAME=Meta-Llama-3-8B-Instruct  # 或 Meta-Llama-3-70B-Instruct
python -c "from modelscope.models import Model; Model.from_pretrained('LLM-Research/$MODEL_NAME')"
mv .cache/modelscope/hub/LLM-Research/$MODEL_NAME .
```

3. 部署当前应用，将 `model.deployName` 字段的值修改为想要的名称，将`model.subPath` 字段的值设为上一步中的 `$MODEL_NAME`。

4. 待实例就绪后，回到 Jupyter Lab 应用，启动一个终端，按照实例信息执行命令以验证推理服务可用。

5. 验证成功，此时推理服务可以作为 OpenAI API 的替代，即可以使用 `http://$ENDPOINT` 替代 `https://api.openai.com`。

## 配置

### 示例

部署 `Meta-Llama-3-8B-Instruct` 模型为推理服务：

```yaml
replicaCount: 1

image:
  registry: registry.cn-hangzhou.aliyuncs.com
  repository: vllm/vllm-openai
  tag: "v0.3.3"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 4
    memory: 64Gi
    nvidia.com/gpu: 1

model:
  deployName: "llama3-8b"
  existingClaim: "vllm-llama3"
  subPath: "Meta-Llama-3-8B-Instruct"
```

### 参数

| 名称                          | 描述                              | 值                 |
| ----------------------------- | --------------------------------- | ------------------ |
| `replicaCount`                | 部署的副本数量                    | `1`                |
| `image.registry`              | Docker 镜像的仓库注册表           | `docker.io`        |
| `image.repository`            | Docker 镜像的仓库名称             | `vllm/vllm-openai` |
| `image.tag`                   | Docker 镜像的标签                 | `v0.3.3`           |
| `image.pullPolicy`            | Docker 镜像的拉取策略             | `IfNotPresent`     |
| `resources.limits.cpu`        | Kubernetes 资源的 CPU 限制        | `4`                |
| `resources.limits.memory`     | Kubernetes 资源的内存限制         | `64Gi`             |
| `resources.limits.nvidia-gpu` | Kubernetes 资源的 Nvidia GPU 限制 | `1`                |
| `model.deployName`            | 模型部署的名称                    | `llama3-8b`        |
| `model.existingClaim`         | 包含模型文件的 PVC                | `vllm-llama3`      |
| `model.subPath`               | PVC 中模型文件所在的子路径        | `""`               |
