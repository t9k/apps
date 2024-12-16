# Ollama

[Ollama](https://ollama.ai/)，在本地快速运行大型语言模型。

当前应用的 Helm Chart 修改自 [otwld/ollama-helm](https://github.com/otwld/ollama-helm)。

## 使用方法

待应用就绪后，（安装并）进入一个终端应用，按照应用信息的指引执行命令以验证推理服务可用。

验证成功后，进一步使用推理服务请参阅：

* [Ollama 官方文档](https://github.com/ollama/ollama/tree/main/docs)
* 通过 RESTful API 交互：[Ollama API](https://github.com/ollama/ollama/blob/main/docs/api.md)
* 通过 OpenAI API-compatible API 交互：[OpenAI compatibility](https://github.com/ollama/ollama/blob/main/docs/openai.md)（实验性功能）
* 使用官方客户端库交互：[ollama-js](https://github.com/ollama/ollama-js#custom-client) 和 [ollama-python](https://github.com/ollama/ollama-python#custom-client)
* 使用 langchain 交互：[langchain-js](https://github.com/ollama/ollama/blob/main/docs/tutorials/langchainjs.md) 和 [langchain-python](https://github.com/ollama/ollama/blob/main/docs/tutorials/langchainpy.md)

## 配置

### 说明

在 `ollama.gpu` 字段下正确填写是否启用 GPU、GPU 的类型和数量，将 `ollama.models` 字段的值设为启动时拉取的模型列表。

### 示例

申请 1 个 CPU（核心）、16 GiB 内存资源以及 1 个 NVIDIA GPU，创建一个大小 30GiB 的存储卷以存储 Ollama 服务器数据，启动时不拉取模型：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/ollama"
  tag: "0.5.2"
  pullPolicy: IfNotPresent

resources:
  requests:
    cpu: 1
    memory: 8Gi

  limits:
    cpu: 1
    memory: 16Gi

ollama:
  gpu:
    enabled: true
    type: 'nvidia'
    number: 1

  models: []

  insecure: false

persistentVolume:
  enabled: true
  accessModes:
    - ReadWriteOnce
  annotations: {}
  existingClaim: ""
  size: 30Gi
  storageClass: ""
  volumeMode: ""
  subPath: ""
```

### 字段

| 名称                             | 描述                                                                                                                                                                                              | 值                                  |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| `image.registry`                 | Ollama 镜像注册表                                                                                                                                                                                 | `$(T9K_APP_IMAGE_REGISTRY)`         |
| `image.repository`               | Ollama 镜像仓库                                                                                                                                                                                   | `$(T9K_APP_IMAGE_NAMESPACE)/ollama` |
| `image.tag`                      | Ollama 镜像标签                                                                                                                                                                                   | `0.5.2`                             |
| `image.pullPolicy`               | Ollama 镜像拉取策略                                                                                                                                                                               | `IfNotPresent`                      |
| `ollama.gpu.enabled`             | 启用 GPU 集成                                                                                                                                                                                     | `false`                             |
| `ollama.gpu.type`                | GPU 类型：'nvidia' 或'amd'。如果 'ollama.gpu.enabled'，默认值是 'nvidia'。如果设置为'amd'，则会在镜像标签中添加 'rocm' 后缀（如果 'image.tag' 未被重载）。这是因为 AMD 和 CPU/CUDA 使用不同的镜像 | `"nvidia"`                          |
| `ollama.gpu.number`              | 指定GPU数量                                                                                                                                                                                       | `1`                                 |
| `ollama.models`                  | 在容器启动时拉取的模型列表 添加的越多，如果模型不存在，容器启动的时间就越长                                                                                                                       | `[]`                                |
| `ollama.insecure`                | 在容器启动时添加不安全标志                                                                                                                                                                        | `false`                             |
| `resources.requests.cpu`         | Ollama 服务器 Pod 的 CPU 请求                                                                                                                                                                     | `"8"`                               |
| `resources.requests.memory`      | Ollama 服务器 Pod 的内存请求                                                                                                                                                                      | `"8Gi"`                             |
| `resources.limits.cpu`           | Ollama 服务器 Pod 的 CPU 限制                                                                                                                                                                     | `"16"`                              |
| `resources.limits.memory`        | Ollama 服务器 Pod 的内存限制                                                                                                                                                                      | `"16Gi"`                            |
| `persistentVolume.enabled`       | 启用使用 PVC 的持久化                                                                                                                                                                             | `false`                             |
| `persistentVolume.accessModes`   | Ollama 服务器数据持久卷访问模式                                                                                                                                                                   | `["ReadWriteOnce"]`                 |
| `persistentVolume.annotations`   | Ollama 服务器数据持久卷注释                                                                                                                                                                       | `{}`                                |
| `persistentVolume.existingClaim` | 如果您想为持久化 Ollama 状态带上自己的 PVC，请在此处传递已创建和就绪的 PVC 的名称。如果设置此值，则该 Chart 不会创建默认 PVC。需要设置 `server.persistentVolume.enabled: true`                    | `""`                                |
| `persistentVolume.size`          | Ollama 服务器数据持久卷大小                                                                                                                                                                       | `"30Gi"`                            |
| `persistentVolume.storageClass`  | Ollama 服务器数据持久卷存储类                                                                                                                                                                     | `""`                                |
| `persistentVolume.volumeMode`    | Ollama 服务器数据持久卷绑定模式                                                                                                                                                                   | `""`                                |
| `persistentVolume.subPath`       | 要挂载的 Ollama 服务器数据持久卷的子目录；如果卷的根目录不为空，此设置很有用                                                                                                                      | `""`                                |
