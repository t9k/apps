# GPT Researcher

[GPT Researcher](https://github.com/assafelovic/gpt-researcher) 是一个智能体代理，专为各种任务的综合在线研究而设计。

代理可以生成详细、正式且客观的研究报告，并提供自定义选项，专注于相关资源、结构框架和经验报告。受最近发表的Plan-and-Solve 和RAG 论文的启发，GPT Researcher 解决了速度、确定性和可靠性等问题，通过并行化的代理运行，而不是同步操作，提供了更稳定的性能和更高的速度。

## 配置

### 示例

```yaml
replicaCount: 1

image:
  registry: docker.io
  repository: t9kpublic/gpt-researcher
  tag: 0.2.4
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
  api_key: "<YOUR_OPENAI_API_KEY>"

  openai:
    base_url: "https://api.openai.com/v1"
    fast_model: "gpt-3-turbo-16k"
    fast_token_limit: "2000"
    smart_model: "gpt-4-turbo"
    smart_token_limit: "4000"
    browse_chunk_max_length: "8192"
    summary_token_limit: "700"
    temperature: "0.55"

  azureopenai:
    endpoint: ""
    api_version: ""
    embedding_model: ""
    fast_model: "gpt-3-turbo-16k"
    fast_token_limit: "2000"
    smart_model: "gpt-4-turbo"
    smart_token_limit: "4000"
    browse_chunk_max_length: "8192"
    summary_token_limit: "700"
    temperature: "0.55"

  google:
    fast_model: "gpt-3-turbo-16k"
    fast_token_limit: "2000"
    smart_model: "gpt-4-turbo"
    smart_token_limit: "4000"
    browse_chunk_max_length: "8192"
    summary_token_limit: "700"
    temperature: "0.55"

retriever:
  provider: "googleSerp"
  api_key: "<YOUR_SERPER_API_KEY>"
  google:
    cx_key: ""

app:
  user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36
    (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0"
  max_search_results_per_query: "5"
  memory_backend: "local"
  total_words: "800"
  report_format: "APA"
  max_iterations: "3"
  agent_role: None
  scraper: "bs"
  max_subtopics: "3"

env:
  - name: HTTP_PROXY
    value: "<YOUR_HTTP_PROXY>"
  - name: HTTPS_PROXY
    value: "<YOUR_HTTPS_PROXY>"
```

### 参数

| 名称                                      | 描述                                                                                  | 值                                                                                                                              |
| ----------------------------------------- | ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `replicaCount`                            | 副本数量                                                                              | `1`                                                                                                                             |
| `image.registry`                          | Docker 镜像的存储库                                                                   | `docker.io`                                                                                                                     |
| `image.repository`                        | Docker 镜像的存储库名称                                                               | `t9kpublic/gpt-researcher`                                                                                                      |
| `image.tag`                               | Docker 镜像的标签                                                                     | `0.2.4`                                                                                                                         |
| `image.pullPolicy`                        | Docker 镜像的拉取策略                                                                 | `IfNotPresent`                                                                                                                  |
| `service.type`                            | Kubernetes 服务的类型                                                                 | `ClusterIP`                                                                                                                     |
| `service.port`                            | Kubernetes 服务的端口                                                                 | `8000`                                                                                                                          |
| `ingress.enabled`                         | 启用/禁用 Kubernetes Ingress                                                          | `false`                                                                                                                         |
| `ingress.className`                       | Ingress 类名称                                                                        | ``                                                                                                                              |
| `ingress.annotations`                     | Kubernetes Ingress 注释                                                               | `{}`                                                                                                                            |
| `ingress.hosts`                           | Kubernetes Ingress 的主机列表                                                         | `[]`                                                                                                                            |
| `ingress.tls`                             | Kubernetes Ingress 的 TLS 配置                                                        | `[]`                                                                                                                            |
| `resources.limits.cpu`                    | Kubernetes 资源的 CPU 限制                                                            | `1`                                                                                                                             |
| `resources.limits.memory`                 | Kubernetes 资源的内存限制                                                             | `2Gi`                                                                                                                           |
| `llm.provider`                            | 模型提供商 (`openai`、`azureopenai` 或 `google`)                                      | `openai`                                                                                                                        |
| `llm.api_key`                             | 访问语言模型提供商的 API 密钥                                                         | ``                                                                                                                              |
| `llm.openai.base_url`                     | 兼容 OpenAI API 的服务器的 URL                                                        | ``                                                                                                                              |
| `llm.openai.fast_model`                   | OpenAI API 的快速模型                                                                 | `gpt-3-turbo-16k`                                                                                                               |
| `llm.openai.fast_token_limit`             | OpenAI API 的快速模型的最大令牌数量                                                   | `2000`                                                                                                                          |
| `llm.openai.smart_model`                  | OpenAI API 的智能模型                                                                 | `gpt-4-turbo`                                                                                                                   |
| `llm.openai.smart_token_limit`            | OpenAI API 的智能模型的最大令牌数量                                                   | `4000`                                                                                                                          |
| `llm.openai.browse_chunk_max_length`      | OpenAI API 的浏览块最大长度                                                           | `8192`                                                                                                                          |
| `llm.openai.summary_token_limit`          | OpenAI API 的摘要最大令牌数量                                                         | `700`                                                                                                                           |
| `llm.openai.temperature`                  | OpenAI API 的温度参数                                                                 | `0.55`                                                                                                                          |
| `llm.azureopenai.endpoint`                | Azure-OpenAI API 的端点                                                               | ``                                                                                                                              |
| `llm.azureopenai.api_version`             | Azure-OpenAI API 的版本                                                               | ``                                                                                                                              |
| `llm.azureopenai.embedding_model`         | Azure-OpenAI API 的嵌入模型                                                           | ``                                                                                                                              |
| `llm.azureopenai.fast_model`              | Azure-OpenAI API 的快速模型                                                           | `gpt-3-turbo-16k`                                                                                                               |
| `llm.azureopenai.fast_token_limit`        | Azure-OpenAI API 的快速模型的最大令牌数量                                             | `2000`                                                                                                                          |
| `llm.azureopenai.smart_model`             | Azure-OpenAI API 的智能模型                                                           | `gpt-4-turbo`                                                                                                                   |
| `llm.azureopenai.smart_token_limit`       | Azure-OpenAI API 的智能模型的最大令牌数量                                             | `4000`                                                                                                                          |
| `llm.azureopenai.browse_chunk_max_length` | Azure-OpenAI API 的浏览块最大长度                                                     | `8192`                                                                                                                          |
| `llm.azureopenai.summary_token_limit`     | Azure-OpenAI API 的摘要最大令牌数量                                                   | `700`                                                                                                                           |
| `llm.azureopenai.temperature`             | Azure-OpenAI API 的温度参数                                                           | `0.55`                                                                                                                          |
| `llm.google.fast_model`                   | Google API 的快速模型                                                                 | `gpt-3-turbo-16k`                                                                                                               |
| `llm.google.fast_token_limit`             | Google API 的快速模型的最大令牌数量                                                   | `2000`                                                                                                                          |
| `llm.google.smart_model`                  | Google API 的智能模型                                                                 | `gpt-4-turbo`                                                                                                                   |
| `llm.google.smart_token_limit`            | Google API 的智能模型的最大令牌数量                                                   | `4000`                                                                                                                          |
| `llm.google.browse_chunk_max_length`      | Google API 的浏览块最大长度                                                           | `8192`                                                                                                                          |
| `llm.google.summary_token_limit`          | Google API 的摘要最大令牌数量                                                         | `700`                                                                                                                           |
| `llm.google.temperature`                  | Google API 的温度参数                                                                 | `0.55`                                                                                                                          |
| `retriever.provider`                      | 搜索引擎提供商 (`BingSearch`、`google`、`searx`、`serpapi`、`googleSerp` 或 `tavily`) | ``                                                                                                                              |
| `retriever.api_key`                       | 访问搜索引擎提供商 API 的 API 密钥                                                    | ``                                                                                                                              |
| `retriever.google.cx_key`                 | Google 搜索引擎提供商的 CX 密钥                                                       | ``                                                                                                                              |
| `app.user_agent`                          | 应用程序的用户代理字符串                                                              | `Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0` |
| `app.max_search_results_per_query`        | 应用程序每次查询的最大搜索结果数                                                      | `5`                                                                                                                             |
| `app.memory_backend`                      | 应用程序的内存后端                                                                    | `local`                                                                                                                         |
| `app.total_words`                         | 应用程序的总词数                                                                      | `800`                                                                                                                           |
| `app.report_format`                       | 应用程序的报告格式                                                                    | `APA`                                                                                                                           |
| `app.max_iterations`                      | 应用程序的最大迭代次数                                                                | `3`                                                                                                                             |
| `app.agent_role`                          | 应用程序的代理角色                                                                    | `None`                                                                                                                          |
| `app.scraper`                             | 应用程序的爬虫工具                                                                    | `bs`                                                                                                                            |
| `app.max_subtopics`                       | 应用程序的最大子主题数                                                                | `3`                                                                                                                             |
| `env`                                     | 额外的环境变量数组                                                                    | `[]`                                                                                                                            |
