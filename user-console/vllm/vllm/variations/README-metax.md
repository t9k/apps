# vLLM

[vLLM](https://github.com/vllm-project/vllm) 是一个快速、灵活且易用的开源 LLM 推理和服务库。

vLLM 的速度优势包括：

- 最先进的服务吞吐量
- 使用 PagedAttention 高效管理注意力键和值内存
- 连续批处理传入请求
- 使用 CUDA/HIP 图实现快速模型执行
- 量化技术：GPTQ、AWQ、SqueezeLLM、FP8 KV 缓存
- 优化的 CUDA 内核

vLLM 灵活且易用，具备以下特点：

- 无缝集成流行的 Hugging Face 模型
- 使用多种解码算法（包括并行采样、束搜索等）进行高吞吐量服务
- 支持分布式推理的张量并行
- 流式输出
- 兼容 OpenAI 的 API 服务器
- 支持 NVIDIA 和 AMD GPUs
- （实验性）前缀缓存支持
- （实验性）多 lora 支持

vLLM 无缝支持 HuggingFace 上大多数流行的开源模型，包括：

- 类 Transformer 的 LLM（例如 Llama）
- 专家混合 LLM（例如 Mixtral）
- 多模态 LLM（例如 LLaVA）

## 使用方法

待应用就绪后，（安装并）进入一个终端应用，按照应用信息的指引执行命令以验证推理服务可用。

验证成功后，就可以使用该推理服务替代 OpenAI API，即使用 `http://$ENDPOINT` 替代 `https://api.openai.com`。

## 配置

### 基本配置

考虑两种情况：

1. 如果你已经将模型文件下载到某个存储卷中，将 `server.model.volume.existingClaim` 和 `server.model.volume.subPath` 字段的值分别设为该存储卷的名称和模型文件所在的目录，将 `datacube.source` 字段的值保留为空字符串。

2. 如果你想要让当前应用下载模型文件（实现为创建一个 DataCube 以下载），请参阅 [DataCube 文档](https://t9k.github.io/user-manuals/latest/modules/auxiliary/datacube.html#%E8%AE%BE%E7%BD%AE%E6%BA%90%E5%AD%98%E5%82%A8%E6%9C%8D%E5%8A%A1)和配置模板注释，正确填写 `datacube.source` 字段和相应字段的值，必要时提供代理；根据要下载的模型文件的总大小适当地修改 `server.model.volume.size` 字段的值。

最后将 `server.model.deployName` 字段的值修改为想要的名称。

### 加速设备

使用 MetaX GPU 作为加速设备。

<!-- 你还可以使用 Enflame GCU、MetaX GPU 或 Hygon DCU 作为加速设备，需要将 `metax-tech.com/gpu` 分别替换为 `enflame.com/gcu`、`metax-tech.com/gpu` 和 `hygon.com/dcu`，并选用提供相应环境的镜像。 -->

### 自动容量伸缩

App 支持自动容量伸缩，即根据服务负载的变化，在 `server.autoScaling.minReplicas` 字段定义的最小值和 `server.autoScaling.maxReplicas` 字段定义的最大值之间自动调节推理服务的副本数量。

以下是一些特殊情况：

* `server.autoScaling.minReplicas`（字段的值）为空：会默认设为 1。
* `server.autoScaling.minReplicas` 设为 0：当没有流量请求时，推理服务会缩容到 0，不再占用计算资源。
* `server.autoScaling.maxReplicas` 为空或设为 0：扩容没有上限。
* `server.autoScaling.minReplicas` 等于 `server.autoScaling.maxReplicas` 且大于 0：不进行容量伸缩。

更多信息请参阅[容量伸缩](https://t9k.github.io/ucman/latest/api/t9k-service/mlservice.html#%E5%AE%B9%E9%87%8F%E4%BC%B8%E7%BC%A9)和 [About autoscaling](https://knative.dev/docs/serving/autoscaling/)。

### 示例

部署 Llama-3.1-8B-Instruct 模型为推理服务，模型文件位于 PVC `llm` 的 `Llama-3.1-8B-Instruct/` 子路径下，副本数量固定为 1：

```yaml
server:
  image:
    registry: "registry.suanfeng.t9kcloud.cn"
    repository: "testing/mxc500-vllm"
    tag: "20241010"
    pullPolicy: IfNotPresent

  resources:
    limits:
      cpu: 4
      memory: 64Gi
      metax-tech.com/gpu: 1

  model:
    deployName: "llama"

    volume:
      storageClass: ""
      size: 32Gi
      accessModes:
        - ReadWriteOnce
      existingClaim: "llm"
      subPath: "Llama-3.1-8B-Instruct/"

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

部署 Qwen2.5-7B-Instruct 模型为推理服务，模型文件从 Hugging Face 下载，副本数量在 1-3 之间自动伸缩，维持每个副本的并发请求数不超过 10：

```yaml
server:
  image:
    registry: "registry.suanfeng.t9kcloud.cn"
    repository: "testing/mxc500-vllm"
    tag: "20241010"
    pullPolicy: IfNotPresent

  resources:
    limits:
      cpu: 4
      memory: 64Gi
      metax-tech.com/gpu: 1

  model:
    deployName: "qwen"

    volume:
      storageClass: ""
      size: 24Gi
      accessModes:
        - ReadWriteOnce
      existingClaim: ""
      subPath: "Qwen2.5-7B-Instruct"
  
  autoScaling:
    minReplicas: 1
    maxReplicas: 3
    annotations: 
      autoscaling.knative.dev/metric: "concurrency"
      autoscaling.knative.dev/target: "10"

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

部署 Llama-3.1-70B-Instruct 模型为推理服务，模型文件位于 PVC `llm` 的 `Llama-3.1-70B-Instruct/` 子路径下，副本数量固定为 1：

```yaml
server:
  image:
    registry: "registry.suanfeng.t9kcloud.cn"
    repository: "testing/mxc500-vllm"
    tag: "20241010"
    pullPolicy: IfNotPresent

  resources:
    limits:
      cpu: 4
      memory: 64Gi
      metax-tech.com/gpu: 4

  model:
    deployName: "llama"

    volume:
      storageClass: ""
      size: 24Gi
      accessModes:
        - ReadWriteOnce
      existingClaim: "llm"
      subPath: "Llama-3.1-70B-Instruct"
  
  autoScaling:
    minReplicas: 1
    maxReplicas: 1

  app:
    extraArgs:
      - "--tensor-parallel-size=4"

initializer:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/kubectl"
    tag: "1.27"
    pullPolicy: IfNotPresent
```

### 字段

| 名称                                           | 描述                                           | 值                                   |
| ---------------------------------------------- | ---------------------------------------------- | ------------------------------------ |
| `server.image.registry`                        | 服务器镜像的注册表                             | `registry.suanfeng.t9kcloud.cn`      |
| `server.image.repository`                      | 服务器镜像的仓库                               | `testing/mxc500-vllm`                |
| `server.image.tag`                             | 服务器镜像的标签                               | `20241010`                           |
| `server.image.pullPolicy`                      | 服务器镜像的拉取策略                           | `IfNotPresent`                       |
| `server.resources.limits.cpu`                  | 服务器容器的 CPU 限制                          | `4`                                  |
| `server.resources.limits.memory`               | 服务器容器的内存限制                           | `64Gi`                               |
| `server.resources.limits."metax-tech.com/gpu"` | 服务器容器的 MetaX GPU 限制                    | `1`                                  |
| `server.model.deployName`                      | 部署模型的名称                                 | ``                                   |
| `server.model.volume.storageClass`             | 模型卷的存储类别                               | ``                                   |
| `server.model.volume.size`                     | 模型卷的大小                                   | `32Gi`                               |
| `server.model.volume.accessModes`              | 模型卷的访问模式                               | `ReadWriteOnce`                      |
| `server.model.volume.existingClaim`            | 已有的 PVC 模型卷                              | ``                                   |
| `server.model.volume.subPath`                  | 模型卷的子目录                                 | ``                                   |
| `server.autoScaling.minReplicas`               | 自动容量伸缩的最小副本数                       | `1`                                  |
| `server.autoScaling.maxReplicas`               | 自动容量伸缩的最大副本数                       | `1`                                  |
| `server.autoScaling.annotations`               | Knative Service 自动扩缩的注解                 | {}                                   |
| `server.app.extraArgs`                         | 为 vLLM engine 设置的额外参数                  | `[]`                                 |
| `server.env`                                   | 添加到服务器容器的额外的环境变量               | `[]`                                 |
| `server.extraVolumeMounts`                     | 添加到服务器容器的额外的 volume mount          | `[]`                                 |
| `server.extraVolume`                           | 添加到服务器 Pod 的额外的卷                    | `[]`                                 |
| `server.securityContext`                       | 添加到服务器容器的额外的 security context      | `{}`                                 |
| `server.nodeSelector`                          | 用于服务器 Pod 分配的节点标签                  | `{}`                                 |
| `datacube.source`                              | 模型的来源（`huggingface`, `git`, `s3` 或 ""） | ``                                   |
| `datacube.huggingface.id`                      | 模型的 Hugging Face ID                         | ``                                   |
| `datacube.huggingface.files`                   | 从 Hugging Face 模型仓库下载的文件             | ``                                   |
| `datacube.huggingface.existingSecret`          | Hugging Face token 的 Secret 引用              | ``                                   |
| `datacube.git.url`                             | Git 仓库 URL                                   | ``                                   |
| `datacube.git.ref`                             | Git 分支、标签或 commit                        | ``                                   |
| `datacube.git.existingSecret`                  | Git token 的 Secret 引用                       | ``                                   |
| `datacube.s3.url`                              | S3 URL                                         | ``                                   |
| `datacube.s3.existingSecret`                   | 包含 S3 凭证的 s3-env 类型的 Secret 引用       | ``                                   |
| `datacube.env`                                 | 添加到 datacube 容器的额外的环境变量           | `[]`                                 |
| `initializer.image.registry`                   | 初始化器镜像的注册表                           | `$(T9K_APP_IMAGE_REGISTRY)`          |
| `initializer.image.repository`                 | 初始化器镜像的仓库                             | `$(T9K_APP_IMAGE_NAMESPACE)/kubectl` |
| `initializer.image.tag`                        | 初始化器镜像的标签                             | `1.27`                               |
| `initializer.image.pullPolicy`                 | 初始化器镜像的拉取策略                         | `IfNotPresent`                       |
