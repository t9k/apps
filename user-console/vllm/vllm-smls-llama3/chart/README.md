# vLLM (Llama 3.1)

[vLLM](https://github.com/vllm-project/vllm) 是一个快速、灵活且易用的开源 LLM 推理和服务库。[Llama 3.1](https://llama.meta.com/) 是 Meta 最新开源的系列 LLM，在开源模型中取得了 SOTA 的性能（2024/07），包含 8B、70B 和 405B 参数的版本（预训练和指令微调）。

## 全流程操作步骤

请按照以下步骤使用 vLLM 部署 Llama 3.1 系列模型为推理服务：

1. 创建一个名为 `vllm-llama3-1`、大小 18GiB（对于 8B 模型）或 150GiB（对于 70B 模型）的存储卷，然后安装一个任意的 JupyterLab 应用挂载该存储卷。

2. 进入 JupyterLab 应用，启动一个终端，执行以下命令以下载模型文件：

```bash
pip install modelscope

MODEL_NAME=Meta-Llama-3.1-8B-Instruct  # 或 Meta-Llama-3.1-70B-Instruct
modelscope download --model "LLM-Research/$MODEL_NAME" --exclude "original/*" --local_dir "./$MODEL_NAME"
```

3. 安装当前应用，将 `model.deployName` 字段的值修改为想要的名称，将`model.subPath` 字段的值设为上一步中的 `$MODEL_NAME`。

4. 待应用就绪后，回到 JupyterLab 应用，启动一个终端，按照应用信息执行命令以验证推理服务可用。

5. 验证成功，此时推理服务可以作为 OpenAI API 的替代，即可以使用 `http://$ENDPOINT` 替代 `https://api.openai.com`。

## 配置

### 示例

部署 `Meta-Llama-3.1-8B-Instruct` 模型为推理服务：

```yaml
resources:
  limits:
    cpu: 4
    memory: 64Gi
    nvidia.com/gpu: 1

model:
  deployName: "llama3-1-8b"
  existingClaim: "vllm-llama3-1"
  subPath: "Meta-Llama-3.1-8B-Instruct"

app:
  extraArgs:
    - "--trust-remote-code"
    - "--enforce-eager"
```

### 字段

| 名称                                | 描述                              | 值                      |
| ----------------------------------- | --------------------------------- | ----------------------- |
| `replicaCount`                      | 部署的副本数量                    | `1`                     |
| `server.image.registry`             | vllm 镜像的注册表                 | `docker.io`             |
| `server.image.repository`           | vllm 镜像的仓库                   | `t9kpublic/vllm-openai` |
| `server.image.tag`                  | vllm 镜像的标签                   | `v0.5.4`                |
| `busybox.image.registry`            | busybox 镜像的注册表              | `docker.io`             |
| `busybox.image.repository`          | busybox 镜像的仓库                | `t9kpublic/busybox`     |
| `busybox.image.tag`                 | busybox 镜像的标签                | `20240913`              |
| `imagePullPolicy`                   | Docker 镜像的拉取策略             | `IfNotPresent`          |
| `resources.limits.cpu`              | Kubernetes 资源的 CPU 限制        | `4`                     |
| `resources.limits.memory`           | Kubernetes 资源的内存限制         | `64Gi`                  |
| `resources.limits."nvidia.com/gpu"` | Kubernetes 资源的 NVIDIA GPU 限制 | `1`                     |
| `model.deployName`                  | 模型部署的名称                    | `llama3-1-8b`           |
| `model.existingClaim`               | 包含模型文件的 PVC                | `vllm-llama3-1`         |
| `model.subPath`                     | PVC 中模型文件所在的子路径        | `""`                    |
| `app.extraArgs`                     | 为 vLLM engine 设置的额外参数     | `[]`                    |
