# AutoTune

AutoTune 是一个自动化机器学习（AutoML）工具，详细介绍请参阅[用户文档](https://t9k.github.io/user-manuals/latest/modules/building/autotune.html)。

## 使用方法

待 App 就绪后，点击右侧的 <svg width="1em" height="1em" class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg> 进入控制台。

<!-- ![](https://s2.loli.net/2024/09/27/2GTdU4RYc1JZsnQ.png)

控制台的使用方法请参阅[进行数据并行训练](https://t9k.github.io/ucman/latest/guide/train-model/dp-training.html)。 -->

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

| 名称                                      | 描述                                                                             | 值                                            |
| ----------------------------------------- | -------------------------------------------------------------------------------- | --------------------------------------------- |
| `authorization.enabled`                   | 是否启用访问验证，在启用访问验证后，只有具有项目权限的人才可以访问 AutoTune 应用 | `true`                                        |
| `authorization.clientID`                  | Oauth2 ClientID                                                                  | `t9k-client`                                  |
| `authorization.pepProxy.image`            | PEP Proxy 镜像                                                                   |                                               |
| `authorization.pepProxy.image.registry`   | PEP Proxy 镜像注册表                                                             | `docker.io`                                   |
| `authorization.pepProxy.image.repository` | PEP Proxy 镜像仓库                                                               | `t9kpublic/pep-proxy`                         |
| `authorization.pepProxy.image.tag`        | PEP Proxy 镜像标签                                                               | `1.0.12`                                      |
| `authorization.pepProxy.imagePullPolicy`  | PEP Proxy 镜像拉取策略                                                           | `Always`                                      |
| `network.gateway`                         |                                                                                  | `project-gateway`                             |
| `network.domain.home`                     | T9K 平台的 Home 域名，App 启动后，用户通过该域名访问服务                         | `https://home.sample.t9kcloud.cn`             |
| `network.domain.auth`                     | T9K 平台的授权域名                                                               | `https://auth.sample.t9kcloud.cn`             |
| `imagePullPolicy`                         | AutoTune 镜像拉取策略                                                            | `Always`                                      |
| `image`                                   | AutoTune 镜像                                                                    | `docker.io/t9kpublic/autotune-app:240822`     |
| `cluster.extendedResources.gpu`           | 集群所支持的 GPU 扩展资源                                                        | `["nvidia.com/gpu.shared", "nvidia.com/gpu"]` |
