# Open WebUI

[Open WebUI](https://www.openwebui.com/) 是一个可扩展、功能丰富且用户友好的自托管 WebUI，旨在完全离线运行。它支持各种 LLM 运行器，包括 Ollama 和兼容 OpenAI 的 API。

当前应用的 Helm Chart 修改自 [open-webui/helm-charts](https://github.com/open-webui/helm-charts)。

## 使用方法

部署当前应用，考虑两种情况：

1. 如果你想要让当前应用调用已有的 Ollama API 服务端点（Ollama 应用的推理服务），将 `ollamaUrls` 字段的值设为包含该服务端点的列表。

2. 如果你想要让当前应用部署一个新的 Ollama 服务，将 `ollama.enabled` 字段的值设为 `true`，并参照 Ollama 应用的 README 修改 `ollama` 字段的其余子字段。

需要说明的是，1. 和 2. 并不矛盾，可以同时设置。待实例就绪后，点击相应的链接进入 web UI，即可开始聊天。

web UI 提供“工作空间”和一些设置选项，请自行尝试。

## 配置

### 示例

部署一个新的 Ollama 服务，其禁用 GPU，申请较多的 CPU、内存资源，启动时拉取两个模型：

```yaml
replicaCount: 1

image:
  registry: ghcr.io
  repository: open-webui/open-webui
  tag: latest
  pullPolicy: Always

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

ollama:
  enabled: true

  ollama:
    gpu:
      enabled: false
      type: 'nvidia'
      number: 1
    models:
     - llama3
     - mistral

  resources:
    requests:
      cpu: 8
      memory: 8Gi
    limits:
      cpu: 16
      memory: 16Gi

  persistentVolume:
    enabled: false

ollamaUrls: []

extraEnvVars: []
```

调用已有的 Ollama API 服务端点：

```yaml
replicaCount: 1

image:
  registry: ghcr.io
  repository: open-webui/open-webui
  tag: latest
  pullPolicy: Always

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

ollama:
  enabled: false

ollamaUrls: ["http://<ENDPOINT>"]  # 部署 Ollama 应用，查看其实例信息以获取服务端点

extraEnvVars: []
```

### 参数

| 名称                      | 类型   | 值                        | 描述                                                                                                                                               |
| ------------------------- | ------ | ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `replicaCount`            | int    | `1`                       | 副本数量                                                                                                                                           |
| `image.registry`          | string | `"ghcr.io"`               | Docker 镜像的仓库注册表                                                                                                                            |
| `image.repository`        | string | `"open-webui/open-webui"` | Docker 镜像的仓库名称                                                                                                                              |
| `image.tag`               | string | Docker 镜像的标签 `""`    |                                                                                                                                                    |
| `image.pullPolicy`        | string | `"Always"`                | Docker 镜像的拉取策略                                                                                                                              |
| `service.type`            | string | `"ClusterIP"`             | Kubernetes 服务的类型                                                                                                                              |
| `service.port`            | int    | `80`                      | Kubernetes 服务的端口                                                                                                                              |
| `ingress.enabled`         | bool   | `false`                   | 启用/禁用 Ingress                                                                                                                                  |
| `ingress.class`           | string | `""`                      | Ingress 类                                                                                                                                         |
| `ingress.annotations`     | object | `{}`                      | 使用适当的注释用于您的 Ingress 控制器，例如，对于 NGINX：nginx.ingress.kubernetes.io/rewrite-target: /                                             |
| `ingress.host`            | string | `""`                      | Ingress 的主机                                                                                                                                     |
| `ingress.tls`             | bool   | `false`                   | Ingress 的 TLS 配置                                                                                                                                |
| `ingress.existingSecret`  | string | `""`                      | 已有的 Secret 作为 Ingress 的 TLS 配置                                                                                                             |
| `resources.limits.cpu`    | string | `"1"`                     | Kubernetes 资源的 CPU 限制                                                                                                                         |
| `resources.limits.memory` | string | `"2Gi"`                   | Kubernetes 资源的内存限制                                                                                                                          |
| `ollama.enabled`          | bool   | `true`                    | 自动从 https://otwld.github.io/ollama-helm/ 安装 Ollama Helm chart，使用 [Helm Values](https://github.com/otwld/ollama-helm/#helm-values) 进行配置 |
| `ollama.*`                |        |                           | 参考 [Helm Values](https://github.com/otwld/ollama-helm/#helm-values) 或 Ollama 应用的参数                                                         |
| `ollamaUrls`              | list   | `[]`                      | Ollama API 端点列表。 这些可以替代自动安装 Ollama Helm chart，或与其一起添加。                                                                     |
| `extraEnvVars`            | list   | `[]`                      | 输出部署定义中的其他环境变量。                                                                                                                     |
