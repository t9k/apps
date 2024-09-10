# JupyterLab (Enflame GCU)

[JupyterLab](https://github.com/jupyterlab/jupyterlab) 是最新的基于 Web 的交互式开发环境，用于代码开发和数据处理。其灵活的界面允许用户配置和安排数据科学、科学计算和机器学习中的工作流程。

JupyterLab (Enflame GCU) 额外配置了燧原 GCU，你可以在其中进行 GCU 相关的开发和测试。

## 使用方法

待应用就绪后，点击右侧的 <svg class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg> 进入网页 UI，即可进行开发工作。

网页 UI 的使用方法请参阅 [JupyterLab Documentation](https://jupyterlab.readthedocs.io/en/latest/) 或[它的中文版本](https://jupyterlab.pythonlang.cn/en/latest/)。

[TensorBoard 插件](https://github.com/HFAiLab/jupyterlab_tensorboard_pro)的使用方法请参阅[使用说明](https://github.com/HFAiLab/jupyterlab_tensorboard_pro/blob/v4.x/README.zh-cn.md#%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E)。

## 配置

### 示例

选用 PyTorch 环境，申请 16 个 CPU（核心）、32 GiB 内存资源以及 1 个燧原 GCU，挂载存储卷 `tutorial`：

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

# nodeSelector:
#   key1: value1
#   key2: value2

# ssh:
#   enabled: true
#   authorizedKeys:
#   - "secret-name"
ssh:
  authorizedKeys: []
  enabled: false
  serviceType: ClusterIP
```

### 字段

| 名称                 | 描述                                                          | 值             |
| -------------------- | ------------------------------------------------------------- | -------------- |
| `image.registry`     | JupyterLab 容器镜像注册表。                                   | `""`           |
| `image.repository`   | JupyterLab 容器镜像仓库。                                     | `""`           |
| `image.tag`          | JupyterLab 容器镜像标签。                                     | `""`           |
| `image.pullPolicy`   | JupyterLab 容器镜像拉取策略。                                 | `IfNotPresent` |
| `resources.cpu`      | JupyterLab 最多能使用的 CPU 数量。                            | `16`           |
| `resources.memory`   | JupyterLab 最多能使用的内存数量。                             | `32Gi`         |
| `resources.gcu`      | JupyterLab 最多能使用的燧原 GCU 数量。                        | `1`            |
| `pvc`                | 挂载到 JupyterLab 上的 PVC 名称，作为 JupyterLab 的工作空间。 | `""`           |
| `ssh.authorizedKeys` | 一系列记录 SSH 公钥的 K8s Secret 资源。                       | `[]`           |
| `ssh.enabled`        | 是否在 Notebook 上启动 SSH 服务。                             | `false`        |
| `ssh.serviceType`    | SSH 服务类型，支持 ClusterIP 和 NodePort 两种。               | `ClusterIP`    |
| `nodeSelector`       | 用于选择节点，JupyterLab 只会被调度到标签与之匹配的节点上。   | `null`         |

### 镜像列表

当前应用可以选用以下镜像：

| 名称     | 环境      |
| -------- | --------- |
| （暂缺） | PyTorch 2 |
