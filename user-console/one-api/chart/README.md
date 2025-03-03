# One API

[One API](https://github.com/songquanpeng/one-api) 是一个 OpenAI API 管理与分发系统，支持多个主流 LLM 服务提供商，包括 OpenAI、Azure、Anthropic Claude、Google Gemini、Mistral、字节跳动豆包、阿里通义千问、百度文心一言、智谱 ChatGLM、月之暗面 Kimi 以及腾讯混元等。它能够高效地管理和分发各大平台的 API 密钥，简化了多种 API 的接入与使用。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可管理 LLM 服务接口。

![](https://s2.loli.net/2024/11/14/xHFp4jAlfY6CIzy.png)

网页 UI 的使用方法请参阅[使用方法](https://github.com/songquanpeng/one-api?tab=readme-ov-file#%E4%BD%BF%E7%94%A8%E6%96%B9%E6%B3%95)和[常见问题](https://github.com/songquanpeng/one-api?tab=readme-ov-file#%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98)。

## 使用说明

* 初始账号的用户名为 `root`，密码为 `123456`；使用初始账号初次登录系统后，请务必修改密码。

## 配置

### 示例

默认配置：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/one-api"
  tag: "v0.6.10"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 1
    memory: 2Gi

persistence:
  enabled: true
  size: 500Mi
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
    database: oneapi
    rootPassword: "123456"

  primary:
    resources:
      limits:
        cpu: 1
        memory: 2Gi
    persistence:
      enabled: true
```

### 字段

| 名称                                    | 描述                             | 值                                   |
| --------------------------------------- | -------------------------------- | ------------------------------------ |
| `image.registry`                        | One API 镜像注册表               | `$(T9K_APP_IMAGE_REGISTRY)`          |
| `image.repository`                      | One API 镜像仓库                 | `$(T9K_APP_IMAGE_NAMESPACE)/one-api` |
| `image.tag`                             | One API 镜像标签                 | `v0.6.10`                            |
| `image.pullPolicy`                      | One API 镜像拉取策略             | `IfNotPresent`                       |
| `resources.limits.cpu`                  | One API 容器能使用的 CPU 上限    | `1`                                  |
| `resources.limits.memory`               | One API 容器能使用的内存上限     | `2Gi`                                |
| `persistence.enabled`                   | 是否启用 PVC 持久化存储          | `true`                               |
| `persistence.size`                      | PVC 的大小                       | `500Mi`                              |
| `persistence.storageClass`              | PVC 的存储类型                   | `""`                                 |
| `persistence.accessMode`                | PVC 的访问模式                   | `ReadWriteMany`                      |
| `persistence.existingClaim`             | 使用的现有 PVC 的名称            | `""`                                 |
| `mysql.enabled`                         | 是否安装 MySQL                   | `true`                               |
| `mysql.image.registry`                  | MySQL 镜像注册表                 | `$(T9K_APP_IMAGE_REGISTRY)`          |
| `mysql.image.repository`                | MySQL 镜像仓库                   | `$(T9K_APP_IMAGE_NAMESPACE)/mysql`   |
| `mysql.image.tag`                       | MySQL 镜像标签                   | `5.7.43`                             |
| `mysql.image.pullPolicy`                | MySQL 镜像拉取策略               | `IfNotPresent`                       |
| `mysql.auth.database`                   | MySQL 数据库名称                 | `oneapi`                             |
| `mysql.auth.rootPassword`               | MySQL root 密码                  | `123456`                             |
| `mysql.primary.resources.limits.cpu`    | MySQL 容器能使用的 CPU 上限      | `1`                                  |
| `mysql.primary.resources.limits.memory` | MySQL 容器能使用的内存上限       | `2Gi`                                |
| `mysql.primary.persistence.enabled`     | 是否为 MySQL 启用 PVC 持久化存储 | `true`                               |
