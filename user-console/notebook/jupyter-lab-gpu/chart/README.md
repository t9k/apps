# JupyterLab (Nvidia GPU)

[JupyterLab](https://github.com/jupyterlab/jupyterlab) 是最新的基于 Web 的交互式开发环境，用于代码开发和数据处理。其灵活的界面允许用户配置和安排数据科学、科学计算和机器学习中的工作流程。

JupyterLab (Nvidia GPU) 仅配置了 CPU。如要使用 Nvidia GPU，请切换到 [JupyterLab (Nvidia GPU)]() 应用。

## 镜像列表

当前应用可以选用以下镜像：

| 名称                                                | 环境             |
| --------------------------------------------------- | ---------------- |
| `t9kpublic/torch-2.1.0-notebook:20240716`           | PyTorch 2, conda |
| `t9kpublic/tensorflow-2.14.0-notebook-gpu:20240716` | TensorFlow 2     |
| `t9kpublic/miniconda-22.11.1-notebook:20240716`     | conda            |

每个镜像包含特定的机器学习框架，同时预装了一些 Python 包、命令行工具和最新版本的平台工具。

## 配置

### 示例

选用 PyTorch 环境，申请 16 个 CPU（核心）、32 GiB 内存资源以及 1 个 Nvidia GPU，挂载存储卷 `tutorial`：

```yaml
image:
  registry: docker.io
  repository: t9kpublic/torch-2.1.0-notebook
  tag: "20240716"
  pullPolicy: IfNotPresent

pvc: "tutorial"

resources:
  cpu: "16"
  memory: 32Gi
  gpu: "1"

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
| `image.repository`   | JupyterLab 容器镜像仓库。                                   | `t9kpublic/torch-2.1.0-notebook` |
| `image.tag`          | JupyterLab 容器镜像标签。                                   | `20240716`                       |
| `image.pullPolicy`   | JupyterLab 容器镜像拉取策略。                               | `IfNotPresent`                   |
| `resources.cpu`      | JupyterLab 最多能使用的 CPU 数量。                          | `16`                             |
| `resources.memory`   | JupyterLab 最多能使用的内存数量。                           | `32Gi`                           |
| `resources.gpu`      | JupyterLab 最多能使用的 GPU 数量。                          | `1`                              |
| `pvc`                | 绑定一个 PVC 到 JupyterLab 上，作为 JupyterLab 的工作空间。 | `""`                             |
| `ssh.authorizedKeys` | 一系列记录 SSH 公钥的 K8s Secret 资源。                     | `[]`                             |
| `ssh.enabled`        | 是否在 Notebook 上启动 SSH 服务。                           | `false`                          |
| `ssh.serviceType`    | SSH 服务类型，支持 ClusterIP 和 NodePort 两种。             | `ClusterIP`                      |
