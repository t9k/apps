# RStudio

[RStudio](https://github.com/rstudio/rstudio) 集成开发环境旨在帮助你提高 R 和 Python 的工作效率。

## 镜像列表

当前应用可以选用以下镜像：

| 名称                                    | 环境      |
| --------------------------------------- | --------- |
| `t9kpublic/rocker-4.2.3-rstudio:1.72.1` | R, Python |

## 配置

### 示例

选用 PyTorch 环境，申请 16 个 CPU（核心）、32 GiB 内存资源，挂载存储卷 `tutorial`：

```yaml
image:
  registry: docker.io
  repository: t9kpublic/rocker-4.2.3-rstudio
  tag: "1.72.1"
  pullPolicy: IfNotPresent

pvc: "tutorial"

resources:
  cpu: "16"
  memory: 32Gi

# ssh:
#   enabled: true
#   authorizedKeys:
#   - "secret-name"
ssh:
  authorizedKeys: []
  enabled: false
  serviceType: ClusterIP
```

### 参数

| 名称                 | 描述                                                        | 值                               |
| -------------------- | ----------------------------------------------------------- | -------------------------------- |
| `image.registry`     | JupyterLab 容器镜像注册表。                                 | `docker.io`                      |
| `image.repository`   | JupyterLab 容器镜像仓库。                                   | `t9kpublic/rocker-4.2.3-rstudio` |
| `image.tag`          | JupyterLab 容器镜像标签。                                   | `1.72.1`                         |
| `image.pullPolicy`   | JupyterLab 容器镜像拉取策略。                               | `IfNotPresent`                   |
| `resources.cpu`      | JupyterLab 最多能使用的 CPU 数量。                          | `16`                             |
| `resources.memory`   | JupyterLab 最多能使用的内存数量。                           | `32Gi`                           |
| `pvc`                | 绑定一个 PVC 到 JupyterLab 上，作为 JupyterLab 的工作空间。 | `""`                             |
| `ssh.authorizedKeys` | 一系列记录 SSH 公钥的 K8s Secret 资源。                     | `[]`                             |
| `ssh.enabled`        | 是否在 Notebook 上启动 SSH 服务。                           | `false`                          |
| `ssh.serviceType`    | SSH 服务类型，支持 ClusterIP 和 NodePort 两种。             | `ClusterIP`                      |
