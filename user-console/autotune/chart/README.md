# AutoTune

AutoTune 是一个自动化机器学习 （AutoML）工具。

AutoTune 的详细介绍请参考[用户文档](https://t9k.github.io/user-manuals/latest/modules/building/autotune.html)。

## 配置

### 示例

```yaml
authorization:
  enabled: true
  clientID: "t9k-client"
  pepProxy:
    image: "docker.io/t9kpublic/pep-proxy:1.0.12"
    imagePullPolicy: Always

network:
  gateway: project-gateway
  domain:
    home: "https://home.sample.t9kcloud.cn"
    auth: "https://auth.sample.t9kcloud.cn"

imagePullPolicy: Always
image: "docker.io/t9kpublic/autotune-app:240822"

cluster:
  extendedResources:
    gpu: ["nvidia.com/gpu.shared", "nvidia.com/gpu"]
```

### 参数

| 名称                                     | 描述                                                                                  | 值                                            |
| ---------------------------------------- | ------------------------------------------------------------------------------------- | --------------------------------------------- |
| `authorization.enabled`                  | 是否启用访问验证，在启用访问验证后，只有具有项目权限的人才可以访问 Job Manager 服务。 | `true`                                        |
| `authorization.clientID`                 | Oauth2 ClientID                                                                       | `t9k-client`                                  |
| `authorization.pepProxy.image`           | PEP Proxy 镜像。                                                                      | `docker.io/t9kpublic/pep-proxy:1.0.12`        |
| `authorization.pepProxy.imagePullPolicy` | PEP Proxy 镜像拉去策略。                                                              | `Always`                                      |
| `network.gateway`                        |                                                                                       | `project-gateway`                             |
| `network.domain.home`                    | T9K 平台的 Home 域名，App 启动后，用户通过该域名访问服务。                            | `https://home.sample.t9kcloud.cn`             |
| `network.domain.auth`                    | T9K 平台的授权域名。                                                                  | `https://auth.sample.t9kcloud.cn`             |
| `imagePullPolicy`                        | 镜像拉取策略。                                                                        | `Always`                                      |
| `image`                                  | App 镜像。                                                                            | `docker.io/t9kpublic/autotune-app:240822`     |
| `cluster.extendedResources.gpu`          | 集群所支持的 GPU 扩展资源。                                                           | `["nvidia.com/gpu.shared", "nvidia.com/gpu"]` |
