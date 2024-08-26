# ComfyUI

[ComfyUI](https://github.com/comfyanonymous/ComfyUI) 是一个专为 Stable Diffusion 设计的基于节点的网页 UI。它通过将不同的块（称为节点）链接在一起，使用户能够构建复杂的图像生成工作流程，这些节点可以包括加载检查点模型、输入提示、指定采样器等各种任务。

与常见的网页 UI 相比，ComfyUI 具有一些独特的特性。它的自由度和灵活性较高，支持高度定制化和工作流复用，对系统配置要求较低，并且能够加快原始图像的生成速度。但由于拥有众多插件节点和较为复杂的操作流程，学习门槛相对较高。

## 使用方法

待应用就绪后，点击右侧的 <span class="twemoji"><svg class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg></span> 进入网页 UI，即可开始编辑和执行 Stable Diffusion 工作流：

![](https://s2.loli.net/2024/07/10/VzWlvONBkKPw5ZQ.png)

网页 UI 的使用方法请参阅 [JupyterLab Documentation](https://jupyterlab.readthedocs.io/en/latest/) 或[它的中文版本](https://jupyterlab.pythonlang.cn/en/latest/)。

## 使用说明

* 网页 UI 所加载的模型文件全部存储在随应用创建的 PVC `app-comfyui-xxxxxxxx` 的 `ComfyUI/models` 目录下，已有的模型文件为镜像自带。你可以通过以下方法管理模型文件：

    1. （需要设置 HTTP(s) 代理）使用 [ComfyUI Manager](https://github.com/ltdrdata/ComfyUI-Manager) 的 Model Manager 安装某些模型（下载相应的模型文件）：

    ![](https://s2.loli.net/2024/07/10/DvTKXVr8fG72Rs5.png)

    2. 安装挂载该存储卷的 Terminal 或 JupyterLab 应用，向 `ComfyUI/models` 目录下载更多的模型文件或删除已有的模型文件。

    完成后按照提示点击 Refresh 按钮或刷新页面。

* 网页 UI 所加载的自定义节点全部存储在同一个存储卷的 `ComfyUI/custom_nodes` 目录下。你可以通过以下方法管理自定义节点文件：

    1. （需要设置 HTTP(s) 代理）使用 [ComfyUI Manager](https://github.com/ltdrdata/ComfyUI-Manager) 的 Custom Nodes Manager 安装自定义节点：

    ![](https://s2.loli.net/2024/07/10/E2le5vDQJCt7HmI.png)

    2. 安装挂载该存储卷的 Terminal 或 JupyterLab 应用，在 `ComfyUI/custom_nodes` 目录中克隆自定义节点的 Git 仓库或删除已有的自定义节点。

    完成后按照提示点击 Refresh 按钮或刷新页面。

* 生成的图像文件存储在同一个存储卷的 `ComfyUI/outputs` 目录下，你可以在这里查看已生成的图片。

* 默认的存储卷大小为 32 GiB，请根据要下载的模型文件的总大小以及要生成的图像文件的总大小进行适当的调整。此外，该存储卷在创建完成后也可以进行扩容。

## 配置

### 示例

默认配置：

```yaml
persistence:
  size: 32Gi

env: []
```

### 字段

| 名称                                | 描述                              | 值                  |
| ----------------------------------- | --------------------------------- | ------------------- |
| `image.registry`                    | Docker 镜像的存储库               | `docker.io`         |
| `image.repository`                  | Docker 镜像的存储库名称           | `t9kpublic/comfyui` |
| `image.tag`                         | Docker 镜像的标签                 | `20240709`          |
| `image.pullPolicy`                  | Docker 镜像的拉取策略             | `IfNotPresent`      |
| `service.type`                      | Kubernetes 服务的类型             | `ClusterIP`         |
| `service.port`                      | Kubernetes 服务的端口             | `8188`              |
| `ingress.enabled`                   | 启用/禁用 Kubernetes Ingress      | `false`             |
| `ingress.className`                 | Ingress 类名称                    | ``                  |
| `ingress.annotations`               | Kubernetes Ingress 注释           | `{}`                |
| `ingress.hosts`                     | Kubernetes Ingress 的主机列表     | `{}`                |
| `ingress.tls`                       | Kubernetes Ingress 的 TLS 配置    | `[]`                |
| `resources.limits.cpu`              | Kubernetes 资源的 CPU 限制        | `4`                 |
| `resources.limits.memory`           | Kubernetes 资源的内存限制         | `64Gi`              |
| `resources.limits."nvidia.com/gpu"` | Kubernetes 资源的 NVIDIA GPU 限制 | `1`                 |
| `persistence.size`                  | 持久卷声明的大小                  | `32Gi`              |
| `persistence.storageClass`          | 持久卷声明的存储类别              | ``                  |
| `persistence.accessModes`           | 持久卷声明的访问模式              | `["ReadWriteOnce"]` |
