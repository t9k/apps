# Chat Nio

[Chat Nio](https://github.com/coaidev/coai) 是下一代的 AI 一站式解决方案，面向 B/C 端用户，全面支持多种主流 AI 模型，包括 OpenAI、Midjourney、Claude、讯飞星火、Stable Diffusion、DALL・E、ChatGLM、通义千问、腾讯混元、360 智脑、百川 AI、火山方舟、New Bing、Gemini、Moonshot 等。

平台提供丰富的功能，支持对话分享、自定义预设、云端同步以及模型市场，兼容弹性计费和订阅计划模式。同时，Chat Nio 还具备图片解析、联网搜索、模型缓存等功能，并配有直观美观的后台管理系统与数据统计仪表盘，帮助用户高效管理和监控 AI 使用情况。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始聊天。

![](https://s2.loli.net/2024/11/19/CETzmiyMtGSdbwV.png)

网页 UI 的使用方法请参阅 [Chat Nio 文档](https://www.coai.dev/docs/introduction)。

## 使用说明

* 管理员账号的用户名为 `root`，密码为 `chatnio123456`；使用管理员账号初次登录系统后，请务必修改密码。

## 配置

### 示例

默认配置：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/chatnio"
  tag: "20241109"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 1
    memory: 2Gi

persistence:
  enabled: true
  size: 1Gi
  storageClass: ""
  accessMode: ReadWriteMany
  existingClaim: ""

mysql:
  enabled: true
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/mysql"
    tag: 5.7.43
    pullPolicy: IfNotPresent
  auth:
    database: chatnio
    username: chatnio
    password: chatnio123456!
    rootPassword: root
  primary:
    resources:
      limits:
        cpu: 1
        memory: 2Gi
    persistence:
      enabled: true

redis:
  enabled: true
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/redis"
    tag: 7.4.1
    pullPolicy: IfNotPresent

  auth:
    enabled: false
  master:
    persistence:
      enabled: true
```

### 字段

| 名称                                    | 描述                          | 值                                   |
| --------------------------------------- | ----------------------------- | ------------------------------------ |
| `image.registry`                        | ChatNio 镜像注册表            | `$(T9K_APP_IMAGE_REGISTRY)`          |
| `image.repository`                      | ChatNio 镜像仓库              | `$(T9K_APP_IMAGE_NAMESPACE)/chatnio` |
| `image.tag`                             | ChatNio 镜像标签              | `20241109`                           |
| `image.pullPolicy`                      | ChatNio 镜像拉取策略          | `IfNotPresent`                       |
| `resources.limits.cpu`                  | ChatNio 容器能使用的 CPU 上限 | `1`                                  |
| `resources.limits.memory`               | ChatNio 容器能使用的内存上限  | `2Gi`                                |
| `persistence.enabled`                   | 是否启用 PVC 持久化存储       | `true`                               |
| `persistence.size`                      | PVC 的大小                    | `1Gi`                                |
| `persistence.storageClass`              | PVC 的存储类型                | `""`                                 |
| `persistence.accessMode`                | PVC 的访问模式                | `ReadWriteMany`                      |
| `persistence.existingClaim`             | 使用的现有 PVC 的名称         | `""`                                 |
| `mysql.enabled`                         | 是否安装 MySQL                | `true`                               |
| `mysql.image.registry`                  | MySQL 镜像注册表              | `$(T9K_APP_IMAGE_REGISTRY)`          |
| `mysql.image.repository`                | MySQL 镜像仓库                | `$(T9K_APP_IMAGE_NAMESPACE)/mysql`   |
| `mysql.image.tag`                       | MySQL 镜像标签                | `5.7.43`                             |
| `mysql.auth.database`                   | MySQL 数据库名称              | `chatnio`                            |
| `mysql.auth.username`                   | MySQL 用户名                  | `chatnio`                            |
| `mysql.auth.password`                   | MySQL 用户密码                | `chatnio123456!`                     |
| `mysql.auth.rootPassword`               | MySQL root 密码               | `root`                               |
| `mysql.primary.resources.limits.cpu`    | MySQL 容器能使用的 CPU 上限   | `1`                                  |
| `mysql.primary.resources.limits.memory` | MySQL 容器能使用的内存上限    | `2Gi`                                |
| `mysql.primary.persistence.enabled`     | 是否为 MySQL 启用持久化存储   | `true`                               |
| `redis.enabled`                         | 是否安装 Redis                | `true`                               |
| `redis.image.registry`                  | Redis 镜像注册表              | `$(T9K_APP_IMAGE_REGISTRY)`          |
| `redis.image.repository`                | Redis 镜像仓库                | `$(T9K_APP_IMAGE_NAMESPACE)/redis`   |
| `redis.image.tag`                       | Redis 镜像标签                | `7.4.1`                              |
| `redis.auth.enabled`                    | 是否启用 Redis 认证           | `false`                              |
| `redis.master.persistence.enabled`      | 是否为 Redis 启用持久化存储   | `true`                               |
