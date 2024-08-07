# Job Manager

Job Manager 是一个用于管理计算任务的控制台，可执行创建任务、查看任务状态、监控任务事件等操作。

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

server:
  serviceAccount: managed-project-sa
  imagePullPolicy: Always
  image: "docker.io/t9kpublic/job-manager-server:240715"

web:
  imagePullPolicy: Always
  image: "docker.io/t9kpublic/job-manager-web:240715"

cluster:
  extendedResources:
    gpu: ["nvidia.com/gpu.shared", "nvidia.com/gpu"]
```

### 参数

| 名称                                     | 描述                                                                                  | 值                                              |
| ---------------------------------------- | ------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `authorization.enabled`                  | 是否启用访问验证，在启用访问验证后，只有具有项目权限的人才可以访问 Job Manager 服务。 | `true`                                          |
| `authorization.clientID`                 | Oauth2 ClientID                                                                       | `t9k-client`                                    |
| `authorization.pepProxy.image`           | PEP Proxy 镜像。                                                                      | `docker.io/t9kpublic/pep-proxy:1.0.12`          |
| `authorization.pepProxy.imagePullPolicy` | PEP Proxy 镜像拉去策略。                                                              | `Always`                                        |
| `network.gateway`                        |                                                                                       | `project-gateway`                               |
| `network.domain.home`                    | T9K 平台的 Home 域名，App 启动后，用户通过该域名访问服务。                            | `https://home.sample.t9kcloud.cn`              |
| `network.domain.auth`                    | T9K 平台的授权域名。                                                                  | `https://auth.sample.t9kcloud.cn`              |
| `server.serviceAccount`                  | Job Manager 服务器所使用的 ServiceAccount。                                           | `managed-project-sa`                            |
| `server.imagePullPolicy`                 | Job Manager 服务器镜像拉取策略。                                                      | `Always`                                        |
| `server.image`                           | Job Manager 服务器镜像。                                                              | `docker.io/t9kpublic/job-manager-server:240715` |
| `web.imagePullPolicy`                    | Job Manager Web 镜像拉取策略。                                                        | `Always`                                        |
| `web.image`                              | Job Manager Web 镜像。                                                                | `docker.io/t9kpublic/job-manager-web:240715`    |
| `cluster.extendedResources.gpu`          | 集群所支持的 GPU 扩展资源。                                                           | `["nvidia.com/gpu.shared", "nvidia.com/gpu"]`   |
