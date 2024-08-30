# Workflow

Workflow 是一个用于管理工作流的控制台。工作流的详细介绍请参考[用户文档]("https://t9k.github.io/ucman/latest/api/workflow/index.html")。

## 配置

### 示例

默认配置：

```yaml
authorization:
  enabled: true
  clientID: "t9k-client"
  pepProxy:
    image: "docker.io/t9kpublic/pep-proxy:1.0.12"
    imagePullPolicy: IfNotPresent

network:
  gateway: project-gateway
  domain:
    home: "https://home.sample.t9kcloud.cn"
    auth: "https://auth.sample.t9kcloud.cn"

app:
  image: "docker.io/t9kpublic/workflow-app:240830"
  imagePullPolicy: IfNotPresent
```


### 参数

| 名称                                     | 描述                                                                                  | 值                                            |
| ---------------------------------------- | ------------------------------------------------------------------------------------- | --------------------------------------------- |
| `authorization.enabled`                  | 是否启用访问验证，在启用访问验证后，只有具有项目权限的人才可以访问 Workflow 应用。 | `true`                                        |
| `authorization.clientID`                 | Oauth2 ClientID                                                                       | `t9k-client`                                  |
| `authorization.pepProxy.image`           | PEP Proxy 镜像。                                                                      | `docker.io/t9kpublic/pep-proxy:1.0.12`        |
| `authorization.pepProxy.imagePullPolicy` | PEP Proxy 镜像拉去策略。                                                              | `IfNotPresent`                                |
| `network.gateway`                        |                                                                                       | `project-gateway`                             |
| `network.domain.home`                    | T9K 平台的 Home 域名，App 启动后，用户通过该域名访问服务。                            | `https://home.sample.t9kcloud.cn`             |
| `network.domain.auth`                    | T9K 平台的授权域名。                                                                  | `https://auth.sample.t9kcloud.cn`             |
| `app.image`                                  | App 镜像。                                                                            | `docker.io/t9kpublic/workflow-app:240830`     |
| `app.imagePullPolicy`                        | 镜像拉取策略。                                                                        | `IfNotPresent`                                      |
