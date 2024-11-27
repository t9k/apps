# FastGPT

[FastGPT](https://github.com/labring/FastGPT) 是一个基于 LLM 的知识平台，提供了一整套开箱即用的功能，如数据处理、RAG 检索和可视化 AI 工作流编排，使您能够轻松开发和部署复杂的问答系统，而无需大量的设置或配置。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始聊天、创建 LLM 应用以及编排工作流。

![](https://s2.loli.net/2024/11/18/ypD6eV1q2nUdGzK.png)

网页 UI 的使用方法请参阅[功能介绍](https://doc.tryfastgpt.ai/docs/guide/)。

## 配置

### 说明

将 `app.openAiBaseUrl` 字段的值设为 OpenAI API 或与之兼容的服务（推荐使用 One API）的端点，将 `app.chatApiKey` 字段的值设为相应的 API Key 或 token。然后在 `app.config.llmModels` 字段下添加一项并正确填写 LLM 的配置以注册一个 LLM，在 `app.config.vectorModels` 字段下添加一项并正确填写向量模型（文本嵌入模型）的配置以注册一个向量模型。如有需要，还可以继续注册重排序模型、语音模型和语音识别模型。

<!-- 上下文长度 -->

<!-- 工具使用，函数调用 -->

### 示例

使用 OpenAI API，注册一个 LLM gpt-3.5-turbo，注册一个向量模型（文本嵌入模型）text-embedding-3-large：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/fastgpt"
  tag: "v4.8.12"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 1
    memory: 2Gi

app:
  defaultRootPassword: "123456"
  openAiBaseUrl: "https://api.openai.com/v1"
  chatApiKey: "<YOUR_OPENAI_API_KEY>"
  dbMaxLink: "30"
  tokenKey: "any"
  rootKey: "root_key"
  fileTokenKey: "filetoken"
  logLevel: "debug"
  storeLogLevel: "warn"

  config:

    systemEnv:
      openapiPrefix: "fastgpt"
      vectorMaxProcess: 15
      qaMaxProcess: 15
      pgHNSWEfSearch: 100

    llmModels:
      - model: "gpt-3.5-turbo"
        name: "gpt-3.5-turbo"
        maxContext: 16000
        maxResponse: 4000
        quoteMaxToken: 13000
        maxTemperature: 1.2
        charsPointsPrice: 0
        censor: false
        vision: false
        datasetProcess: true
        usedInClassify: true
        usedInExtractFields: true
        usedInToolCall: true
        usedInQueryExtension: true
        toolChoice: true
        functionCall: false
        customCQPrompt: ""
        customExtractPrompt: ""
        defaultSystemChatPrompt: ""
        defaultConfig: {}

    vectorModels:
      - model: "text-embedding-3-large"
        name: "text-embedding-3-large"
        charsPointsPrice: 0
        defaultToken: 512
        maxToken: 3000
        weight: 100
        dbConfig: {}
        queryConfig: {}
        defaultConfig:
          dimensions: 1024

sandbox:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/fastgpt-sandbox"
    tag: "v4.8.12"
    pullPolicy: IfNotPresent
  resources:
    limits:
      cpu: 2
      memory: 4Gi

mongodb:
  enabled: true
  architecture: replicaset
  replicaCount: 1
  replicaSetName: rs0
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/mongodb"
    tag: 8.0.0-debian-12-r1
  auth:
    rootUser: root
    rootPassword: "123456"
  persistence:
    enabled: true
    storageClass: ""
    size: 2Gi 

postgresql:
  enabled: true
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/linuxsuren-pgvector"
    tag: v0.0.1
  global:
    postgresql:
      auth:
        postgresPassword: postgres
        database: postgres
```

使用 One API，注册一个 LLM qwen2.5:7b，注册一个向量模型（文本嵌入模型）nomic-embed-text：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/fastgpt"
  tag: "v4.8.12"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 1
    memory: 2Gi

app:
  defaultRootPassword: "123456"
  openAiBaseUrl: "<ENDPOINT>/v1"  # 安装 One API 应用，查看其应用信息以获取服务端点
  chatApiKey: "<YOUR_ONE_API_TOKEN>"  # 进入 One API 应用，创建令牌
  dbMaxLink: "30"
  tokenKey: "any"
  rootKey: "root_key"
  fileTokenKey: "filetoken"
  logLevel: "debug"
  storeLogLevel: "warn"

  config:

    systemEnv:
      openapiPrefix: "fastgpt"
      vectorMaxProcess: 15
      qaMaxProcess: 15
      pgHNSWEfSearch: 100

    llmModels:
      - model: "qwen2.5:7b"
        name: "qwen2.5:7b"
        maxContext: 32768
        maxResponse: 4000
        quoteMaxToken: 13000
        maxTemperature: 1.2
        charsPointsPrice: 0
        censor: false
        vision: false
        datasetProcess: true
        usedInClassify: true
        usedInExtractFields: true
        usedInToolCall: true
        usedInQueryExtension: true
        toolChoice: true
        functionCall: false
        customCQPrompt: ""
        customExtractPrompt: ""
        defaultSystemChatPrompt: ""
        defaultConfig: {}

    vectorModels:
      - model: "nomic-embed-text"
        name: "nomic-embed-text"
        charsPointsPrice: 0
        defaultToken: 512
        maxToken: 3000
        weight: 100
        dbConfig: {}
        queryConfig: {}
        defaultConfig:
          dimensions: 1024

sandbox:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/fastgpt-sandbox"
    tag: "v4.8.12"
    pullPolicy: IfNotPresent
  resources:
    limits:
      cpu: 2
      memory: 4Gi

mongodb:
  enabled: true
  architecture: replicaset
  replicaCount: 1
  replicaSetName: rs0
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/mongodb"
    tag: 8.0.0-debian-12-r1
  auth:
    rootUser: root
    rootPassword: "123456"
  persistence:
    enabled: true
    storageClass: ""
    size: 2Gi 

postgresql:
  enabled: true
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/linuxsuren-pgvector"
    tag: v0.0.1
  global:
    postgresql:
      auth:
        postgresPassword: postgres
        database: postgres
```

### 字段

| 名称                                                 | 描述                          | 值                                               |
| ---------------------------------------------------- | ----------------------------- | ------------------------------------------------ |
| `image.registry`                                     | FastGPT 镜像注册表            | `$(T9K_APP_IMAGE_REGISTRY)`                      |
| `image.repository`                                   | FastGPT 镜像仓库              | `$(T9K_APP_IMAGE_NAMESPACE)/fastgpt`             |
| `image.tag`                                          | FastGPT 镜像标签              | `v4.8.12`                                        |
| `image.pullPolicy`                                   | FastGPT 镜像拉取策略          | `IfNotPresent`                                   |
| `resources.limits.cpu`                               | FastGPT 容器能使用的 CPU 上限 | `1`                                              |
| `resources.limits.memory`                            | FastGPT 容器能使用的内存上限  | `2Gi`                                            |
| `app.defaultRootPassword`                            | FastGPT 默认管理员密码        | `123456`                                         |
| `app.openAiBaseUrl`                                  | OpenAI API 的基础 URL         | `http://app-one-api-xxx:3000/v1`                 |
| `app.chatApiKey`                                     | 聊天服务的 API 密钥           | `sk-xxx`                                         |
| `app.dbMaxLink`                                      | 最大数据库连接数              | `30`                                             |
| `app.tokenKey`                                       | Token 加密密钥                | `any`                                            |
| `app.rootKey`                                        | Root 访问密钥                 | `root_key`                                       |
| `app.fileTokenKey`                                   | 文件 token 密钥               | `filetoken`                                      |
| `app.logLevel`                                       | 应用日志级别                  | `info`                                           |
| `app.storeLogLevel`                                  | 存储日志级别                  | `warn`                                           |
| `app.config`                                         | 存储日志级别                  | `warn`                                           |
| `sandbox.image.registry`                             | Sandbox 镜像注册表            | `$(T9K_APP_IMAGE_REGISTRY)`                      |
| `sandbox.image.repository`                           | Sandbox 镜像仓库              | `$(T9K_APP_IMAGE_NAMESPACE)/fastgpt-sandbox`     |
| `sandbox.image.tag`                                  | Sandbox 镜像标签              | `v4.8.12`                                        |
| `sandbox.image.pullPolicy`                           | Sandbox 镜像拉取策略          | `IfNotPresent`                                   |
| `sandbox.resources.limits.cpu`                       | Sandbox 容器能使用的 CPU 上限 | `2`                                              |
| `sandbox.resources.limits.memory`                    | Sandbox 容器能使用的内存上限  | `4Gi`                                            |
| `mongodb.enabled`                                    | 是否安装 MongoDB              | `true`                                           |
| `mongodb.image.registry`                             | MongoDB 镜像注册表            | `$(T9K_APP_IMAGE_REGISTRY)`                      |
| `mongodb.image.repository`                           | MongoDB 镜像仓库              | `$(T9K_APP_IMAGE_NAMESPACE)/mongodb`             |
| `mongodb.image.tag`                                  | MongoDB 镜像标签              | `8.0.0-debian-12-r1`                             |
| `mongodb.architecture`                               | MongoDB 部署架构              | `replicaset`                                     |
| `mongodb.replicaCount`                               | MongoDB 副本数量              | `1`                                              |
| `mongodb.auth.rootUser`                              | MongoDB root 用户名           | `root`                                           |
| `mongodb.auth.rootPassword`                          | MongoDB root 密码             | `123456`                                         |
| `mongodb.replicaSetName`                             | MongoDB 副本集名称            | `rs0`                                            |
| `mongodb.persistence.enabled`                        | 是否为 MongoDB 启用持久化存储 | `true`                                           |
| `mongodb.persistence.storageClass`                   | MongoDB PVC 的存储类型        | `""`                                             |
| `mongodb.persistence.size`                           | MongoDB PVC 的大小            | `2Gi`                                            |
| `postgresql.enabled`                                 | 是否安装 PostgreSQL           | `true`                                           |
| `postgresql.image.registry`                          | PostgreSQL 镜像注册表         | `$(T9K_APP_IMAGE_REGISTRY)`                      |
| `postgresql.image.repository`                        | PostgreSQL 镜像仓库           | `$(T9K_APP_IMAGE_NAMESPACE)/linuxsuren-pgvector` |
| `postgresql.image.tag`                               | PostgreSQL 镜像标签           | `v0.0.1`                                         |
| `postgresql.global.postgresql.auth.postgresPassword` | PostgreSQL 管理员密码         | `postgres`                                       |
| `postgresql.global.postgresql.auth.database`         | 默认 PostgreSQL 数据库名称    | `postgres`                                       |
