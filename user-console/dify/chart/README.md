# Dify

[Dify](https://github.com/langgenius/dify) 是一个开源的 LLM 应用开发平台。其直观的界面结合了智能 AI 工作流、RAG 管道、代理能力、模型管理、可观测性功能等，使你能够快速从原型开发到生产部署。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始编排聊天助手、agent 以及工作流。

![](https://s2.loli.net/2024/11/27/bw3hgTLaIl1OsBC.png)

网页 UI 的使用方法请参阅 [Dify 文档](https://docs.dify.ai/zh-hans)。

## 配置

### 示例

默认配置：

```yaml
global:
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    tag: "1.1.3"
    pullPolicy: IfNotPresent

  extraEnvs: []

  extraBackendEnvs:
  - name: SECRET_KEY
    value: "tensorstack"
  - name: MIGRATION_ENABLED
    value: "true"

frontend:
  image:
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/dify-web"

api:
  image:
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/dify-api"

worker:
  image:
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/dify-api"

sandbox:
  apiKey: "dify-sandbox"
  image:
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/dify-sandbox"
    tag: "0.2.10"
  config:
    python_requirements: ""

pluginDaemon:
  serverKey: "dify-plugin-daemon"
  difyInnerApiKey: "dify-inner-api-key"
  image:
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/dify-plugin-daemon"
    tag: "0.0.6-local"

redis:
  embedded: true
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/redis"
    tag: 7.4.1
  auth:
    password: "REDIS_PASSWORD"
  master:
    persistence:
      enabled: false
      size: 8Gi

postgresql:
  embedded: true
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/postgresql"
    tag: 16.3.0-debian-12-r4
  auth:
    postgresPassword: "testpassword"
    database: "dify"
  primary:
    persistence:
      enabled: false

minio:
  embedded: true
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/minio"
    tag: 2024.4.18-debian-12-r0
  auth:
    rootUser: minioadmin
    rootPassword: minioadmin
  defaultBuckets: "dify"
  persistence:
    enabled: false
```

### 字段

| 名称                                      | 描述                                        | 值                                                                                                 |
| ----------------------------------------- | ------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| `global.image.registry`                   | 全局镜像注册表                              | `$(T9K_APP_IMAGE_REGISTRY)`                                                                        |
| `global.image.tag`                        | 全局镜像标签                                | `1.1.3`                                                                                            |
| `global.image.pullPolicy`                 | 全局镜像拉取策略                            | `IfNotPresent`                                                                                     |
| `global.extraEnvs`                        | 额外的环境变量数组，用于前端、API 和 Worker | `[]`                                                                                               |
| `global.extraBackendEnvs`                 | 额外的环境变量数组，用于 API 和 Worker      | `[{"name": "SECRET_KEY", "value": "tensorstack"}, {"name": "MIGRATION_ENABLED", "value": "true"}]` |
| `frontend.image.repository`               | 前端镜像仓库                                | `$(T9K_APP_IMAGE_NAMESPACE)/dify-web`                                                              |
| `api.image.repository`                    | API 镜像仓库                                | `$(T9K_APP_IMAGE_NAMESPACE)/dify-api`                                                              |
| `worker.image.repository`                 | Worker 镜像仓库                             | `$(T9K_APP_IMAGE_NAMESPACE)/dify-api`                                                              |
| `sandbox.apiKey`                          | Sandbox API 密钥                            | `dify-sandbox`                                                                                     |
| `sandbox.image.repository`                | Sandbox 镜像仓库                            | `$(T9K_APP_IMAGE_NAMESPACE)/dify-sandbox`                                                          |
| `sandbox.image.tag`                       | Sandbox 镜像标签                            | `0.2.10`                                                                                           |
| `sandbox.config.python_requirements`      | Sandbox Python 依赖                         | `""`                                                                                               |
| `pluginDaemon.serverKey`                  | PluginDaemon 服务器密钥                     | `dify-plugin-daemon`                                                                               |
| `pluginDaemon.difyInnerApiKey`            | PluginDaemon Dify 内部 API 密钥             | `dify-inner-api-key`                                                                               |
| `pluginDaemon.image.repository`           | PluginDaemon 镜像仓库                       | `$(T9K_APP_IMAGE_NAMESPACE)/dify-plugin-daemon`                                                    |
| `pluginDaemon.image.tag`                  | PluginDaemon 镜像标签                       | `0.0.6-local`                                                                                      |
| `pluginDaemon.config.python_requirements` | PluginDaemon Python 依赖                    | `""`                                                                                               |
| `redis.embedded`                          | 是否启用内置 Redis                          | `true`                                                                                             |
| `redis.image.registry`                    | Redis 镜像注册表                            | `$(T9K_APP_IMAGE_REGISTRY)`                                                                        |
| `redis.image.repository`                  | Redis 镜像仓库                              | `$(T9K_APP_IMAGE_NAMESPACE)/redis`                                                                 |
| `redis.image.tag`                         | Redis 镜像标签                              | `7.4.1`                                                                                            |
| `redis.auth.password`                     | Redis 认证密码                              | `REDIS_PASSWORD`                                                                                   |
| `redis.master.persistence.enabled`        | 是否启用 Redis 持久化                       | `false`                                                                                            |
| `redis.master.persistence.size`           | Redis 持久卷大小                            | `8Gi`                                                                                              |
| `postgresql.embedded`                     | 是否启用内置 PostgreSQL                     | `true`                                                                                             |
| `postgresql.image.registry`               | PostgreSQL 镜像注册表                       | `$(T9K_APP_IMAGE_REGISTRY)`                                                                        |
| `postgresql.image.repository`             | PostgreSQL 镜像仓库                         | `$(T9K_APP_IMAGE_NAMESPACE)/postgresql`                                                            |
| `postgresql.image.tag`                    | PostgreSQL 镜像标签                         | `16.3.0-debian-12-r4`                                                                              |
| `postgresql.auth.postgresPassword`        | PostgreSQL 管理员密码                       | `testpassword`                                                                                     |
| `postgresql.auth.database`                | PostgreSQL 默认数据库名                     | `dify`                                                                                             |
| `postgresql.primary.persistence.enabled`  | 是否启用 PostgreSQL 持久化                  | `false`                                                                                            |
| `minio.embedded`                          | 是否启用内置 MinIO                          | `true`                                                                                             |
| `minio.image.registry`                    | MinIO 镜像注册表                            | `$(T9K_APP_IMAGE_REGISTRY)`                                                                        |
| `minio.image.repository`                  | MinIO 镜像仓库                              | `$(T9K_APP_IMAGE_NAMESPACE)/minio`                                                                 |
| `minio.image.tag`                         | MinIO 镜像标签                              | `2024.4.18-debian-12-r0`                                                                           |
| `minio.auth.rootUser`                     | MinIO 根用户名                              | `minioadmin`                                                                                       |
| `minio.auth.rootPassword`                 | MinIO 根密码                                | `minioadmin`                                                                                       |
| `minio.persistence.enabled`               | 是否启用 MinIO 持久化                       | `false`                                                                                            |
