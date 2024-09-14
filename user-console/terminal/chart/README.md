# Terminal

一个通过 Web 使用的终端应用，基于 [ttyd](https://github.com/tsl0922/ttyd)。用户可以在浏览器中连接到该终端以进行各项工作，包括使用 `kubectl` 管理 K8s 资源。

当前应用已安装 `kubectl`、`tmux`、`helm`、`vim` 等命令行工具。

## 使用方法

待应用就绪后，点击右侧的 <svg class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg> 进入网页 UI，即可输入并执行命令：

![](https://s2.loli.net/2024/08/23/e7H35PuTDZgYic1.png)

web 终端的使用方法与本地终端类似：在提示符后面输入命令并按下回车键，远程服务器会接收这些命令，执行后将结果返回并显示。

## 配置

### 示例

shell 选用 bash，未挂载存储卷：

```yaml
shell: bash

resources:
  limits:
    cpu: 200m
    memory: 200Mi

# pvcs:
# - name: <pvc-1>
#   mountPath: /mnt/one
# - name: <pvc-2>
#   mountPath: /mnt/two
pvcs: []

global:
  t9k:
    homeURL: "$(T9K_HOME_URL)"
    securityService:
      enabled: true
      endpoints:
        oidc: "$(T9K_OIDC_ENDPOINT)"
        securityServer: "$(T9K_SECURITY_CONSOLE_SERVER_ENDPOINT)"
    pepProxy:
      args:
        clientID: $(T9K_APP_AUTH_CLINET_ID)
```

### 字段

| 名称                                                 | 描述                                                                           | 值                                        |
| ---------------------------------------------------- | ------------------------------------------------------------------------------ | ----------------------------------------- |
| `shell`                                              | 终端中使用的 shell 类型，可以选择 sh、bash 或 zsh。                            | `bash`                                    |
| `pingIntervalSeconds`                                | 为保证链接长时间可用，不会被关闭，设置该字段定期发送 ping 请求来保持链接活跃。 | `30`                                      |
| `resources.limits.cpu`                               | Terminal 最多能使用的 CPU 数量。                                               | `200m`                                    |
| `resources.limits.memory`                            | Terminal 最多能使用的内存数量。                                                | `200Mi`                                   |
| `pvc[@].name`                                        | 绑定一个 PVC 到 Terminal 上。                                                  | `""`                                      |
| `pvc[@].mountPath`                                   | PVC 的绑定路径。                                                               | `""`                                      |
| `global.t9k.homeURL`                                 | 设置一个 URL 暴露 Terminal 服务（需具有对应的 Ingress）。                      | `$(T9K_HOME_URL)`                         |
| `global.t9k.securityService.enabled`                 | 启用身份认证后，只有当前项目的成员才可以使用该 Terminal。                      | `true`                                    |
| `global.t9k.securityService.endpoint.oidc`           | 身份认证所需要的 OIDC 服务地址。                                               | `$(T9K_OIDC_ENDPOINT)`                    |
| `global.t9k.securityService.endpoint.securityServer` | TensorStack 平台的 Security Console 服务器地址。                               | `$(T9K_SECURITY_CONSOLE_SERVER_ENDPOINT)` |
| `image`                                              | Terminal 镜像。                                                                |                                           |
| `image.registry`                                     | Terminal 镜像注册表。                                                          | `docker.io`                               |
| `image.repository`                                   | Terminal 镜像仓库。                                                            | `t9kpublic/terminal`                      |
| `image.tag`                                          | Terminal 镜像标签。                                                            | `240819`                                  |
| `global.t9k.pepProxy.image`                          | PEP Proxy 镜像。                                                               |                                           |
| `global.t9k.pepProxy.image.registry`                 | PEP Proxy 镜像注册表。                                                         | `docker.io`                               |
| `global.t9k.pepProxy.image.repository`               | PEP Proxy 镜像。                                                               | `t9kpublic/pep-proxy`                     |
| `global.t9k.pepProxy.image.tag`                      | PEP Proxy 镜像。                                                               | `1.0.12`                                  |
| `global.t9k.pepProxy.args.clientID`                  | Terminal 使用该 Client ID 向授权服务器申请授权。                               | `$(T9K_APP_AUTH_CLINET_ID)`               |
