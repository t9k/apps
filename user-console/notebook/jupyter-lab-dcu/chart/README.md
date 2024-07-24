# JupyterLab (Hygon GPU)

[JupyterLab](https://github.com/jupyterlab/jupyterlab) 是最新的基于 Web 的交互式开发环境，用于代码开发和数据处理。其灵活的界面允许用户配置和安排数据科学、科学计算和机器学习中的工作流程。

JupyterLab (Hygon GPU) 额外配置了海光 DCU，你可以在其中进行 DCU 相关的开发和测试。

## 镜像列表

当前应用可以选用以下镜像：

| 名称                                                                      | 环境      |
| ------------------------------------------------------------------------- | --------- |
| `registry.cn-hangzhou.aliyuncs.com/t9k/jupyterlab-torch-2.1.0:240708-dcu` | PyTorch 2 |

每个镜像包含特定的机器学习框架，同时预装了一些 Python 包、命令行工具和最新版本的平台工具。

## 配置

### 示例

选用 PyTorch 环境，申请 16 个 CPU（核心）、32 GiB 内存资源以及 1 个海光 DCU，挂载存储卷 `tutorial`：

```yaml
image:
  registry: "registry.cn-hangzhou.aliyuncs.com"
  repository: "t9k/jupyterlab-torch-2.1.0"
  tag: "240708-dcu"
  pullPolicy: IfNotPresent

pvc: "tutorial"

resources:
  cpu: "16"
  memory: 32Gi
  dcu: "1"
```

### 参数

| 名称               | 描述                                                          | 值             |
| ------------------ | ------------------------------------------------------------- | -------------- |
| `image.registry`   | JupyterLab 容器镜像注册表。                                  | `registry.cn-hangzhou.aliyuncs.com`           |
| `image.repository` | JupyterLab 容器镜像仓库。                                    | `t9k/jupyterlab-torch-2.1.0`           |
| `image.tag`        | JupyterLab 容器镜像标签。                                    | `240708-dcu`           |
| `image.pullPolicy` | JupyterLab 容器镜像拉取策略。                                | `IfNotPresent` |
| `resources.cpu`    | JupyterLab 最多能使用的 CPU 数量。                           | `16`           |
| `resources.memory` | JupyterLab 最多能使用的内存数量。                            | `32Gi`         |
| `resources.gcu`    | JupyterLab 最多能使用的海光 DCU 数量。                       | `1`            |
| `pvc`              | 绑定一个 PVC 到 JupyterLab 上，作为 JupyterLab 的工作空间。 | `""`           |
