# Open WebUI

[Open WebUI](https://www.openwebui.com/) 是一个可扩展、功能丰富且用户友好的自托管 WebUI，旨在完全离线运行。它支持各种 LLM 运行器，包括 Ollama 和兼容 OpenAI 的 API。

当前应用的 Helm Chart 修改自 [open-webui/helm-charts](https://github.com/open-webui/helm-charts)。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始聊天。

![](https://s2.loli.net/2024/08/22/Gdx9rCv7B3wjShf.png)

网页 UI 的使用方法比较简单直观，请用户自行尝试。网页 UI 的高级用法请参阅 [Tutorial](https://docs.openwebui.com/category/-tutorial)。Pipelines 插件的使用方法可以参阅 [Getting Started with OpenWebUI Pipelines](https://ikasten.io/2024/06/03/getting-started-with-openwebui-pipelines/)。

## 使用说明

* 应用数据全部存储在随应用创建的 PVC `app-open-webui-xxxxxxxx` 中，包括聊天记录、上传的文件、工具模型（文本嵌入模型等）、向量数据等。

* 默认的 PVC 大小为 2 GiB，请根据应用的使用规模进行适当的调整。另外，该 PVC 在创建完成后也可以进行扩容。

* 首个注册的用户将自动成为应用的管理员，后续注册的用户需要由管理员手动激活（或者由管理员修改默认用户角色）。只有管理员可以进入管理员面板，修改外部连接、模型、Pipelines、数据库等关键设置。

## 配置

### 说明

考虑两种情况：

1. 如果你想要让当前应用调用已有的 Ollama API 服务端点（Ollama 应用的推理服务），将 `ollamaUrls` 字段的值设为包含该服务端点的列表。

2. 如果你想要让当前应用部署一个新的 Ollama 服务，将 `ollama.enabled` 字段的值设为 `true`，并参照 Ollama 应用的 README 修改 `ollama` 字段的其余子字段。

需要说明的是，1. 和 2. 并不矛盾，可以同时设置。

### 示例

应用本身申请 1 个 CPU（核心）和 2 GiB 内存资源，创建一个大小 2 GiB 的 PVC 以持久化应用数据；部署一个新的 Ollama 服务，其申请 1 个 CPU（核心）、16 GiB 内存资源以及 1 个 NVIDIA GPU，创建一个大小 30GiB 的 PVC 以存储 Ollama 服务器数据，启动时拉取两个模型；启用 Pipelines：

```yaml
replicaCount: 1

image:
  registry: ghcr.io
  repository: open-webui/open-webui
  tag: latest
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false
  class: ""
  annotations: {}
  host: ""
  tls: false
  existingSecret: ""

resources:
  limits:
    cpu: 1
    memory: 2Gi

persistence:
  storageClass: ""
  size: 2Gi
  accessModes:
    - ReadWriteOnce
  existingClaim: ""

ollama:
  enabled: true

  ollama:
    gpu:
      enabled: true
      type: 'nvidia'
      number: 1
    models:
     - llama3.1
     - qwen2

  resources:
    requests:
      cpu: 1
      memory: 8Gi
    limits:
      cpu: 1
      memory: 16Gi

  persistentVolume:
    enabled: true
    size: 30Gi

ollamaUrls: []

pipelines:
  enabled: true
  extraEnvVars: []

extraEnvVars: []
```

调用已有的 Ollama API 服务端点；禁用 Pipelines：

```yaml
replicaCount: 1

image:
  registry: ghcr.io
  repository: open-webui/open-webui
  tag: latest
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false
  class: ""
  annotations: {}
  host: ""
  tls: false
  existingSecret: ""

resources:
  limits:
    cpu: 1
    memory: 2Gi

persistence:
  storageClass: ""
  size: 2Gi
  accessModes:
    - ReadWriteOnce
  existingClaim: ""

ollama:
  enabled: false

  ollama:
    gpu:
      enabled: true
      type: 'nvidia'
      number: 1
    models: []

  resources:
    requests:
      cpu: 1
      memory: 8Gi
    limits:
      cpu: 1
      memory: 16Gi

  persistentVolume:
    enabled: true
    size: 30Gi

ollamaUrls: ["http://<ENDPOINT>"]  # 安装 Ollama 应用，查看其应用信息以获取服务端点

pipelines:
  enabled: false
  extraEnvVars: []

extraEnvVars: []
```

### 字段

| 名称                        | 类型   | 值                        | 描述                                                                                                                                               |
| --------------------------- | ------ | ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `replicaCount`              | int    | `1`                       | 副本数量                                                                                                                                           |
| `image.registry`            | string | `"ghcr.io"`               | Docker 镜像的仓库注册表                                                                                                                            |
| `image.repository`          | string | `"open-webui/open-webui"` | Docker 镜像的仓库名称                                                                                                                              |
| `image.tag`                 | string | `"latest"`                | Docker 镜像的标签                                                                                                                                  |
| `image.pullPolicy`          | string | `"IfNotPresent"`          | Docker 镜像的拉取策略                                                                                                                              |
| `service.type`              | string | `"ClusterIP"`             | Kubernetes 服务的类型                                                                                                                              |
| `service.port`              | int    | `80`                      | Kubernetes 服务的端口                                                                                                                              |
| `ingress.enabled`           | bool   | `false`                   | 启用/禁用 Ingress                                                                                                                                  |
| `ingress.class`             | string | `""`                      | Ingress 类                                                                                                                                         |
| `ingress.annotations`       | object | `{}`                      | 使用适当的注释用于您的 Ingress 控制器，例如，对于 NGINX：nginx.ingress.kubernetes.io/rewrite-target: /                                             |
| `ingress.host`              | string | `""`                      | Ingress 的主机                                                                                                                                     |
| `ingress.tls`               | bool   | `false`                   | Ingress 的 TLS 配置                                                                                                                                |
| `ingress.existingSecret`    | string | `""`                      | 已有的 Secret 作为 Ingress 的 TLS 配置                                                                                                             |
| `resources.limits.cpu`      | string | `"1"`                     | Kubernetes 资源的 CPU 限制                                                                                                                         |
| `resources.limits.memory`   | string | `"2Gi"`                   | Kubernetes 资源的内存限制                                                                                                                          |
| `persistence.storageClass`  | string | `""`                      | PVC 的存储类                                                                                                                                       |
| `persistence.size`          | string | `"2Gi"`                   | PVC 的大小                                                                                                                                         |
| `persistence.accessModes`   | list   | `["ReadWriteOnce"]`       | PVC 的访问模式。如果使用多个副本，必须更新 accessModes 为 ReadWriteMany                                                                            |
| `persistence.existingClaim` | string | `""`                      | 使用现有 PVC 的名称                                                                                                                                |
| `ollama.enabled`            | bool   | `true`                    | 自动从 https://otwld.github.io/ollama-helm/ 安装 Ollama Helm chart，使用 [Helm Values](https://github.com/otwld/ollama-helm/#helm-values) 进行配置 |
| `ollama.*`                  |        |                           | 参考 [Helm Values](https://github.com/otwld/ollama-helm/#helm-values) 或 Ollama 应用的参数                                                         |
| `ollamaUrls`                | list   | `[]`                      | Ollama API 端点列表。 这些可以替代自动安装 Ollama Helm chart，或与其一起添加。                                                                     |
| `pipelines.enabled`         | bool   | `true`                    | 自动安装 Pipelines chart 以使用 Pipelines 扩展 Open WebUI 功能：https://github.com/open-webui/pipelines                                            |
| `pipelines.extraEnvVars`    | list   | `[]`                      | 此部分可用于传递所需的环境变量到您的 pipelines（例如 Langfuse 主机名）                                                                             |
| `extraEnvVars`              | list   | `[]`                      | 输出部署定义中的其他环境变量。                                                                                                                     |
