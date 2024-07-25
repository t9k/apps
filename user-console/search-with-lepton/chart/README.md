# Search with Lepton

[Search with Lepton](https://github.com/leptonai/search_with_lepton) 是一个开源的对话式搜索引擎（conversational search engine）。

特性：

* 内置对 LLM 的支持
* 内置对搜索引擎的支持
* 可定制的漂亮 UI 界面
* 可共享的、缓存的搜索结果

## 使用方法

部署当前应用，在 `llm` 字段下正确填写 OpenAI API Key 和调用的模型名称，在 `searchEngine` 字段下正确填写搜索引擎提供商以及相应的 API Key，必要时提供代理。待实例就绪后，点击相应的链接进入 web UI，即可开始搜索。

如要将兼容 OpenAI API 的本地推理服务（例如 vLLM 应用的推理服务）作为模型提供商，将 `llm.baseUrl` 字段的值设为该本地推理服务的服务端点，将 `llm.apiKey` 字段的值设为任意非空字符串，将 `llm.modelName` 字段的值设为模型的部署名称。

## 配置

### 示例

模型提供商选用 vLLM 应用的推理服务，搜索引擎提供商选用 Serper：

```yaml
replicaCount: 1

image:
  registry: registry.cn-hangzhou.aliyuncs.com
  repository: t9k/search-with-lepton
  tag: "20240208"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 8080

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
  baseUrl: "http://<ENDPOINT>/v1"  # 部署 vLLM 应用，查看其实例信息以获取服务端点
  apiKey: "any"
  modelName: "<DEPLOY_NAME>"  # 模型以该名称被部署

searchEngine:
  provider: "SERPER"
  apiKey: "<YOUR_SERPER_API_KEY>"
  google:
    cxKey: ""

env:
  - name: HTTP_PROXY
    value: "<YOUR_HTTP_PROXY>"
  - name: HTTPS_PROXY
    value: "<YOUR_HTTPS_PROXY>"
  - name: NO_PROXY
    value: ".cluster.local"
```

### 参数

| 名称                         | 描述                                                             | 值                             |
| ---------------------------- | ---------------------------------------------------------------- | ------------------------------ |
| `replicaCount`               | 副本数量                                                         | `1`                            |
| `image.registry`             | Docker 镜像的存储库                                              | `docker.io`                    |
| `image.repository`           | Docker 镜像的存储库名称                                          | `t9k/search-with-lepton` |
| `image.tag`                  | Docker 镜像的标签                                                | `20240208`                     |
| `image.pullPolicy`           | Docker 镜像的拉取策略                                            | `IfNotPresent`                 |
| `service.type`               | Kubernetes 服务的类型                                            | `ClusterIP`                    |
| `service.port`               | Kubernetes 服务的端口                                            | `8080`                         |
| `ingress.enabled`            | 启用/禁用 Kubernetes Ingress                                     | `false`                        |
| `ingress.className`          | Ingress 类名称                                                   | ``                             |
| `ingress.annotations`        | Kubernetes Ingress 注释                                          | `{}`                           |
| `ingress.hosts`              | Kubernetes Ingress 的主机列表                                    | `[]`                           |
| `ingress.tls`                | Kubernetes Ingress 的 TLS 配置                                   | `[]`                           |
| `resources.limits.cpu`       | Kubernetes 资源的 CPU 限制                                       | `1`                            |
| `resources.limits.memory`    | Kubernetes 资源的内存限制                                        | `2Gi`                          |
| `llm.baseUrl`               | 兼容 OpenAI API 的服务器的 URL                                   | `https://api.openai.com/v1`    |
| `llm.apiKey`                | 访问 OpenAI API 的 API 密钥                                      | ``                             |
| `llm.modelName`             | 使用的模型名称，例如 "gpt-3.5-turbo"、"gpt-4-turbo" 或 "gpt-4o"  | ``                             |
| `searchEngine.provider`      | 使用的搜索引擎提供商 (`BING`、`GOOGLE`、`SERPER` 或 `SEARCHAPI`) | ``                             |
| `searchEngine.apiKey`       | 访问搜索引擎提供商 API 的 API 密钥                               | ``                             |
| `searchEngine.google.cxKey` | Google 自定义搜索引擎密钥                                        | ``                             |
| `env`                        | 额外的环境变量数组                                               | `[]`                           |
