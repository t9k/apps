# RStudio

[RStudio](https://github.com/rstudio/rstudio) 集成开发环境旨在帮助你提高 R 和 Python 的工作效率。

## 使用方法

待应用就绪后，点击右侧的 <svg width="1em" height="1em" class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg> 进入网页 UI，即可进行开发工作。

![](https://s2.loli.net/2024/08/20/352KNIgUtiFhbGk.png)

网页 UI 的使用方法请参阅 [RStudio User Guide](https://docs.posit.co/ide/user/)。

除了网页 UI，App 还支持通过 SSH 远程连接（需要启用 SSH 服务），让你能够使用熟悉的本地终端或 IDE，像在本地开发一样进行远程开发。限于篇幅，具体步骤请参阅[如何通过 SSH 远程连接](https://t9k.github.io/ucman/latest/reference/faq/faq-in-ide-usage.html#%E5%A6%82%E4%BD%95%E9%80%9A%E8%BF%87-ssh-%E8%BF%9C%E7%A8%8B%E8%BF%9E%E6%8E%A5)。

## 配置

### 示例

申请 16 个 CPU（核心）、32 GiB 内存资源，挂载存储卷 `tutorial`：

```yaml
image:
  registry: docker.io
  repository: t9kpublic/rocker-4.2.3-rstudio
  tag: "1.72.1"
  pullPolicy: IfNotPresent

volumes:
  workingDir:
    pvc: "tutorial"

resources:
  limits:
    cpu: 16
    memory: 32Gi

ssh:
  enabled: false
  authorizedKeys: []
  serviceType: ClusterIP
```

申请 4 个 CPU（核心）、8 GiB 内存资源，挂载存储卷 `demo`，启用 ClusterIP 类型的 SSH 服务：

```yaml
image:
  registry: docker.io
  repository: t9kpublic/rocker-4.2.3-rstudio
  tag: "1.72.1"
  pullPolicy: IfNotPresent

volumes:
  workingDir:
    pvc: "demo"

# volumes:
#   workingDir:
#     pvc: "demo"
#   extraVolumes:
#     - volume:
#         name: volume-name
#         persistentVolumeClaim:
#           claimName: "demo2"
#       mountPath: /volume/mount/path

resources:
  limits:
    cpu: 4
    memory: 8Gi

ssh:
  enabled: true
  authorizedKeys:
    - <YOUR_SECRET_OF_SSH_PUBLIC_KEY>
  serviceType: ClusterIP
```

### 字段

| 名称                               | 描述                                                                                                                                                | 值                                                |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| `image.registry`                   | RStudio 镜像注册表                                                                                                                                  | `$(T9K_APP_IMAGE_REGISTRY)`                       |
| `image.repository`                 | RStudio 镜像仓库                                                                                                                                    | `$(T9K_APP_IMAGE_NAMESPACE)/rocker-4.2.3-rstudio` |
| `image.tag`                        | RStudio 镜像标签                                                                                                                                    | `1.72.1`                                          |
| `image.pullPolicy`                 | RStudio 镜像拉取策略                                                                                                                                | `IfNotPresent`                                    |
| `volumes`                          | 挂载到 RStudio 上的存储卷                                                                                                                           | `{}`                                              |
| `volumes.workingDir`               | 挂在一个 PVC 到 RStudio 上，作为 RStudio 的工作空间                                                                                                 | `{}`                                              |
| `volumes.workingDir.pvc`           | 作为 RStudio 的工作空间挂载到 RStudio 上的 PVC 名称                                                                                                 | `""`                                              |
| `volumes.extraVolumes`             | 挂载到 RStudio 上的额外存储卷                                                                                                                       | `[]`                                              |
| `volumes.extraVolumes[].volume`    | 额外挂载的存储卷，可设置的存储卷类型和结构，请参考：https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/volume/#Volume | `{}`                                              |
| `volumes.extraVolumes[].mountPath` | 存储卷的挂载路径                                                                                                                                    | `""`                                              |
| `resources.limits.cpu`             | RStudio 容器能使用的 CPU 上限                                                                                                                       | `16`                                              |
| `resources.limits.memory`          | RStudio 容器能使用的内存上限                                                                                                                        | `32Gi`                                            |
| `ssh.authorizedKeys`               | 一系列记录 SSH 公钥的 K8s Secret 资源                                                                                                               | `[]`                                              |
| `ssh.enabled`                      | 是否在 Notebook 上启用 SSH 服务                                                                                                                     | `false`                                           |
| `ssh.serviceType`                  | SSH 服务类型，支持 ClusterIP 和 NodePort 两种                                                                                                       | `ClusterIP`                                       |
| `nodeSelector`                     | 用于选择节点，RStudio 只会被调度到标签与之匹配的节点上                                                                                              | `[]`                                              |

### 镜像列表

当前应用可以选用以下镜像：

| 名称                                           |
| ---------------------------------------------- |
| `t9kpublic/rocker-4.2.3-rstudio:1.72.1`        |
| `t9kpublic/rocker-4.2.3-rstudio:1.72.1-sudo`   |
| `t9kpublic/rocker-4.2.3-tidyverse:1.72.1`      |
| `t9kpublic/rocker-4.2.3-tidyverse:1.72.1-sudo` |
| `t9kpublic/rocker-4.2.3-verse:1.72.1`          |
| `t9kpublic/rocker-4.2.3-verse:1.72.1-sudo`     |
| `t9kpublic/rocker-4.2.3-ml:1.72.1`             |
| `t9kpublic/rocker-4.2.3-ml:1.72.1-sudo`        |

每个镜像都包含 RStudio，以及 R 和 Python 环境，预装了一些命令行工具。关于这些镜像的更多信息，请参阅 [The Rocker Images](https://rocker-project.org/images/)。
