# GPT Researcher

[GPT Researcher](https://github.com/assafelovic/gpt-researcher) 是一个智能体代理，专为各种任务的综合在线研究而设计。

代理可以生成详细、正式且客观的研究报告，并提供自定义选项，专注于相关资源、结构框架和经验报告。受最近发表的Plan-and-Solve 和RAG 论文的启发，GPT Researcher 解决了速度、确定性和可靠性等问题，通过并行化的代理运行，而不是同步操作，提供了更稳定的性能和更高的速度。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始“研究”。

<!-- 截图 -->

网页 UI 的使用方法简单直观，请用户自行尝试。

## 配置

### 说明

在 `llm` 字段下正确填写模型提供商以及相应的 API Key、URL、模型名称等字段，在 `retriever` 字段下正确填写搜索引擎提供商以及相应的 API Key，必要时提供代理。

### 示例

模型提供商选用 OpenAI，搜索引擎提供商选用 Serper：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/gpt-researcher"
  tag: 0.2.6
  pullPolicy: IfNotPresent

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

### 字段

| 名称                           | 描述                                                                                   | 值                                                                                                                              |
| ------------------------------ | -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `image.registry`               | GPT Researcher 镜像注册表                                                              | `$(T9K_APP_IMAGE_REGISTRY)`                                                                                                     |
| `image.repository`             | GPT Researcher 镜像仓库                                                                | `$(T9K_APP_IMAGE_NAMESPACE)/gpt-researcher`                                                                                     |
| `image.tag`                    | GPT Researcher 镜像标签                                                                | `0.2.6`                                                                                                                         |
| `image.pullPolicy`             | GPT Researcher 镜像拉取策略                                                            | `IfNotPresent`                                                                                                                  |
| `resources.limits.cpu`         | GPT Researcher 容器能使用的 CPU 上限                                                   | `1`                                                                                                                             |
| `resources.limits.memory`      | GPT Researcher 容器能使用的内存上限                                                    | `2Gi`                                                                                                                           |
| `llm.provider`                 | 模型提供商 (`openai`、`azureopenai` 或 `google`)                                       | `openai`                                                                                                                        |
| `llm.apiKey`                   | 访问语言模型提供商的 API 密钥                                                          | ``                                                                                                                              |
| `llm.openai.baseUrl`           | 兼容 OpenAI API 的服务器的 URL                                                         | ``                                                                                                                              |
| `llm.openai.fastModel`         | OpenAI API 的快速模型                                                                  | `gpt-3-turbo-16k`                                                                                                               |
| `llm.openai.smartModel`        | OpenAI API 的智能模型                                                                  | `gpt-4-turbo`                                                                                                                   |
| `llm.openai.fastTokenLimit`    | OpenAI API 的快速模型的最大令牌数量                                                    | `2000`                                                                                                                          |
| `llm.openai.smartTokenLimit`   | OpenAI API 的智能模型的最大令牌数量                                                    | `4000`                                                                                                                          |
| `llm.openai.summaryTokenLimit` | OpenAI API 的摘要最大令牌数量                                                          | `700`                                                                                                                           |
| `llm.openai.temperature`       | OpenAI API 的温度参数                                                                  | `0.55`                                                                                                                          |
| `llm.ollama.baseUrl`           | 兼容 Ollama API 的服务的 URL                                                           | ``                                                                                                                              |
| `llm.ollama.fastModel`         | Ollama API 的快速模型                                                                  | `llama3`                                                                                                                        |
| `llm.ollama.smartModel`        | Ollama API 的智能模型                                                                  | `llama3`                                                                                                                        |
| `llm.ollama.embeddingModel`    | Ollama API 的嵌入模型                                                                  | `nomic-embed-text`                                                                                                              |
| `llm.ollama.fastTokenLimit`    | Ollama API 的快速模型的最大令牌数量                                                    | `2000`                                                                                                                          |
| `llm.ollama.smartTokenLimit`   | Ollama API 的智能模型的最大令牌数量                                                    | `4000`                                                                                                                          |
| `llm.ollama.summaryTokenLimit` | Ollama API 的摘要最大令牌数量                                                          | `700`                                                                                                                           |
| `llm.ollama.temperature`       | Ollama API 的温度参数                                                                  | `0.55`                                                                                                                          |
| `retriever.provider`           | 搜索引擎提供商（`BingSearch`、`google`、`searx`、`serpapi`、`googleSerp` 或 `tavily`） | ``                                                                                                                              |
| `retriever.apiKey`             | 访问搜索引擎提供商 API 的 API 密钥                                                     | ``                                                                                                                              |
| `retriever.google.cxKey`       | Google 搜索引擎提供商的 CX 密钥                                                        | ``                                                                                                                              |
| `app.userAgent`                | 用于网页爬取和网页请求的自定义 User-Agent 字符串                                       | `Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0` |
| `app.similarityThreshold`      | 用于确定两个文档是否足够相似以被视为冗余的阈值                                         | `0.38`                                                                                                                          |
| `app.browseChunkMaxLength`     | 浏览网页来源时文本块的最大长度                                                         | `8192`                                                                                                                          |
| `app.maxSearchResultsPerQuery` | 每次查询的最大搜索结果数                                                               | `5`                                                                                                                             |
| `app.memoryBackend`            | 用于内存操作的后端，例如临时数据的本地存储                                             | `local`                                                                                                                         |
| `app.totalWords`               | 文档生成或处理任务的总词数限制                                                         | `800`                                                                                                                           |
| `app.reportFormat`             | 报告生成的首选格式（`APA`、`MLA`、`CMS`、`Harvard style` 或 `IEEE`）                   | `APA`                                                                                                                           |
| `app.maxIterations`            | 查询扩展或搜索优化等过程的最大迭代次数                                                 | `3`                                                                                                                             |
| `app.agentRole`                | 代理的角色，这可能用于根据分配的角色定制代理的行为                                     | `None`                                                                                                                          |
| `app.scraper`                  | 用于收集信息的网页爬虫                                                                 | `bs`                                                                                                                            |
| `app.maxSubtopics`             | 生成或考虑的最大子主题数                                                               | `3`                                                                                                                             |
| `env`                          | 额外的环境变量数组                                                                     | `[]`                                                                                                                            |
