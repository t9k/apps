# Search with Lepton

[Search with Lepton](https://github.com/leptonai/search_with_lepton) 是一个开源的对话式搜索引擎（conversational search engine）。

特性：

* 内置对 LLM 的支持
* 内置对搜索引擎的支持
* 可定制的漂亮 UI 界面
* 可共享的、缓存的搜索结果

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始搜索。

<!-- 截图 -->

网页 UI 的使用方法简单直观，请用户自行尝试。

## 配置

### 说明

在 `llm` 字段下正确填写 OpenAI API Key 和调用的模型名称，在 `searchEngine` 字段下正确填写搜索引擎提供商以及相应的 API Key，必要时提供代理。

如要将兼容 OpenAI API 的本地推理服务（例如 vLLM 应用的推理服务）作为模型提供商，将 `llm.baseUrl` 字段的值设为该本地推理服务的服务端点，将 `llm.apiKey` 字段的值设为任意非空字符串，将 `llm.modelName` 字段的值设为模型的部署名称。

### 示例

模型提供商选用 vLLM 应用的推理服务，搜索引擎提供商选用 Serper：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/search-with-lepton"
  tag: "20240208"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 1
    memory: 2Gi

llm:
  baseUrl: "<VLLM_ENDPOINT>/v1"  # 安装 vLLM 应用，查看其应用信息以获取服务端点
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

### 字段

| 名称                        | 描述                                                             | 值                                              |
| --------------------------- | ---------------------------------------------------------------- | ----------------------------------------------- |
| `image.registry`            | Search with Lepton 镜像注册表                                    | `$(T9K_APP_IMAGE_REGISTRY)`                     |
| `image.repository`          | Search with Lepton 镜像仓库                                      | `$(T9K_APP_IMAGE_NAMESPACE)/search-with-lepton` |
| `image.tag`                 | Search with Lepton 镜像标签                                      | `20240208`                                      |
| `image.pullPolicy`          | Search with Lepton 镜像拉取策略                                  | `IfNotPresent`                                  |
| `resources.limits.cpu`      | Search with Lepton 容器能使用的 CPU 上限                         | `1`                                             |
| `resources.limits.memory`   | Search with Lepton 容器能使用的内存上限                          | `2Gi`                                           |
| `llm.baseUrl`               | 兼容 OpenAI API 的服务器的 URL                                   | `https://api.openai.com/v1`                     |
| `llm.apiKey`                | 访问 OpenAI API 的 API 密钥                                      | ``                                              |
| `llm.modelName`             | 使用的模型名称，例如 "gpt-3.5-turbo"、"gpt-4-turbo" 或 "gpt-4o"  | ``                                              |
| `searchEngine.provider`     | 使用的搜索引擎提供商 (`BING`、`GOOGLE`、`SERPER` 或 `SEARCHAPI`) | ``                                              |
| `searchEngine.apiKey`       | 访问搜索引擎提供商 API 的 API 密钥                               | ``                                              |
| `searchEngine.google.cxKey` | Google 自定义搜索引擎密钥                                        | ``                                              |
| `env`                       | 额外的环境变量数组                                               | `[]`                                            |
