# DB-GPT

DB-GPT 是一个开源的 AI 原生数据应用开发框架，具有 AWEL（Agentic Workflow Expression Language，代理工作流表达语言）和代理功能。

DB-GPT 的目的是通过多项技术能力的开发，如多模型管理（SMMF）、Text2SQL 效果优化、RAG 框架和优化、多代理框架协作、AWEL 等，来构建大模型领域的基础设施，使得基于数据的大模型应用更加简便和高效。

在数据 3.0 时代，基于模型和数据库，企业和开发者可以用更少的代码构建定制化的应用。

特性：

* **私域问答、数据处理和 RAG**：支持通过内置的多文件格式上传和基于插件的网页抓取等方式，定制化构建知识库。实现大规模结构化和非结构化数据的统一向量存储与检索。

* **多数据源和 GBI（Generative Business Intelligence，生成型商业智能）**：支持自然语言与多种数据源（如 Excel、数据库、数据仓库等）之间的交互，也支持分析报表功能。

* **SMMF（Service-oriented Multi-model Management Framework，面向服务的多模型管理框架）**：支持广泛的模型，包括多种开源模型和 API 代理，例如 LLaMA/LLaMA2、百川、ChatGLM、ERNIE Bot、Qwen、Spark 等。

* **自动化微调**：支持 Text2SQL 微调。针对 LLM 和 Text2SQL 领域，提供一个轻量级的自动化微调框架，支持 LoRA/QLoRA/P-tuning 等方法，使 Text2SQL 微调如同流水线操作般简便。

* **数据驱动的多代理与插件**：支持通过自定义插件执行任务，原生支持 Auto-GPT 插件模型。代理协议遵循 Agent Protocol 标准。

* **隐私与安全**：支持数据隐私保护。通过大语言模型私有化和代理去标识化等技术，确保数据的隐私和安全。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开发和使用 AI 原生数据应用。

![](https://s2.loli.net/2024/11/21/Oak16QRi5JqelNo.png)

网页 UI 的使用方法请参阅 [V0.6.0 使用手册](https://www.yuque.com/eosphoros/dbgpt-docs/fho86kk4e9y4rkpd)。

## 配置

### 示例

使用 OpenAI API 的 gpt-4o-mini 作为聊天模型，text-embedding-3-large 作为文本嵌入模型，设置网络代理：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/dbgpt-allinone"
  tag: "v0.6.2"
  pullPolicy: IfNotPresent

dotenv:
  enabled: true
  data: |-
    LLM_MODEL=proxyllm
    PROXY_SERVER_URL=https://api.openai.com/v1/chat/completions
    PROXY_API_KEY=<YOUR_OPENAI_API_KEY>
    PROXYLLM_BACKEND=gpt-4o-mini

    EMBEDDING_MODEL=proxy_openai
    proxy_openai_proxy_server_url=https://api.openai.com/v1
    proxy_openai_proxy_api_key=<YOUR_OPENAI_API_KEY>
    proxy_openai_proxy_backend=text-embedding-3-large

    LOCAL_DB_HOST=127.0.0.1
    LOCAL_DB_PASSWORD=aa123456
    MYSQL_ROOT_PASSWORD=aa123456
    ALLOWLISTED_PLUGINS=db_dashboard
    LANGUAGE=zh

resources:
  limits:
    cpu: 4
    memory: 8Gi

persistence:
  enabled: true
  size: 20Gi
  storageClass: ""
  accessMode: ReadWriteMany

env:
  - name: HTTP_PROXY
    value: "<YOUR_HTTP_PROXY>"
  - name: HTTPS_PROXY
    value: "<YOUR_HTTPS_PROXY>"
```

使用 vLLM 应用部署的 qwen（Qwen2.5-7B-Instruct）作为聊天模型，Ollama 应用部署的 all-minilm 作为文本嵌入模型：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/dbgpt-allinone"
  tag: "v0.6.2"
  pullPolicy: IfNotPresent

dotenv:
  enabled: true
  data: |-
    LLM_MODEL=proxyllm
    PROXY_SERVER_URL=<VLLM_ENDPOINT>/v1/chat/completions
    PROXY_API_KEY=none
    PROXYLLM_BACKEND=qwen

    EMBEDDING_MODEL=proxy_http_openapi
    proxy_http_openapi_proxy_server_url=http://<OLLAMA_ENDPOINT>/v1/embeddings
    proxy_http_openapi_proxy_api_key=none
    proxy_http_openapi_proxy_backend=all-minilm

    LOCAL_DB_HOST=127.0.0.1
    LOCAL_DB_PASSWORD=aa123456
    MYSQL_ROOT_PASSWORD=aa123456
    ALLOWLISTED_PLUGINS=db_dashboard
    LANGUAGE=zh

resources:
  limits:
    cpu: 4
    memory: 8Gi

persistence:
  enabled: true
  size: 20Gi
  storageClass: ""
  accessMode: ReadWriteMany

env: []
```

### 字段

| 名称                       | 描述                         | 值                                          |
| -------------------------- | ---------------------------- | ------------------------------------------- |
| `image.registry`           | DB-GPT 镜像注册表            | `$(T9K_APP_IMAGE_REGISTRY)`                 |
| `image.repository`         | DB-GPT 镜像仓库              | `$(T9K_APP_IMAGE_NAMESPACE)/dbgpt-allinone` |
| `image.tag`                | DB-GPT 镜像标签              | `v0.6.2`                                    |
| `image.pullPolicy`         | DB-GPT 镜像拉取策略          | `IfNotPresent`                              |
| `dotenv.enabled`           | 是否启用环境变量配置         | `true`                                      |
| `dotenv.data`              | 环境变量配置                 |                                             |
| `resources.limits.cpu`     | DB-GPT 容器能使用的 CPU 上限 | `4`                                         |
| `resources.limits.memory`  | DB-GPT 容器能使用的内存上限  | `8Gi`                                       |
| `persistence.enabled`      | 是否启用 PVC 持久化存储      | `true`                                      |
| `persistence.size`         | PVC 的大小                   | `20Gi`                                      |
| `persistence.storageClass` | PVC 的存储类型               | `""`                                        |
| `persistence.accessMode`   | PVC 的访问模式               | `ReadWriteMany`                             |
| `env`                      | 额外的环境变量数组           | `[]`                                        |
