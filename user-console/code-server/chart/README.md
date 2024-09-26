# Code Server

[Code Server](https://github.com/coder/code-server) 是一个可以通过浏览器访问的 VSCode。

## 使用方法

待应用就绪后，点击右侧的 <svg class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg> 进入网页 UI，即可进行开发工作。

![](https://s2.loli.net/2024/09/20/REwK5AdXVugJYLt.png)

网页 UI 的使用方法请参阅 [Visual Studio Code Docs](https://code.visualstudio.com/docs) 和 [FAQ of Code Server](https://coder.com/docs/code-server/FAQ)。

## 配置

### 示例

选用 PyTorch 环境，，挂载 PVC `tutorial`，申请 16 个 CPU（核心）、32 GiB 内存资源以及 1 个 NVIDIA GPU，调度到带有 label `nvidia.com/gpu.product: NVIDIA-A100-PCIE-40GB`（即拥有 NVIDIA A100 40GB GPU）的节点：

```yaml
image:
  registry: docker.io
  repository: t9kpublic/code-server
  tag: "20240923"
  pullPolicy: IfNotPresent

pvc: "tutorial"

resources:
  limits:
    cpu: 16
    memory: 32Gi
    nvidia.com/gpu: 1

nodeSelector:
  nvidia.com/gpu.product: NVIDIA-A100-PCIE-40GB
```

选用 PyTorch 环境，挂载 PVC `demo`，申请 4 个 CPU（核心）、8 GiB 内存资源：

```yaml
image:
  registry: docker.io
  repository: t9kpublic/code-server
  tag: "20240923"
  pullPolicy: IfNotPresent

pvc: "demo"

resources:
  limits:
    cpu: 4
    memory: 8Gi
    # nvidia.com/gpu: 1
```

### 字段

| 名称                                | 描述                                                            | 值                      |
| ----------------------------------- | --------------------------------------------------------------- | ----------------------- |
| `image.registry`                    | Code Server 容器镜像注册表。                                    | `docker.io`             |
| `image.repository`                  | Code Server 容器镜像仓库。                                      | `t9kpublic/code-server` |
| `image.tag`                         | Code Server 容器镜像标签。                                      | `20240923`              |
| `image.pullPolicy`                  | Code Server 容器镜像拉取策略。                                  | `IfNotPresent`          |
| `pvc`                               | 挂载到 Code Server 上的 PVC 名称，作为 Code Server 的工作空间。 | `""`                    |
| `resources.limits.cpu`              | Code Server 最多能使用的 CPU 数量。                             | `16`                    |
| `resources.limits.memory`           | Code Server 最多能使用的内存数量。                              | `32Gi`                  |
| `resources.limits."nvidia.com/gpu"` | Code Server 最多能使用的 GPU 数量。                             | `1`                     |
| `nodeSelector`                      | 用于选择节点，Code Server 只会被调度到标签与之匹配的节点上。    | `null`                  |

### 镜像列表

当前应用可以选用以下镜像：

| 名称                                  | 环境             |
| ------------------------------------- | ---------------- |
| `t9kpublic/code-server:20240923`      | PyTorch 2, conda |
| `t9kpublic/code-server:20240923-sudo` | PyTorch 2, conda |

每个镜像包含 Code Server 和特定的环境（机器学习框架或 conda 环境），同时预装了一些 Python 包、命令行工具和平台工具。
