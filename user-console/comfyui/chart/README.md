# ComfyUI

[ComfyUI](https://github.com/comfyanonymous/ComfyUI) 是一个专为 Stable Diffusion 设计的基于节点的网页 UI。它通过将不同的块（称为节点）链接在一起，使用户能够构建复杂的图像生成工作流程，这些节点可以包括加载检查点模型、输入提示、指定采样器等各种任务。

与常见的网页 UI 相比，ComfyUI 具有一些独特的特性。它的自由度和灵活性较高，支持高度定制化和工作流复用，对系统配置要求较低，并且能够加快原始图像的生成速度。但由于拥有众多插件节点和较为复杂的操作流程，学习门槛相对较高。

## 发布说明

### 1.0.1

新增 v0.3.27 版本的 ComfyUI，通过指定以下镜像：

| 镜像                                            | ComfyUI 版本 |
| ----------------------------------------------- | ------------ |
| `registry.cn-hangzhou.aliyuncs.com/t9k:v0.3.27` | v0.3.27      |

新增验证的主要功能包括：

* （视频生成）

### 1.0.0

全新的 ComfyUI 应用，允许用户使用 v0.2.7 或 v0.2.3 版本的 ComfyUI，通过指定以下镜像：

| 镜像                                           | ComfyUI 版本 |
| ---------------------------------------------- | ------------ |
| `registry.cn-hangzhou.aliyuncs.com/t9k:v0.2.7` | v0.2.7       |
| `registry.cn-hangzhou.aliyuncs.com/t9k:v0.2.3` | v0.2.3       |

应用理论上兼容 ComfyUI 的所有[功能特性](https://github.com/comfyanonymous/ComfyUI?tab=readme-ov-file#features)，覆盖了几乎所有 AI 绘图相关的使用场景。目前已验证的主要功能包括：

* 支持 Stable Diffusion 1.x、Stable Diffusion 2.x、[SDXL](https://comfyanonymous.github.io/ComfyUI_examples/sdxl/) 和 [Stable Diffusion 3.5](https://comfyanonymous.github.io/ComfyUI_examples/sd3/)
* 支持 [Stable Video Diffusion](https://comfyanonymous.github.io/ComfyUI_examples/video/)
* 支持 [Flux](https://comfyanonymous.github.io/ComfyUI_examples/flux/)
* 支持 [LoRA](https://comfyanonymous.github.io/ComfyUI_examples/lora/)
* 支持 [Hypernetwork](https://comfyanonymous.github.io/ComfyUI_examples/hypernetworks/)
* 支持[放大模型（Upscale Model）](https://comfyanonymous.github.io/ComfyUI_examples/upscale_models/)
* 支持 [ControlNet](https://comfyanonymous.github.io/ComfyUI_examples/upscale_models/)
* [图生图（Img2Img）](https://comfyanonymous.github.io/ComfyUI_examples/img2img/)
* [内补绘制（Inpainting）和外补绘制（Outpainting）](https://comfyanonymous.github.io/ComfyUI_examples/inpaint/)

## 使用方法

待应用就绪后，点击右侧的 <svg width="1em" height="1em" class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg> 进入网页 UI，即可开始编辑和执行 Stable Diffusion 工作流。

![](https://s2.loli.net/2024/11/12/DKeA4mh7wVI1sXB.png)

网页 UI 的使用方法请参阅 [ComfyUI Documentation](https://docs.comfy.org/get_started/introduction) 或 [ComfyUI 用户手册](https://comfyuidoc.com/zh/)。

## 使用说明

* 网页 UI 所加载的模型文件全部存储在随应用创建（或用户指定）的 PVC `app-comfyui-xxxxxx` 的 `ComfyUI/models` 目录下，已有的模型文件为镜像自带。你可以通过以下方法管理模型文件：

    1. （需要设置 HTTP(s) 代理）使用 [ComfyUI 管理器](https://github.com/ltdrdata/ComfyUI-Manager)的**模型管理**安装某些模型（下载相应的模型文件）：

    ![](https://s2.loli.net/2024/11/12/r7NQMeVpxmsYFID.png)

    2. 安装挂载该 PVC 的 JupyterLab 或 Code Server 应用，向 `ComfyUI/models` 目录下载更多的模型文件或删除已有的模型文件。

    完成后按照提示点击 Refresh 按钮或刷新页面。

* 网页 UI 所加载的自定义节点全部存储在同一个 PVC 的 `ComfyUI/custom_nodes` 目录下。你可以通过以下方法管理自定义节点文件：

    1. （需要设置 HTTP(s) 代理）使用 [ComfyUI 管理器](https://github.com/ltdrdata/ComfyUI-Manager)的**节点管理**安装自定义节点：

    ![](https://s2.loli.net/2024/11/12/XlwZ15ob42IPz7g.png)

    2. 安装挂载该 PVC 的 JupyterLab 或 Code Server 应用，在 `ComfyUI/custom_nodes` 目录中克隆自定义节点的 Git 仓库或删除已有的自定义节点。

    完成后按照提示点击 Refresh 按钮或刷新页面。

* 生成的图像文件存储在同一个 PVC 的 `ComfyUI/outputs` 目录下，你可以在这里查看已生成的图片。

* 默认的 PVC 大小为 64 GiB，请根据要下载的模型文件的总大小以及要生成的图像文件的总大小进行适当的调整。此外，该 PVC 在创建完成后也可以进行扩容（取决于存储后端是否支持）。

## 配置

### 示例

默认配置：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/comfyui"
  tag: "v0.3.27"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 4
    memory: 64Gi
    nvidia.com/gpu: 1

persistence:
  size: 64Gi
  storageClass: ""
  accessModes:
  - ReadWriteOnce
  existingClaim: ""

env: []
```

### 字段

| 名称                                | 描述                                 | 值                                   |
| ----------------------------------- | ------------------------------------ | ------------------------------------ |
| `image.registry`                    | ComfyUI 镜像注册表                   | `$(T9K_APP_IMAGE_REGISTRY)`          |
| `image.repository`                  | ComfyUI 镜像仓库                     | `$(T9K_APP_IMAGE_NAMESPACE)/comfyui` |
| `image.tag`                         | ComfyUI 镜像标签                     | `v0.3.27`                            |
| `image.pullPolicy`                  | ComfyUI 镜像拉取策略                 | `IfNotPresent`                       |
| `resources.limits.cpu`              | ComfyUI 容器能使用的 CPU 上限        | `4`                                  |
| `resources.limits.memory`           | ComfyUI 容器能使用的内存上限         | `64Gi`                               |
| `resources.limits."nvidia.com/gpu"` | ComfyUI 容器能使用的 NVIDIA GPU 上限 | `1`                                  |
| `persistence.size`                  | PVC 的大小                           | `64Gi`                               |
| `persistence.storageClass`          | PVC 的存储类型                       | ``                                   |
| `persistence.accessModes`           | PVC 的访问模式                       | `["ReadWriteOnce"]`                  |
| `persistence.existingClaim`         | 使用的现有 PVC 的名称                | ``                                   |
| `env`                               | 额外的环境变量数组                   | `[]`                                 |

### 镜像列表

当前应用可以选用以下镜像：

| 镜像                                           | ComfyUI 版本 |
| ---------------------------------------------- | ------------ |
| `registry.cn-hangzhou.aliyuncs.com/t9k:v0.3.27` | v0.3.27       |
| `registry.cn-hangzhou.aliyuncs.com/t9k:v0.2.7` | v0.2.7       |
| `registry.cn-hangzhou.aliyuncs.com/t9k:v0.2.3` | v0.2.3       |
