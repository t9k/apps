# Job Manager

Job Manager 是一个用于管理 [T9k Job](https://t9k.github.io/ucman/latest/api/t9k-job/index.html) 的控制台，是平台的原生应用。它提供了一个用户友好的界面，方便用户创建 Job、查看 Job 的详细信息，并监控计算资源的使用情况。

## 使用方法

待 App 就绪后，点击右侧的 <span class="twemoji"><svg class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg></span> 进入控制台：

![](https://s2.loli.net/2024/08/27/eDzBqjJbSWFNaou.png)

控制台的使用方法请参阅[进行数据并行训练](https://t9k.github.io/ucman/latest/guide/train-model/dp-training.html)。

## 配置

### 示例

默认配置：

```yaml
network:
  domain:
    home: "$(T9K_HOME_DOMAIN)"
    auth: "$(T9K_AUTH_DOMAIN)"

cluster:
  extendedResources:
    gpu: ["nvidia.com/gpu.shared", "nvidia.com/gpu"]
```

<!-- 其中 -->

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
