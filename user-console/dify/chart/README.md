# Dify

[Dify](https://github.com/langgenius/dify) 是一个开源的 LLM 应用开发平台。其直观的界面结合了智能 AI 工作流、RAG 管道、代理能力、模型管理、可观测性功能等，使你能够快速从原型开发到生产部署。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始编排聊天助手、agent 以及工作流。

![](https://s2.loli.net/2024/11/27/bw3hgTLaIl1OsBC.png)

网页 UI 的使用方法请参阅 [Dify 文档](https://docs.dify.ai/zh-hans)。

## 配置

### 示例

默认配置（设置 Milvus 向量数据库）：

```yaml
global:
  host: "$(T9K_HOME_DOMAIN)"
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    tag: "1.3.1.post1"
    pullPolicy: IfNotPresent

  extraEnvs: []

  extraBackendEnvs:
  - name: SECRET_KEY
    value: "tensorstack"
  - name: MIGRATION_ENABLED
    value: "true"
  - name: UPLOAD_FILE_SIZE_LIMIT # 设置上传文件大小和批量限制
    value: "15"
  - name: UPLOAD_FILE_BATCH_LIMIT
    value: "5"
  - name: VECTOR_STORE # 设置向量数据库
    value: "milvus"
  - name: MILVUS_URI
    value: "http://app-milvus-6f97-24.demo.svc.cluster.local:19530"
  - name: MILVUS_USER
    value: "dify"
  - name: MILVUS_PASSWORD
    value: "123456"
  - name: MILVUS_ENABLE_HYBRID_SEARCH
    value: "true"

frontend:
  image:
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/dify-web"
  resources:
    limits:
      cpu: 500m
      memory: 2Gi

api:
  image:
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/dify-api"
  replicaCount: 1
  resources:
    limits:
      cpu: 2
      memory: 8Gi

worker:
  image:
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/dify-api"
  replicaCount: 1
  resources:
    limits:
      cpu: 4
      memory: 16Gi

sandbox:
  replicaCount: 1
  apiKey: "dify-sandbox"
  image:
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/dify-sandbox"
    tag: "0.2.12"
  config:
    python_requirements: ""
  resources:
    limits:
      cpu: 2
      memory: 8Gi

pluginDaemon:
  replicaCount: 1
  serverKey: "dify-plugin-daemon"
  difyInnerApiKey: "dify-inner-api-key"
  image:
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/dify-plugin-daemon"
    tag: "0.0.9-local"
  resources:
    limits:
      cpu: 2
      memory: 4Gi

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
    resourcesPreset: "xlarge"
    persistence:
      enabled: true
      size: 256Gi

minio:
  embedded: true
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/minio"
    tag: 2024.4.18-debian-12-r0
  auth:
    rootUser: minioadmin
    rootPassword: minioadmin
  resourcesPreset: "large"
  persistence:
    enabled: true
    size: 128Gi
```

### 字段

| 名称                                     | 描述                                        | 值                                                                                                                                                                                                                                              |
| ---------------------------------------- | ------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `global.host`                            | 全局主机                                    | `$(T9K_HOME_DOMAIN)`                                                                                                                                                                                                                            |
| `global.image.registry`                  | 全局镜像注册表                              | `$(T9K_APP_IMAGE_REGISTRY)`                                                                                                                                                                                                                     |
| `global.image.tag`                       | 全局镜像标签                                | `1.3.1.post1`                                                                                                                                                                                                                                   |
| `global.image.pullPolicy`                | 全局镜像拉取策略                            | `IfNotPresent`                                                                                                                                                                                                                                  |
| `global.extraEnvs`                       | 额外的环境变量数组，用于前端、API 和 Worker | `[]`                                                                                                                                                                                                                                            |
| `global.extraBackendEnvs`                | 额外的环境变量数组，用于 API 和 Worker      | `[{"name": "SECRET_KEY", "value": "tensorstack"}, {"name": "MIGRATION_ENABLED", "value": "true"}, {"name": "UPLOAD_FILE_SIZE_LIMIT", "value": "15"}, {"name": "UPLOAD_FILE_BATCH_LIMIT", "value": "5"}, {"name": "VECTOR_STORE", "value": ""}]` |
| `frontend.image.repository`              | 前端镜像仓库                                | `$(T9K_APP_IMAGE_NAMESPACE)/dify-web`                                                                                                                                                                                                           |
| `frontend.resources.limits.cpu`          | 前端 CPU 限制                               | `500m`                                                                                                                                                                                                                                          |
| `frontend.resources.limits.memory`       | 前端内存限制                                | `2Gi`                                                                                                                                                                                                                                           |
| `api.image.repository`                   | API 镜像仓库                                | `$(T9K_APP_IMAGE_NAMESPACE)/dify-api`                                                                                                                                                                                                           |
| `api.replicaCount`                       | API 副本数量                                | `1`                                                                                                                                                                                                                                             |
| `api.resources.limits.cpu`               | API CPU 限制                                | `2`                                                                                                                                                                                                                                             |
| `api.resources.limits.memory`            | API 内存限制                                | `8Gi`                                                                                                                                                                                                                                           |
| `worker.image.repository`                | Worker 镜像仓库                             | `$(T9K_APP_IMAGE_NAMESPACE)/dify-api`                                                                                                                                                                                                           |
| `worker.replicaCount`                    | Worker 副本数量                             | `1`                                                                                                                                                                                                                                             |
| `worker.resources.limits.cpu`            | Worker CPU 限制                             | `4`                                                                                                                                                                                                                                             |
| `worker.resources.limits.memory`         | Worker 内存限制                             | `16Gi`                                                                                                                                                                                                                                          |
| `sandbox.replicaCount`                   | Sandbox 副本数量                            | `1`                                                                                                                                                                                                                                             |
| `sandbox.apiKey`                         | Sandbox API 密钥                            | `dify-sandbox`                                                                                                                                                                                                                                  |
| `sandbox.image.repository`               | Sandbox 镜像仓库                            | `$(T9K_APP_IMAGE_NAMESPACE)/dify-sandbox`                                                                                                                                                                                                       |
| `sandbox.image.tag`                      | Sandbox 镜像标签                            | `0.2.12`                                                                                                                                                                                                                                        |
| `sandbox.config.python_requirements`     | Sandbox Python 依赖                         | `""`                                                                                                                                                                                                                                            |
| `sandbox.resources.limits.cpu`           | Sandbox CPU 限制                            | `2`                                                                                                                                                                                                                                             |
| `sandbox.resources.limits.memory`        | Sandbox 内存限制                            | `8Gi`                                                                                                                                                                                                                                           |
| `pluginDaemon.replicaCount`              | PluginDaemon 副本数量                       | `1`                                                                                                                                                                                                                                             |
| `pluginDaemon.serverKey`                 | PluginDaemon 服务器密钥                     | `dify-plugin-daemon`                                                                                                                                                                                                                            |
| `pluginDaemon.difyInnerApiKey`           | PluginDaemon Dify 内部 API 密钥             | `dify-inner-api-key`                                                                                                                                                                                                                            |
| `pluginDaemon.image.repository`          | PluginDaemon 镜像仓库                       | `$(T9K_APP_IMAGE_NAMESPACE)/dify-plugin-daemon`                                                                                                                                                                                                 |
| `pluginDaemon.image.tag`                 | PluginDaemon 镜像标签                       | `0.0.9-local`                                                                                                                                                                                                                                   |
| `pluginDaemon.resources.limits.cpu`      | PluginDaemon CPU 限制                       | `2`                                                                                                                                                                                                                                             |
| `pluginDaemon.resources.limits.memory`   | PluginDaemon 内存限制                       | `4Gi`                                                                                                                                                                                                                                           |
| `redis.embedded`                         | 是否启用内置 Redis                          | `true`                                                                                                                                                                                                                                          |
| `redis.image.registry`                   | Redis 镜像注册表                            | `$(T9K_APP_IMAGE_REGISTRY)`                                                                                                                                                                                                                     |
| `redis.image.repository`                 | Redis 镜像仓库                              | `$(T9K_APP_IMAGE_NAMESPACE)/redis`                                                                                                                                                                                                              |
| `redis.image.tag`                        | Redis 镜像标签                              | `7.4.1`                                                                                                                                                                                                                                         |
| `redis.auth.password`                    | Redis 认证密码                              | `REDIS_PASSWORD`                                                                                                                                                                                                                                |
| `redis.master.persistence.enabled`       | 是否启用 Redis 持久化                       | `false`                                                                                                                                                                                                                                         |
| `redis.master.persistence.size`          | Redis 持久卷大小                            | `8Gi`                                                                                                                                                                                                                                           |
| `postgresql.embedded`                    | 是否启用内置 PostgreSQL                     | `true`                                                                                                                                                                                                                                          |
| `postgresql.image.registry`              | PostgreSQL 镜像注册表                       | `$(T9K_APP_IMAGE_REGISTRY)`                                                                                                                                                                                                                     |
| `postgresql.image.repository`            | PostgreSQL 镜像仓库                         | `$(T9K_APP_IMAGE_NAMESPACE)/postgresql`                                                                                                                                                                                                         |
| `postgresql.image.tag`                   | PostgreSQL 镜像标签                         | `16.3.0-debian-12-r4`                                                                                                                                                                                                                           |
| `postgresql.auth.postgresPassword`       | PostgreSQL 管理员密码                       | `testpassword`                                                                                                                                                                                                                                  |
| `postgresql.auth.database`               | PostgreSQL 默认数据库名                     | `dify`                                                                                                                                                                                                                                          |
| `postgresql.primary.resourcesPreset`     | PostgreSQL 主资源预设                       | `xlarge`                                                                                                                                                                                                                                        |
| `postgresql.primary.persistence.enabled` | 是否启用 PostgreSQL 持久化                  | `true`                                                                                                                                                                                                                                          |
| `postgresql.primary.persistence.size`    | PostgreSQL 持久卷大小                       | `256Gi`                                                                                                                                                                                                                                         |
| `minio.embedded`                         | 是否启用内置 MinIO                          | `true`                                                                                                                                                                                                                                          |
| `minio.image.registry`                   | MinIO 镜像注册表                            | `$(T9K_APP_IMAGE_REGISTRY)`                                                                                                                                                                                                                     |
| `minio.image.repository`                 | MinIO 镜像仓库                              | `$(T9K_APP_IMAGE_NAMESPACE)/minio`                                                                                                                                                                                                              |
| `minio.image.tag`                        | MinIO 镜像标签                              | `2024.4.18-debian-12-r0`                                                                                                                                                                                                                        |
| `minio.auth.rootUser`                    | MinIO 根用户名                              | `minioadmin`                                                                                                                                                                                                                                    |
| `minio.auth.rootPassword`                | MinIO 根密码                                | `minioadmin`                                                                                                                                                                                                                                    |
| `minio.resourcesPreset`                  | MinIO 资源预设                              | `large`                                                                                                                                                                                                                                         |
| `minio.persistence.enabled`              | 是否启用 MinIO 持久化                       | `true`                                                                                                                                                                                                                                          |
| `minio.persistence.size`                 | MinIO 持久卷大小                            | `128Gi`                                                                                                                                                                                                                                         |
