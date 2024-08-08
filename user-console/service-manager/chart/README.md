# Service Manager

Service Manager 是一个用于管理推理服务的控制台。

## 配置

### 示例

```yaml
authorization:
  enabled: true
  clientID: "t9k-client"
  pepProxy:
    image: 
      registry: "docker.io"
      repository: "t9kpublic/pep-proxy"
      tag: "1.0.12"
    imagePullPolicy: Always

network:
  gateway: project-gateway
  domain:
    home: "https://home.sample.t9kcloud.cn"
    auth: "https://auth.sample.t9kcloud.cn"
  
web:
  imagePullPolicy: IfNotPresent
  image:
    registry: "docker.io"
    repository: "t9kpublic/service-manager-web"
    tag: "v0.1.1"  
```

### 参数

| 名称                                     | 描述                                                                                  | 值                                              |
| ---------------------------------------- | ------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `authorization.enabled`                  | 是否启用访问验证，在启用访问验证后，只有具有项目权限的人才可以访问 Service Manager 服务。 | `true`                                          |
| `authorization.clientID`                 | Oauth2 ClientID                                                                       | `t9k-client`                                    |
| `authorization.pepProxy.image`           | PEP Proxy 镜像 regisry, repository 和 tag。                                                                      | -         |
| `authorization.pepProxy.imagePullPolicy` | PEP Proxy 镜像拉取策略。                                                              | `Always`                                        |
| `network.gateway`                        | 项目中的 Istio Gateway 名称。                                                        | `project-gateway`                               |
| `network.domain.home`                    | T9K 平台的 Home 域名，App 启动后，用户通过该域名访问服务。                            | `https://home.sample.t9kcloud.cn`              |
| `network.domain.auth`                    | T9K 平台的授权域名。                                                                  | `https://auth.sample.t9kcloud.cn`              |
| `web.imagePullPolicy`                    | Service Manager Web 镜像拉取策略。                                                        | `Always`                                        |
| `web.image`                              | Service Manager Web 镜像 regisry, repository 和 tag。                                                                | =   |
