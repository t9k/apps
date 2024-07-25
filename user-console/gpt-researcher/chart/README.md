# GPT Researcher

[GPT Researcher](https://github.com/assafelovic/gpt-researcher) 是一个智能体代理，专为各种任务的综合在线研究而设计。

代理可以生成详细、正式且客观的研究报告，并提供自定义选项，专注于相关资源、结构框架和经验报告。受最近发表的Plan-and-Solve 和RAG 论文的启发，GPT Researcher 解决了速度、确定性和可靠性等问题，通过并行化的代理运行，而不是同步操作，提供了更稳定的性能和更高的速度。

## 使用方法

部署当前应用，在 `llm` 字段下正确填写模型提供商以及相应的 API Key、URL、模型名称等参数，在 `retriever` 字段下正确填写搜索引擎提供商以及相应的 API Key，必要时提供代理。待实例就绪后，点击相应的链接进入 web UI，即可开始“研究”。

## 配置

### 示例

模型提供商选用 OpenAI，搜索引擎提供商选用 Serper：

```yaml
replicaCount: 1

image:
  registry: registry.cn-hangzhou.aliyuncs.com
  repository: t9k/gpt-researcher
  tag: 0.2.6
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 8000

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
  apiKey: "<YOUR_OPENAI_API_KEY>"

  openai:
    baseUrl: "https://api.openai.com/v1"
    fastModel: "gpt-3-turbo-16k"
    smartModel: "gpt-4-turbo"
    fastTokenLimit: "2000"
    smartTokenLimit: "4000"
    summaryTokenLimit: "700"
    temperature: "0.55"

retriever:
  provider: "googleSerp"
  apiKey: "<YOUR_SERPER_API_KEY>"
  google:
    cxKey: ""

app:
  userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,
    like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0"
  similarityThreshold: 0.38
  browseChunkMaxLength: 8192
  maxSearchResultsPerQuery: 5
  memoryBackend: local
  totalWords: 800
  reportFormat: APA
  maxIterations: 3
  agentRole: None
  scraper: "bs"
  maxSubtopics: 3

env:
  - name: HTTP_PROXY
    value: "<YOUR_HTTP_PROXY>"
  - name: HTTPS_PROXY
    value: "<YOUR_HTTPS_PROXY>"
```

### 参数

| 名称                              | 描述                                                                                  | 值                                                                                                                              |
| --------------------------------- | ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `replicaCount`                    | 副本数量                                                                              | `1`                                                                                                                             |
| `image.registry`                  | Docker 镜像的存储库                                                                   | `docker.io`                                                                                                                     |
| `image.repository`                | Docker 镜像的存储库名称                                                               | `t9k/gpt-researcher`                                                                                                      |
| `image.tag`                       | Docker 镜像的标签                                                                     | `0.2.6`                                                                                                                         |
| `image.pullPolicy`                | Docker 镜像的拉取策略                                                                 | `IfNotPresent`                                                                                                                  |
| `service.type`                    | Kubernetes 服务的类型                                                                 | `ClusterIP`                                                                                                                     |
| `service.port`                    | Kubernetes 服务的端口                                                                 | `8000`                                                                                                                          |
| `ingress.enabled`                 | 启用/禁用 Kubernetes Ingress                                                          | `false`                                                                                                                         |
| `ingress.className`               | Ingress 类名称                                                                        | ``                                                                                                                              |
| `ingress.annotations`             | Kubernetes Ingress 注释                                                               | `{}`                                                                                                                            |
| `ingress.hosts`                   | Kubernetes Ingress 的主机列表                                                         | `[]`                                                                                                                            |
| `ingress.tls`                     | Kubernetes Ingress 的 TLS 配置                                                        | `[]`                                                                                                                            |
| `resources.limits.cpu`            | Kubernetes 资源的 CPU 限制                                                            | `1`                                                                                                                             |
| `resources.limits.memory`         | Kubernetes 资源的内存限制                                                             | `2Gi`                                                                                                                           |
| `llm.provider`                    | 模型提供商 (`openai`、`azureopenai` 或 `google`)                                      | `openai`                                                                                                                        |
| `llm.apiKey`                      | 访问语言模型提供商的 API 密钥                                                         | ``                                                                                                                              |
| `llm.openai.baseUrl`              | 兼容 OpenAI API 的服务器的 URL                                                        | ``                                                                                                                              |
| `llm.openai.fastModel`            | OpenAI API 的快速模型                                                                 | `gpt-3-turbo-16k`                                                                                                               |
| `llm.openai.fastTokenLimit`       | OpenAI API 的快速模型的最大令牌数量                                                   | `2000`                                                                                                                          |
| `llm.openai.smartModel`           | OpenAI API 的智能模型                                                                 | `gpt-4-turbo`                                                                                                                   |
| `llm.openai.smartTokenLimit`      | OpenAI API 的智能模型的最大令牌数量                                                   | `4000`                                                                                                                          |
| `llm.openai.browseChunkMaxLength` | OpenAI API 的浏览块最大长度                                                           | `8192`                                                                                                                          |
| `llm.openai.summaryTokenLimit`    | OpenAI API 的摘要最大令牌数量                                                         | `700`                                                                                                                           |
| `llm.openai.temperature`          | OpenAI API 的温度参数                                                                 | `0.55`                                                                                                                          |
| `retriever.provider`              | 搜索引擎提供商 (`BingSearch`、`google`、`searx`、`serpapi`、`googleSerp` 或 `tavily`) | ``                                                                                                                              |
| `retriever.apiKey`                | 访问搜索引擎提供商 API 的 API 密钥                                                    | ``                                                                                                                              |
| `retriever.google.cxKey`          | Google 搜索引擎提供商的 CX 密钥                                                       | ``                                                                                                                              |
| `app.userAgent`                   | 应用程序的用户代理字符串                                                              | `Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0` |
| `app.maxSearchResultsPerQuery`    | 应用程序每次查询的最大搜索结果数                                                      | `5`                                                                                                                             |
| `app.memoryBackend`               | 应用程序的内存后端                                                                    | `local`                                                                                                                         |
| `app.totalWords`                  | 应用程序的总词数                                                                      | `800`                                                                                                                           |
| `app.reportFormat`                | 应用程序的报告格式                                                                    | `APA`                                                                                                                           |
| `app.maxIterations`               | 应用程序的最大迭代次数                                                                | `3`                                                                                                                             |
| `app.agentRole`                   | 应用程序的代理角色                                                                    | `None`                                                                                                                          |
| `app.scraper`                     | 应用程序的爬虫工具                                                                    | `bs`                                                                                                                            |
| `app.maxSubtopics`                | 应用程序的最大子主题数                                                                | `3`                                                                                                                             |
| `env`                             | 额外的环境变量数组                                                                    | `[]`                                                                                                                            |
