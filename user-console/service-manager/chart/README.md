# Service Manager

Service Manager 是一个用于管理推理服务的控制台。

## 配置

### 示例

```yaml
global:
  image:
    # -- Overrides the Docker registry globally for all images
    registry: null

authorization:
  enabled: true
  clientID: "t9k-client"
  pepProxy:
    image: 
      registry: "docker.io"
      repository: "t9kpublic/pep-proxy"
      tag: "1.0.12"
      pullPolicy: IfNotPresent

network:
  gateway: project-gateway
  domain:
    home: "https://home.sample.t9kcloud.cn"
    auth: "https://auth.sample.t9kcloud.cn"
  
web:
  image:
    registry: "docker.io"
    repository: "t9kpublic/service-manager-web"
    tag: "240815"  
    pullPolicy: IfNotPresent
```

### 参数

| 名称                                     | 描述                                                                                  | 默认值                                              |
| ---------------------------------------- | ------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `global.image.registry`                  | 设值后，可以替换所有镜像的 registry                                                | null| 
| `authorization.enabled`                  | 是否启用访问验证，在启用访问验证后，只有具有项目权限的人才可以访问 Service Manager 服务。         | `true`                                          |
| `authorization.clientID`                 | Oauth2 ClientID                                                                       | `t9k-client`                                    |
| `authorization.pepProxy.image.registry`           | PEP Proxy 镜像 registry                                                        |    `docker.io`     |
| `authorization.pepProxy.image.repository`           | PEP Proxy 镜像 repository                                                   |    `t9kpublic/pep-proxy`     |
| `authorization.pepProxy.image.tag`           | PEP Proxy 镜像 tag                                                                   |    `1.0.12`     |
| `authorization.pepProxy.image.pullPolicy` | PEP Proxy 镜像拉取策略。                                                                 | `IfNotPresent`                                        |
| `network.gateway`                        | 项目中的 Istio Gateway 名称。                                                            | `project-gateway`                               |
| `network.domain.home`                    | T9K 平台的 Home 域名，App 启动后，用户通过该域名访问服务。                                    | `https://home.sample.t9kcloud.cn`              |
| `network.domain.auth`                    | T9K 平台的授权域名。                                                                      | `https://auth.sample.t9kcloud.cn`              |
| `web.image.registry`                              | Service Manager Web 镜像 registry                                               | `docker.io`   |
| `web.image.repository`                              | Service Manager Web 镜像 repository                                          | `t9kpublic/service-manager-web`   |
| `web.image.tag`                              | Service Manager Web 镜像 repository                                                 | `240815`   |
| `web.image.pullPolicy`                    | Service Manager Web 镜像拉取策略。                                                       | `IfNotPresent`                                        |
