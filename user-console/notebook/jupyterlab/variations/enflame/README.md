# JupyterLab

[JupyterLab](https://github.com/jupyterlab/jupyterlab) 是最新的基于 Web 的交互式开发环境，用于代码开发和数据处理。其灵活的界面允许用户配置和安排数据科学、科学计算和机器学习中的工作流程。

## 使用方法

待应用就绪后，点击右侧的 <svg width="1em" height="1em" class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg> 进入网页 UI，即可进行开发工作。

![](https://s2.loli.net/2024/08/20/tZiw9cyL6a4Vbkz.png)

网页 UI 的使用方法请参阅 [JupyterLab Documentation](https://jupyterlab.readthedocs.io/en/latest/) 或[它的中文版本](https://jupyterlab.pythonlang.cn/en/latest/)。[TensorBoard 插件](https://github.com/HFAiLab/jupyterlab_tensorboard_pro)的使用方法请参阅[使用说明](https://github.com/HFAiLab/jupyterlab_tensorboard_pro/blob/v4.x/README.zh-cn.md#%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E)。

除了网页 UI，App 还支持通过 SSH 远程连接（需要启用 SSH 服务），让你能够使用熟悉的本地终端或 IDE，像在本地开发一样进行远程开发。限于篇幅，具体步骤请参阅[如何通过 SSH 远程连接](https://t9k.github.io/ucman/latest/reference/faq/faq-in-ide-usage.html#%E5%A6%82%E4%BD%95%E9%80%9A%E8%BF%87-ssh-%E8%BF%9C%E7%A8%8B%E8%BF%9E%E6%8E%A5)。

## 配置

请参阅[配置和使用说明](https://t9k.github.io/ucman/latest/app/jupyterlab.html#%E9%85%8D%E7%BD%AE%E5%92%8C%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E)。

### 示例

选用 conda 环境，挂载 PVC `demo`，申请 16 个 CPU（核心）、32 GiB 内存资源，启用 ClusterIP 类型的 SSH 服务：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/jupyterlab-miniconda-24.7.1"
  tag: "20241031"
  pullPolicy: IfNotPresent

pvc: "demo"

resources:
  limits:
    cpu: 16
    memory: 32Gi

ssh:
  enabled: true
  authorizedKeys:
  - <YOUR_SECRET_OF_SSH_PUBLIC_KEY>
  serviceType: ClusterIP
```

选用 PyTorch 环境，挂载 PVC `tutorial`，申请 4 个 CPU（核心）、8 GiB 内存资源以及 1 个 Enflame GCU：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "topsrider/jupyterlab-torch-2.3.0"
  tag: "20241224"
  pullPolicy: IfNotPresent

pvc: "tutorial"

resources:
  limits:
    cpu: 4
    memory: 8Gi
    enflame.com/gcu: 1

ssh:
  enabled: false
  authorizedKeys: []
  serviceType: ClusterIP
```

### 字段

| 名称                                 | 描述                                                        | 值                                 |
| ------------------------------------ | ----------------------------------------------------------- | ---------------------------------- |
| `image.registry`                     | JupyterLab 镜像注册表                                       | `$(T9K_APP_IMAGE_REGISTRY)`    |
| `image.repository`                   | JupyterLab 镜像仓库                                         | `topsrider/jupyterlab-torch-2.3.0` |
| `image.tag`                          | JupyterLab 镜像标签                                         | `20241224`                         |
| `image.pullPolicy`                   | JupyterLab 镜像拉取策略                                     | `IfNotPresent`                     |
| `pvc`                                | 挂载到 JupyterLab 上的 PVC 名称，作为 JupyterLab 的工作空间 | `""`                               |
| `resources.limits.cpu`               | JupyterLab 容器能使用的 CPU 上限                            | `16`                               |
| `resources.limits.memory`            | JupyterLab 容器能使用的内存上限                             | `32Gi`                             |
| `resources.limits."enflame.com/gcu"` | JupyterLab 容器能使用的 Enflame GCU 上限                    | `1`                                |
| `ssh.enabled`                        | 是否为 JupyterLab 启用 SSH 服务                             | `false`                            |
| `ssh.authorizedKeys`                 | 一系列记录 SSH 公钥的 K8s Secret 资源                       | `[]`                               |
| `ssh.serviceType`                    | SSH 服务类型，支持 ClusterIP 和 NodePort 两种               | `ClusterIP`                        |
| `nodeSelector`                       | 用于选择节点，JupyterLab 只会被调度到标签与之匹配的节点上   | `[]`                               |

### 镜像列表

请根据你要使用的加速设备（或不使用加速设备）选用相应的镜像。

每个镜像都包含 JupyterLab 和特定的环境（机器学习框架或 conda 环境），同时预装了一些 Python 包、命令行工具和平台工具。

#### CPU

仅使用 CPU 计算（不使用加速设备）时，可以选用以下镜像：

| 名称                                                                        | 环境             |
| --------------------------------------------------------------------------- | ---------------- |
| `topsrider/jupyterlab-torch-2.3.0:20241224`                                 | PyTorch 2        |
| `topsrider/jupyterlab-torch-2.3.0:20241224-sudo`                            | PyTorch 2        |
| `$(T9K_APP_IMAGE_NAMESPACE)/jupyterlab-torch-2.5.0:20241031`                | PyTorch 2, conda |
| `$(T9K_APP_IMAGE_NAMESPACE)/jupyterlab-torch-2.5.0:20241031-sudo`           | PyTorch 2, conda |
| `$(T9K_APP_IMAGE_NAMESPACE)/jupyterlab-tensorflow-2.17.0-cpu:20241031`      | TensorFlow 2     |
| `$(T9K_APP_IMAGE_NAMESPACE)/jupyterlab-tensorflow-2.17.0-cpu:20241031-sudo` | TensorFlow 2     |
| `$(T9K_APP_IMAGE_NAMESPACE)/jupyterlab-miniconda-24.7.1:20241031`           | conda            |
| `$(T9K_APP_IMAGE_NAMESPACE)/jupyterlab-miniconda-24.7.1:20241031-sudo`      | conda            |

#### Enflame GCU

使用 Enflame GCU 作为加速设备时，可以选用以下镜像：

| 名称                                             | 环境      |
| ------------------------------------------------ | --------- |
| `topsrider/jupyterlab-torch-2.3.0:20241224`      | PyTorch 2 |
| `topsrider/jupyterlab-torch-2.3.0:20241224-sudo` | PyTorch 2 |
