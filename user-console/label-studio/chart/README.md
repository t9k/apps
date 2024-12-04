# Label Studio

[Label Studio](https://github.com/HumanSignal/label-studio) 是一个开源数据标注工具。它可以让你通过简单直观的用户界面标注音频、文本、图像、视频和时间序列等数据类型，并导出为各种格式。它可以用于准备原始数据或改进现有的训练数据，以获得更准确的机器学习模型。

## 使用方法

待应用就绪后，点击右侧的 <svg width="1em" height="1em" class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg> 进入网页 UI，即可开始标注数据。

![](https://s2.loli.net/2024/12/03/njmo6JwVv2PRFCU.png)

网页 UI 的使用方法请参阅 [Label Studio Documentation](https://labelstud.io/guide/)。

## 配置

### 示例

默认配置：

```yaml
global:
  host: "$(T9K_HOME_DOMAIN)"
  csrfTrustedOrigins: "$(T9K_HOME_DOMAIN)"

  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/label-studio"
    tag: "1.14.0.post0"
    pullPolicy: IfNotPresent

  persistence:
    enabled: true
    config:
      volume:
        size: 10Gi
        storageClass: ""
        accessModes:
          - ReadWriteOnce
        existingClaim: ""

app:
  resources:
    limits:
      cpu: 1
      memory: 2Gi

postgresql:
  enabled: true
  image:
    registry: "$(T9K_APP_IMAGE_REGISTRY)"
    repository: "$(T9K_APP_IMAGE_NAMESPACE)/postgresql"
    tag: 13.15.0
  auth:
    username: "labelstudio"
    password: "labelstudio"
    database: "labelstudio"
```

### 字段

| 名称                                             | 描述                               | 值                                          |
| ------------------------------------------------ | ---------------------------------- | ------------------------------------------- |
| `global.host`                                    | Label Studio 主机域名              | `"$(T9K_HOME_DOMAIN)"`                      |
| `global.csrfTrustedOrigins`                      | Label Studio CSRF 信任源           | `"$(T9K_HOME_DOMAIN)"`                      |
| `global.image.registry`                          | Label Studio 镜像注册表            | `"$(T9K_APP_IMAGE_REGISTRY)"`               |
| `global.image.repository`                        | Label Studio 镜像仓库              | `"$(T9K_APP_IMAGE_NAMESPACE)/label-studio"` |
| `global.image.tag`                               | Label Studio 镜像标签              | `"1.14.0.post0"`                            |
| `global.image.pullPolicy`                        | Label Studio 镜像拉取策略          | `IfNotPresent`                              |
| `global.persistence.enabled`                     | 是否启用 PVC 持久化                | `true`                                      |
| `global.persistence.config.volume.size`          | PVC 的大小                         | `10Gi`                                      |
| `global.persistence.config.volume.storageClass`  | PVC 的存储类型                     | `""`                                        |
| `global.persistence.config.volume.accessModes`   | PVC 的访问模式                     | `["ReadWriteOnce"]`                         |
| `global.persistence.config.volume.existingClaim` | 使用的现有 PVC 的名称              | `""`                                        |
| `app.resources.limits.cpu`                       | Label Studio 容器能使用的 CPU 上限 | `1`                                         |
| `app.resources.limits.memory`                    | Label Studio 容器能使用的内存上限  | `2Gi`                                       |
| `postgresql.enabled`                             | 是否安装 PostgreSQL                | `true`                                      |
| `postgresql.image.registry`                      | PostgreSQL 镜像注册表              | `"$(T9K_APP_IMAGE_REGISTRY)"`               |
| `postgresql.image.repository`                    | PostgreSQL 镜像仓库                | `"$(T9K_APP_IMAGE_NAMESPACE)/postgresql"`   |
| `postgresql.image.tag`                           | PostgreSQL 镜像标签                | `13.15.0`                                    |
| `postgresql.auth.username`                       | PostgreSQL 用户名                  | `"labelstudio"`                             |
| `postgresql.auth.password`                       | PostgreSQL 密码                    | `"labelstudio"`                             |
| `postgresql.auth.database`                       | PostgreSQL 数据库名称              | `"labelstudio"`                             |
