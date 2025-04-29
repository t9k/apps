# vLLM

[vLLM](https://github.com/vllm-project/vllm) 是一个快速且易于使用的 LLM 推理和服务库。

vLLM 具备以下高性能特性：

* 最先进的服务吞吐量
* 高效管理注意力键值内存，采用 PagedAttention 技术
* 持续批处理，优化传入请求的处理
* CUDA/HIP 图加速，提升模型执行速度
* 多种量化技术支持，包括 GPTQ、AWQ、INT4、INT8 和 FP8
* 优化的 CUDA 内核，集成 FlashAttention 和 FlashInfer
* 预测解码（Speculative Decoding）
* 分块预填充（Chunked Prefill）

vLLM 具备灵活性和易用性，包括：

* 无缝集成 Hugging Face 热门模型
* 支持多种解码算法，包括并行采样、束搜索等，实现高吞吐量推理
* 支持张量并行与流水线并行，适用于分布式推理
* 流式输出，提升用户体验
* 兼容 OpenAI API 服务器
* 支持多种硬件，包括 NVIDIA GPU、AMD CPU & GPU、Intel CPU & GPU、PowerPC CPU、TPU 以及 AWS Neuron
* 前缀缓存（Prefix Caching）支持
* 多 LoRA 支持

vLLM 无缝支持 Hugging Face 上大多数热门开源模型，包括：

* Transformer 类 LLM（如 Llama）
* 混合专家（MoE）LLM（如 Mixtral、Deepseek-V2、V3）
* 嵌入模型（如 E5-Mistral）
* 多模态 LLM（如 LLaVA）

## 使用方法

待应用就绪后，（安装并）进入一个终端应用，按照应用信息的指引执行命令以验证推理服务可用。

验证成功后，就可以使用该推理服务替代 OpenAI API，即使用 `$ENDPOINT` 替代 `https://api.openai.com`。

## 配置

### 基本配置

考虑两种情况：

1. 如果你已经将模型文件下载到某个存储卷中，将 `server.model.volume.existingClaim` 和 `server.model.volume.subPath` 字段的值分别设为该存储卷的名称和模型文件所在的目录，将 `datacube.source` 字段的值保留为空字符串。

2. 如果你想要让当前应用下载模型文件（实现为创建一个 DataCube 以下载），请参阅 [DataCube 文档](https://t9k.github.io/user-manuals/latest/modules/auxiliary/datacube.html#%E8%AE%BE%E7%BD%AE%E6%BA%90%E5%AD%98%E5%82%A8%E6%9C%8D%E5%8A%A1)和配置模板注释，正确填写 `datacube.source` 字段和相应字段的值，必要时提供代理；根据要下载的模型文件的总大小适当地修改 `server.model.volume.size` 字段的值。

最后将 `server.model.deployName` 字段的值修改为想要的名称。

### 加速设备

使用 NVIDIA GPU 作为加速设备，需要 NVIDIA GPU 的[计算能力（compute capability）](https://developer.nvidia.com/cuda-gpus#compute)达到 7.0 及以上，即 NVIDIA V100、NVIDIA TITAN V、Geforce RTX 20 系及之后的产品。

<!-- 你还可以使用 Enflame GCU、MetaX GPU 或 Hygon DCU 作为加速设备，需要将 `nvidia.com/gpu` 分别替换为 `enflame.com/gcu`、`metax-tech.com/gpu` 和 `hygon.com/dcu`，并选用提供相应环境的镜像。 -->

### 自动容量伸缩

App 支持自动容量伸缩，即根据服务负载的变化，在 `server.autoScaling.minReplicas` 字段定义的最小值和 `server.autoScaling.maxReplicas` 字段定义的最大值之间自动调节推理服务的副本数量。

以下是一些特殊情况：

* `server.autoScaling.minReplicas`（字段的值）为空：会默认设为 1。
* `server.autoScaling.minReplicas` 设为 0：当没有流量请求时，推理服务会缩容到 0，不再占用计算资源。
* `server.autoScaling.maxReplicas` 为空或设为 0：扩容没有上限。
* `server.autoScaling.minReplicas` 等于 `server.autoScaling.maxReplicas` 且大于 0：不进行容量伸缩。

更多信息请参阅[容量伸缩](https://t9k.github.io/ucman/latest/api/t9k-service/mlservice.html#%E5%AE%B9%E9%87%8F%E4%BC%B8%E7%BC%A9)和 [About autoscaling](https://knative.dev/docs/serving/autoscaling/)。

### 示例

部署 DeepSeek-R1-Distill-Qwen-7B 模型为推理服务，模型文件位于 PVC `llm` 的 `DeepSeek-R1-Distill-Qwen-7B/` 子路径下，副本数量固定为 1：

```yaml
server:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/vllm-openai"
    tag: "v0.8.0"
    pullPolicy: IfNotPresent

  resources:
    limits:
      cpu: 4
      memory: 64Gi
      nvidia.com/gpu: 1

  model:
    deployName: "DeepSeek-R1-Distill-Qwen-7B"

    volume:
      storageClass: ""
      size: 32Gi
      accessModes:
        - ReadWriteOnce
      existingClaim: "llm"
      subPath: "DeepSeek-R1-Distill-Qwen-7B/"

  autoScaling:
    minReplicas: 1
    maxReplicas: 1

initializer:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/kubectl"
    tag: "1.27"
    pullPolicy: IfNotPresent
```

部署 Qwen2.5-7B-Instruct 模型为推理服务，模型文件从 Hugging Face 下载，副本数量在 1-3 之间自动伸缩，维持每个副本的并发请求数不超过 32：

```yaml
server:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/vllm-openai"
    tag: "v0.8.0"
    pullPolicy: IfNotPresent

  resources:
    limits:
      cpu: 4
      memory: 64Gi
      nvidia.com/gpu: 1

  model:
    deployName: "Qwen2.5-7B-Instruct"

    volume:
      storageClass: ""
      size: 32Gi
      accessModes:
        - ReadWriteOnce
      existingClaim: ""
      subPath: "Qwen2.5-7B-Instruct/"
  
  autoScaling:
    minReplicas: 1
    maxReplicas: 3
    annotations: 
      autoscaling.knative.dev/metric: "concurrency"
      autoscaling.knative.dev/target: "32"

datacube:
  source: "huggingface"
  huggingface:
    id: "Qwen/Qwen2.5-7B-Instruct"
    files: ""
    existingSecret: ""
  env:
    - name: HF_ENDPOINT
      value: "https://hf-mirror.com"

initializer:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/kubectl"
    tag: "1.27"
    pullPolicy: IfNotPresent
```

部署 Llama-3.3-70B-Instruct 模型为推理服务，模型文件位于 PVC `llm` 的 `Llama-3.3-70B-Instruct/` 子路径下，采用 4 度张量并行：

```yaml
server:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/vllm-openai"
    tag: "v0.8.0"
    pullPolicy: IfNotPresent

  resources:
    limits:
      cpu: 8
      memory: 64Gi
      nvidia.com/gpu: 4

  model:
    deployName: "Llama-3.3-70B-Instruct"

    volume:
      storageClass: ""
      size: 32Gi
      accessModes:
        - ReadWriteOnce
      existingClaim: "llm"
      subPath: "Llama-3.3-70B-Instruct/"
  
  autoScaling:
    minReplicas: 1
    maxReplicas: 1

  app:
    extraArgs:
      - "--tensor-parallel-size=4"
      - "--gpu-memory-utilization=0.95"
      - "--max-model-len=8192"
      - "--max-num-seqs=64"
      - "--enforce-eager"

initializer:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/kubectl"
    tag: "1.27"
    pullPolicy: IfNotPresent
```

部署 Qwen2.5-72B-Instruct 模型为推理服务，模型文件位于 PVC `llm` 的 `Qwen2.5-72B-Instruct/` 子路径下，采用 2 度张量并行，加载时进行 4bit 量化：

```yaml
server:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/vllm-openai"
    tag: "v0.8.0"
    pullPolicy: IfNotPresent

  resources:
    limits:
      cpu: 4
      memory: 64Gi
      nvidia.com/gpu: 2

  model:
    deployName: "Qwen2.5-72B-Instruct"

    volume:
      storageClass: ""
      size: 32Gi
      accessModes:
        - ReadWriteOnce
      existingClaim: "llm"
      subPath: "Qwen2.5-72B-Instruct/"
  
  autoScaling:
    minReplicas: 1
    maxReplicas: 1

  app:
    extraArgs:
      - "--tensor-parallel-size=2"
      - "--quantization=bitsandbytes"
      - "--load-format=bitsandbytes"

initializer:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/kubectl"
    tag: "1.27"
    pullPolicy: IfNotPresent
```

部署 QwQ-32B-GGUF 量化模型为推理服务，模型文件位于 PVC `llm` 的 `QwQ-32B-GGUF/qwq-32b-q5_k_m.gguf` 子路径下：

```yaml
server:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/vllm-openai"
    tag: "v0.8.0"
    pullPolicy: IfNotPresent

  resources:
    limits:
      cpu: 4
      memory: 64Gi
      nvidia.com/gpu: 2

  model:
    deployName: "qwq-32b-q5-k-m"

    volume:
      storageClass: ""
      size: 32Gi
      accessModes:
        - ReadWriteOnce
      existingClaim: "llm"
      subPath: "QwQ-32B-GGUF/qwq-32b-q5_k_m.gguf"
  
  autoScaling:
    minReplicas: 1
    maxReplicas: 1

  app:
    extraArgs:
      - "--tensor-parallel-size=2"

initializer:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/kubectl"
    tag: "1.27"
    pullPolicy: IfNotPresent
```

部署 bge-m3 嵌入模型为推理服务，模型文件位于 PVC `llm` 的 `bge-m3/` 子路径下：

```yaml
server:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/vllm-openai"
    tag: "v0.8.0"
    pullPolicy: IfNotPresent

  resources:
    limits:
      cpu: 4
      memory: 64Gi
      nvidia.com/gpu: 1

  model:
    deployName: "bge-m3"

    volume:
      storageClass: ""
      size: 32Gi
      accessModes:
        - ReadWriteOnce
      existingClaim: "llm"
      subPath: "bge-m3/"

  autoScaling:
    minReplicas: 1
    maxReplicas: 1

initializer:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/kubectl"
    tag: "1.27"
    pullPolicy: IfNotPresent
```

部署 bge-reranker-v2-m3 重排模型为推理服务，模型文件位于 PVC `llm` 的 `bge-reranker-v2-m3/` 子路径下：

```yaml
server:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/vllm-openai"
    tag: "v0.8.0"
    pullPolicy: IfNotPresent

  resources:
    limits:
      cpu: 4
      memory: 64Gi
      nvidia.com/gpu: 1

  model:
    deployName: "bge-reranker-v2-m3"

    volume:
      storageClass: ""
      size: 32Gi
      accessModes:
        - ReadWriteOnce
      existingClaim: "llm"
      subPath: "bge-reranker-v2-m3/"

  autoScaling:
    minReplicas: 1
    maxReplicas: 1

initializer:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/kubectl"
    tag: "1.27"
    pullPolicy: IfNotPresent
```

部署 Qwen2.5-VL-7B-Instruct 多模态模型为推理服务，模型文件位于 PVC `llm` 的 `Qwen2.5-VL-7B-Instruct/` 子路径下：

```yaml
server:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/vllm-openai"
    tag: "v0.8.0"
    pullPolicy: IfNotPresent

  resources:
    limits:
      cpu: 4
      memory: 64Gi
      nvidia.com/gpu: 1

  model:
    deployName: "Qwen2.5-VL-7B-Instruct"

    volume:
      storageClass: ""
      size: 32Gi
      accessModes:
        - ReadWriteOnce
      existingClaim: "llm"
      subPath: "Qwen2.5-VL-7B-Instruct/"

  autoScaling:
    minReplicas: 1
    maxReplicas: 1

initializer:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/kubectl"
    tag: "1.27"
    pullPolicy: IfNotPresent
```

部署 Mistral-7B-Instruct-v0.3 模型为推理服务，模型文件位于 PVC `llm` 的 `Mistral-7B-Instruct-v0.3/` 子路径下，启用工具调用（tool calling）：

```yaml
server:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/vllm-openai"
    tag: "v0.8.0"
    pullPolicy: IfNotPresent

  resources:
    limits:
      cpu: 4
      memory: 64Gi
      nvidia.com/gpu: 1

  model:
    deployName: "Mistral-7B-Instruct-v0.3"

    volume:
      storageClass: ""
      size: 32Gi
      accessModes:
        - ReadWriteOnce
      existingClaim: "llm"
      subPath: "Mistral-7B-Instruct-v0.3/"

  autoScaling:
    minReplicas: 1
    maxReplicas: 1

  app:
    extraArgs:
      - "--enable-auto-tool-choice"
      - "--tool-call-parser=mistral"
      - "--chat-template=examples/tool_chat_template_mistral.jinja"

initializer:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/kubectl"
    tag: "1.27"
    pullPolicy: IfNotPresent
```

### 字段

| 名称                                       | 描述                                             | 值                                       |
| ------------------------------------------ | ------------------------------------------------ | ---------------------------------------- |
| `server.image.registry`                    | vLLM 服务器镜像注册表                            | `$(T9K_APP_IMAGE_REGISTRY)`              |
| `server.image.repository`                  | vLLM 服务器镜像仓库                              | `$(T9K_APP_IMAGE_NAMESPACE)/vllm-openai` |
| `server.image.tag`                         | vLLM 服务器镜像标签                              | `v0.8.0`                                 |
| `server.image.pullPolicy`                  | vLLM 服务器镜像拉取策略                          | `IfNotPresent`                           |
| `server.resources.limits.cpu`              | vLLM 服务器容器能使用的 CPU 上限                 | `4`                                      |
| `server.resources.limits.memory`           | vLLM 服务器容器能使用的内存上限                  | `64Gi`                                   |
| `server.resources.limits."nvidia.com/gpu"` | vLLM 服务器容器能使用的 NVIDIA GPU 上限          | `1`                                      |
| `server.model.deployName`                  | 部署模型的名称                                   | ``                                       |
| `server.model.volume.storageClass`         | 模型卷的存储类别                                 | ``                                       |
| `server.model.volume.size`                 | 模型卷的大小                                     | `32Gi`                                   |
| `server.model.volume.accessModes`          | 模型卷的访问模式                                 | `ReadWriteOnce`                          |
| `server.model.volume.existingClaim`        | 已有的 PVC 模型卷                                | ``                                       |
| `server.model.volume.subPath`              | 模型卷的子目录                                   | ``                                       |
| `server.autoScaling.minReplicas`           | 自动容量伸缩的最小副本数                         | `1`                                      |
| `server.autoScaling.maxReplicas`           | 自动容量伸缩的最大副本数                         | `1`                                      |
| `server.autoScaling.annotations`           | Knative Service 自动扩缩的注解                   | {}                                       |
| `server.app.extraArgs`                     | 为 vLLM engine 设置的额外参数                    | `[]`                                     |
| `server.env`                               | 添加到 vLLM 服务器容器的额外的环境变量           | `[]`                                     |
| `server.extraVolumeMounts`                 | 添加到 vLLM 服务器容器的额外的 volume mount      | `[]`                                     |
| `server.extraVolume`                       | 添加到 vLLM 服务器 Pod 的额外的卷                | `[]`                                     |
| `server.securityContext`                   | 添加到 vLLM 服务器容器的额外的 security context  | `{}`                                     |
| `server.nodeSelector`                      | 用于 vLLM 服务器 Pod 分配的节点标签              | `{}`                                     |
| `datacube.source`                          | 模型的来源（`huggingface`, `git`, `s3` 或 `""`） | ``                                       |
| `datacube.huggingface.id`                  | 模型的 Hugging Face ID                           | ``                                       |
| `datacube.huggingface.files`               | 从 Hugging Face 模型仓库下载的文件               | ``                                       |
| `datacube.huggingface.existingSecret`      | Hugging Face token 的 Secret 引用                | ``                                       |
| `datacube.git.url`                         | Git 仓库 URL                                     | ``                                       |
| `datacube.git.ref`                         | Git 分支、标签或 commit                          | ``                                       |
| `datacube.git.existingSecret`              | Git token 的 Secret 引用                         | ``                                       |
| `datacube.s3.url`                          | S3 URL                                           | ``                                       |
| `datacube.s3.existingSecret`               | 包含 S3 凭证的 s3-env 类型的 Secret 引用         | ``                                       |
| `datacube.env`                             | 添加到 DataCube 容器的额外的环境变量             | `[]`                                     |
| `initializer.image.registry`               | 初始化器镜像注册表                               | `$(T9K_APP_IMAGE_REGISTRY)`              |
| `initializer.image.repository`             | 初始化器镜像仓库                                 | `$(T9K_APP_IMAGE_NAMESPACE)/kubectl`     |
| `initializer.image.tag`                    | 初始化器镜像标签                                 | `1.27`                                   |
| `initializer.image.pullPolicy`             | 初始化器镜像拉取策略                             | `IfNotPresent`                           |
