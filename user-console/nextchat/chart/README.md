# NextChat

[NextChat](https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web) 是一个设计精良的 ChatGPT 网页 UI，支持 ChatGPT、Claude、Gemini 和本地部署的兼容 OpenAI API 的推理服务。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始聊天。

<!-- OpenAI 聊天截图 -->

网页 UI 的使用方法请参阅[用户手册](https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web/blob/main/docs/user-manual-cn.md)和[常见问题](https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web/blob/main/docs/faq-cn.md)。

## 配置

### 说明

在 `llm` 字段下正确填写模型提供商以及相应的 API Key 和 URL，必要时提供代理。

如要将兼容 OpenAI API 的本地推理服务（例如 vLLM 应用的推理服务）作为模型提供商，将 `llm.provider` 字段的值设为 `openai`，将 `llm.apiKey` 字段的值设为任意非空字符串，将 `llm.openai.baseUrl` 字段的值设为该本地推理服务的服务端点。此外还需要在网页 UI 的设置中提供模型的部署名称并选择该名称。

![](https://s2.loli.net/2024/06/18/r6nc8sWwu2APReh.png)

### 示例

与 ChatGPT 聊天：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/chatgpt-next-web"
  tag: "v2.15.8"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 1
    memory: 2Gi

llm:
  provider: "openai"
  apiKey: "<YOUR_OPENAI_API_KEY>"
  openai:
    baseUrl: "https://api.openai.com"

env:
  - name: PROXY_URL
    value: "<YOUR_PROXY>"
```

与 vLLM 应用的推理服务聊天：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/chatgpt-next-web"
  tag: "v2.15.8"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 1
    memory: 2Gi

llm:
  provider: "openai"
  apiKey: "any"
  openai:
    baseUrl: "<VLLM_ENDPOINT>"  # 安装 vLLM 应用，查看其应用信息以获取服务端点

env: []
```

### 字段

| 名称                       | 描述                                                    | 值                                            |
| -------------------------- | ------------------------------------------------------- | --------------------------------------------- |
| `image.registry`           | NextChat 镜像注册表                                     | `$(T9K_APP_IMAGE_REGISTRY)`                   |
| `image.repository`         | NextChat 镜像仓库                                       | `$(T9K_APP_IMAGE_NAMESPACE)/chatgpt-next-web` |
| `image.tag`                | NextChat 镜像标签                                       | `v2.15.8`                                     |
| `image.pullPolicy`         | NextChat 镜像拉取策略                                   | `IfNotPresent`                                |
| `resources.limits.cpu`     | NextChat 容器能使用的 CPU 上限                          | `1`                                           |
| `resources.limits.memory`  | NextChat 容器能使用的内存上限                           | `2Gi`                                         |
| `llm.provider`             | 模型提供商 (`openai`、`azure`、`anthropic` 或 `google`) | `openai`                                      |
| `llm.apiKey`               | 访问语言模型提供商的 API 密钥                           | ``                                            |
| `llm.openai.baseUrl`       | 兼容 OpenAI API 的服务器的 URL                          | `https://api.openai.com`                      |
| `llm.azure.url`            | Azure 语言模型 API 的 URL                               | ``                                            |
| `llm.azure.apiVersion`     | Azure 语言模型 API 的版本                               | ``                                            |
| `llm.anthropic.url`        | Anthropic 语言模型 API 的 URL                           | ``                                            |
| `llm.anthropic.apiVersion` | Anthropic 语言模型 API 的版本                           | ``                                            |
| `llm.google.url`           | Google 语言模型 API 的 URL                              | ``                                            |
| `env`                      | 额外的环境变量数组                                      | `[]`                                          |
