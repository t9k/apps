# JupyterLab (Enflame GCU)

[JupyterLab](https://github.com/jupyterlab/jupyterlab) 是最新的基于 Web 的交互式开发环境，用于代码开发和数据处理。其灵活的界面允许用户配置和安排数据科学、科学计算和机器学习中的工作流程。

JupyterLab (Enflame GCU) 额外配置了燧原 GCU，你可以在其中进行 GCU 相关的开发和测试。

## 镜像列表

当前应用可以选用以下镜像：

| 名称     | 环境      |
| -------- | --------- |
| （暂缺） | PyTorch 2 |

## 配置

### 示例

选用 PyTorch 环境，申请 16 个 CPU（核心）、32 GiB 内存资源，挂载存储卷 `tutorial`：

```yaml
image:
  registry: ""
  repository: ""
  tag: ""
  pullPolicy: IfNotPresent

pvc: "tutorial"

resources:
  cpu: "16"
  memory: 32Gi
  gcu: "1"
```

### 参数

| 名称               | 描述                                                          | 值             |
| ------------------ | ------------------------------------------------------------- | -------------- |
| `image.registry`   | JupyterLab 容器镜像注册表。                                  | `""`           |
| `image.repository` | JupyterLab 容器镜像仓库。                                    | `""`           |
| `image.tag`        | JupyterLab 容器镜像标签。                                    | `""`           |
| `image.pullPolicy` | JupyterLab 容器镜像拉取策略。                                | `IfNotPresent` |
| `resources.cpu`    | JupyterLab 最多能使用的 CPU 数量。                           | `16`           |
| `resources.memory` | JupyterLab 最多能使用的内存数量。                            | `32Gi`         |
| `resources.gcu`    | JupyterLab 最多能使用的燧原 GCU 数量。                       | `1`            |
| `pvc`              | 绑定一个 PVC 到 JupyterLab 上，作为 JupyterLab 的工作空间。 | `""`           |
