# NextChat

[NextChat](https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web) 是一个设计精良的 ChatGPT 网页 UI，支持 ChatGPT、Claude、Gemini 和本地部署的兼容 OpenAI API 的推理服务。

## 配置

### 示例

```yaml
replicaCount: 1

image:
  registry: docker.io
  repository: yidadaa/chatgpt-next-web
  tag: v2.12.2
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 3000

ingress:
  enabled: false
  className: ""
  annotations: {}
  hosts: []
  tls: []

resources:
  limits:
    cpu: 1
    memory: 2Gi

llm:
  provider: "openai"
  api_key: "any"
  openai:
    base_url: "http://<ENDPOINT>"  # 部署 vLLM 应用，查看其实例信息以获取服务端点

  azure:
    url: ""
    api_version: ""

  anthropic:
    url: ""
    api_version: ""

  google:
    url: ""

env: []
```

### 参数

| 名称                        | 描述                                                    | 值                         |
| --------------------------- | ------------------------------------------------------- | -------------------------- |
| `replicaCount`              | 副本数量                                                | `1`                        |
| `image.registry`            | Docker 镜像的存储库                                     | `docker.io`                |
| `image.repository`          | Docker 镜像的存储库名称                                 | `yidadaa/chatgpt-next-web` |
| `image.tag`                 | Docker 镜像的标签                                       | `v2.12.2`                  |
| `image.pullPolicy`          | Docker 镜像的拉取策略                                   | `IfNotPresent`             |
| `service.type`              | Kubernetes 服务的类型                                   | `ClusterIP`                |
| `service.port`              | Kubernetes 服务的端口                                   | `3000`                     |
| `ingress.enabled`           | 启用/禁用 Kubernetes Ingress                            | `false`                    |
| `ingress.className`         | Ingress 类名称                                          | ``                         |
| `ingress.annotations`       | Kubernetes Ingress 注释                                 | `{}`                       |
| `ingress.hosts`             | Kubernetes Ingress 的主机列表                           | `[]`                       |
| `ingress.tls`               | Kubernetes Ingress 的 TLS 配置                          | `[]`                       |
| `resources.limits.cpu`      | Kubernetes 资源的 CPU 限制                              | `1`                        |
| `resources.limits.memory`   | Kubernetes 资源的内存限制                               | `2Gi`                      |
| `llm.provider`              | 模型提供商 (`openai`、`azure`、`anthropic` 或 `google`) | `openai`                   |
| `llm.api_key`               | 访问语言模型提供商的 API 密钥                           | ``                         |
| `llm.openai.base_url`       | 兼容 OpenAI API 的服务器的 URL                          | `https://api.openai.com`   |
| `llm.azure.url`             | Azure 语言模型 API 的 URL                               | ``                         |
| `llm.azure.api_version`     | Azure 语言模型 API 的版本                               | ``                         |
| `llm.anthropic.url`         | Anthropic 语言模型 API 的 URL                           | ``                         |
| `llm.anthropic.api_version` | Anthropic 语言模型 API 的版本                           | ``                         |
| `llm.google.url`            | Google 语言模型 API 的 URL                              | ``                         |
| `env`                       | 额外的环境变量数组                                      | `[]`                       |
