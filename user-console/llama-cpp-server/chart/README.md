# vLLM

[vLLM](https://github.com/vllm-project/vllm) 是一个快速、灵活且易用的开源 LLM 推理和服务库。

vLLM 的速度优势包括：

* 最先进的服务吞吐量
* 使用 PagedAttention 高效管理注意力键和值内存
* 连续批处理传入请求
* 使用 CUDA/HIP 图实现快速模型执行
* 量化技术：GPTQ、AWQ、SqueezeLLM、FP8 KV 缓存
* 优化的 CUDA 内核

vLLM 灵活且易用，具备以下特点：

* 无缝集成流行的 Hugging Face 模型
* 使用多种解码算法（包括并行采样、束搜索等）进行高吞吐量服务
* 支持分布式推理的张量并行
* 流式输出
* 兼容 OpenAI 的 API 服务器
* 支持 NVIDIA 和 AMD GPUs
* （实验性）前缀缓存支持
* （实验性）多 lora 支持

vLLM 无缝支持 HuggingFace 上大多数流行的开源模型，包括：

* 类 Transformer 的 LLM（例如 Llama）
* 专家混合 LLM（例如 Mixtral）
* 多模态 LLM（例如 LLaVA）

## 使用方法

请按照以下步骤使用 vLLM 部署 LLM 为推理服务：

1. 部署当前应用，分为两种情况：

    1. 如果你已经将模型文件下载到某个存储卷中，将 `model.volume.existingClaim` 和 `model.volume.subPath` 字段的值分别设为该存储卷的名称和模型文件所在的目录，将 `model.source` 字段的值保留为空字符串。

    2. 如果你想要让当前应用下载模型文件（实现为创建一个 DataCube 以下载），请参阅 [DataCube 文档](https://t9k.github.io/user-manuals/latest/modules/auxiliary/datacube.html#%E8%AE%BE%E7%BD%AE%E6%BA%90%E5%AD%98%E5%82%A8%E6%9C%8D%E5%8A%A1)和配置模板注释，正确填写 `model.source` 字段和相应字段的值，必要时提供代理；根据要下载的模型文件的总大小适当地修改 `model.volume.size` 字段的值。

    最后将 `model.deployName` 字段的值修改为想要的名称。

2. 待应用就绪后，（部署并）进入一个终端应用，按照应用信息的指引执行命令以验证推理服务可用。

3. 验证成功，此时推理服务可以作为 OpenAI API 的替代，即可以使用 `http://$ENDPOINT` 替代 `https://api.openai.com`。

## 配置

### 示例

部署 `CodeLlama-7b-Instruct-hf` 模型为推理服务：

```yaml
replicaCount: 1

image:
  registry: docker.io
  repository: vllm/vllm-openai
  tag: "v0.3.3"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 4
    memory: 64Gi
    nvidia.com/gpu: 1

model:
  deployName: "codellama-7b"

  volume:
    storageClass: ""
    size: 24Gi
    accessModes:
      - ReadWriteOnce
    existingClaim: ""
    subPath: "CodeLlama-7b-Instruct-hf"

  source: "huggingface"
  huggingface:
    id: "codellama/CodeLlama-7b-Instruct-hf"
    files: ""
    existingSecret: ""

env:
  - name: HTTP_PROXY
    value: "<YOUR_HTTP_PROXY>"
  - name: HTTPS_PROXY
    value: "<YOUR_HTTPS_PROXY>"
```

### 字段

| 名称                               | 描述                                           | 值                 |
| ---------------------------------- | ---------------------------------------------- | ------------------ |
| `replicaCount`                     | 副本数量                                       | `1`                |
| `image.registry`                   | Docker 镜像的存储库                            | `docker.io`        |
| `image.repository`                 | Docker 镜像的存储库名称                        | `vllm/vllm-openai` |
| `image.tag`                        | Docker 镜像的标签                              | `v0.3.3`           |
| `image.pullPolicy`                 | Docker 镜像的拉取策略                          | `IfNotPresent`     |
| `resources.limits.cpu`             | Kubernetes 资源的 CPU 限制                     | `4`                |
| `resources.limits.memory`          | Kubernetes 资源的内存限制                      | `64Gi`             |
| `resources.limits."nvidia.com/gpu"`  | Kubernetes 资源的 NVIDIA GPU 限制              | `1`                |
| `model.deployName`                 | 部署模型的名称                                 | ``                 |
| `model.volume.storageClass`        | 模型卷的存储类别                               | ``                 |
| `model.volume.size`                | 模型卷的大小                                   | `32Gi`             |
| `model.volume.accessModes`         | 模型卷的访问模式                               | `ReadWriteOnce`    |
| `model.volume.existingClaim`       | 已有 PVC 模型卷                                | ``                 |
| `model.volume.subPath`             | 模型卷的子目录                                 | ``                 |
| `model.source`                     | 模型的来源（`huggingface`, `git`, `s3` 或 ""） | ``                 |
| `model.huggingface.id`             | 模型的 Hugging Face ID                         | ``                 |
| `model.huggingface.files`          | 从 Hugging Face 模型仓库下载的文件             | ``                 |
| `model.huggingface.existingSecret` | Hugging Face token 的 Secret 引用              | ``                 |
| `model.git.url`                    | Git 仓库 URL                                   | ``                 |
| `model.git.ref`                    | Git 分支、标签或 commit                        | ``                 |
| `model.git.existingSecret`         | Git token 的 Secret 引用                       | ``                 |
| `model.s3.url`                     | S3 URL                                         | ``                 |
| `model.s3.existingSecret`          | 包含 S3 凭证的 s3-env 类型的 Secret 引用       | ``                 |
| `env`                              | 额外的环境变量数组                             | `[]`               |
