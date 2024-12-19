# GPT Researcher

[GPT Researcher](https://github.com/assafelovic/gpt-researcher) 是一个智能体代理，专为各种任务的综合在线研究而设计。

代理可以生成详细、正式且客观的研究报告，并提供自定义选项，专注于相关资源、结构框架和经验报告。受最近发表的 Plan-and-Solve 和 RAG 论文的启发，GPT Researcher 解决了速度、确定性和可靠性等问题，通过并行化的代理运行，而不是同步操作，提供了更稳定的性能和更高的速度。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始“研究”。

![](https://s2.loli.net/2024/12/16/fDisxdH34WBmS6k.png)

网页 UI 的使用方法简单直观，请用户自行尝试。

## 配置

### 说明

在 `llm` 字段下正确填写模型提供商以及相应的 URL、API Key、模型名称等字段，在 `retriever` 字段下正确填写搜索引擎提供商以及相应的 API Key，必要时提供代理。

### 示例

模型提供商选用 OpenAI，搜索引擎提供商选用 DuckDuckGo，设置网络代理：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/gpt-researcher"
  tag: "v3.1.5"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 1
    memory: 2Gi

llm:
  provider: "openai"
  baseUrl: "https://api.openai.com/v1"
  apiKey: "<YOUR_OPENAI_API_KEY>"
  fastLlm: "openai:gpt-4o-mini"
  smartLlm: "openai:gpt-4o"
  strategicLlm: "openai:o1-preview"
  embedding: "openai:text-embedding-3-small"
  fastTokenLimit: "2000"
  smartTokenLimit: "4000"
  summaryTokenLimit: "700"
  temperature: "0.55"

retriever:
  provider: "duckduckgo"
  apiKey: ""

app:
  userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0"
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

模型提供商选用 Ollama（Ollama 应用，需要镜像标签 <0.5.0），搜索引擎提供商选用 Searx（SearXNG 应用），不设置网络代理：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/gpt-researcher"
  tag: "v3.1.5"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 1
    memory: 2Gi

llm:
  provider: "ollama"
  baseUrl: "http://<OLLAMA_ENDPOINT>"
  apiKey: ""
  fastLlm: "ollama:llama3.2"
  smartLlm: "ollama:llama3.3"
  strategicLlm: "ollama:llama3.3"
  embedding: "ollama:nomic-embed-text"
  fastTokenLimit: "2000"
  smartTokenLimit: "4000"
  summaryTokenLimit: "700"
  temperature: "0.55"

retriever:
  provider: "searx"
  apiKey: "<SEARXNG_ENDPOINT>"

app:
  userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0"
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

env: []
```

### 字段

| 名称                           | 描述                                             | 值                                                                                                                              |
| ------------------------------ | ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------- |
| `image.registry`               | GPT Researcher 镜像注册表                        | `$(T9K_APP_IMAGE_REGISTRY)`                                                                                                     |
| `image.repository`             | GPT Researcher 镜像仓库                          | `$(T9K_APP_IMAGE_NAMESPACE)/gpt-researcher`                                                                                     |
| `image.tag`                    | GPT Researcher 镜像标签                          | `v3.1.5`                                                                                                                        |
| `image.pullPolicy`             | GPT Researcher 镜像拉取策略                      | `IfNotPresent`                                                                                                                  |
| `resources.limits.cpu`         | GPT Researcher 容器能使用的 CPU 上限             | `1`                                                                                                                             |
| `resources.limits.memory`      | GPT Researcher 容器能使用的内存上限              | `2Gi`                                                                                                                           |
| `llm.provider`                 | 使用的模型提供商（`openai` 或 `ollama`）         | `""`                                                                                                                            |
| `llm.baseUrl`                  | 兼容 OpenAI API 的服务的 URL                     | `""`                                                                                                                            |
| `llm.apiKey`                   | 语言模型提供商的 API 密钥                        | `""`                                                                                                                            |
| `llm.fastLlm`                  | 用于快速操作（如摘要）的模型名称                 | `openai:gpt-4o-mini`                                                                                                            |
| `llm.smartLlm`                 | 用于智能操作（如生成研究报告和推理）的模型名称   | `openai:gpt-4o`                                                                                                                 |
| `llm.strategicLlm`             | 用于策略操作（如生成研究计划和策略）的模型名称   | `openai:o1-preview`                                                                                                             |
| `llm.embedding`                | 嵌入模型                                         | `openai:text-embedding-3-small`                                                                                                 |
| `llm.fastTokenLimit`           | 快速 LLM 响应的最大令牌限制                      | `2000`                                                                                                                          |
| `llm.smartTokenLimit`          | 智能 LLM 响应的最大令牌限制                      | `4000`                                                                                                                          |
| `llm.summaryTokenLimit`        | 生成摘要的最大令牌限制                           | `700`                                                                                                                           |
| `llm.temperature`              | LLM 响应的采样温度，通常在 0 到 1 之间           | `0.55`                                                                                                                          |
| `retriever.provider`           | 使用的搜索引擎提供商                             | `""`                                                                                                                            |
| `retriever.apiKey`             | 搜索引擎提供商的 API 密钥                        | `""`                                                                                                                            |
| `retriever.google.cxKey`       | Google 搜索引擎提供商的 CX 密钥                  | `""`                                                                                                                            |
| `app.userAgent`                | 用于网络爬取和网络请求的自定义 User-Agent 字符串 | `Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0` |
| `app.similarityThreshold`      | 判断两个文档是否足够相似以被视为冗余的阈值       | `0.38`                                                                                                                          |
| `app.browseChunkMaxLength`     | 网络源中浏览文本块的最大长度                     | `8192`                                                                                                                          |
| `app.maxSearchResultsPerQuery` | 每次查询的最大搜索结果数                         | `5`                                                                                                                             |
| `app.memoryBackend`            | 用于内存操作的后端                               | `local`                                                                                                                         |
| `app.totalWords`               | 文档生成或处理任务的总字数限制                   | `800`                                                                                                                           |
| `app.reportFormat`             | 报告生成的首选格式                               | `APA`                                                                                                                           |
| `app.maxIterations`            | 查询扩展或搜索优化等过程的最大迭代次数           | `3`                                                                                                                             |
| `app.agentRole`                | 代理的角色                                       | `None`                                                                                                                          |
| `app.scraper`                  | 用于收集信息的网络爬虫                           | `bs`                                                                                                                            |
| `app.maxSubtopics`             | 生成或考虑的最大子主题数                         | `3`                                                                                                                             |
| `env`                          | 额外的环境变量数组                               | `[]`                                                                                                                            |

<!-- | `docs.enabled`                 | 启用/禁用本地文档研究                            | `false`                                                                                                                         |
| `docs.volume.existingClaim`    | 要使用的现有 PVC 名称                            | `""`                                                                                                                            |
| `docs.volume.subPath`          | 要挂载为文档的 PVC 子目录                        | `""`                                                                                                                            | -->
