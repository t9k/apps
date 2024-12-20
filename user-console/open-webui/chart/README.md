# Open WebUI

[Open WebUI](https://www.openwebui.com/) 是一个可扩展、功能丰富且用户友好的自托管 WebUI，旨在完全离线运行。它支持各种 LLM 运行器，包括 Ollama 和兼容 OpenAI 的 API。

当前应用的 Helm Chart 修改自 [open-webui/helm-charts](https://github.com/open-webui/helm-charts)。

## 使用方法

待应用就绪后，点击右侧的 <svg width="1em" height="1em" class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg> 进入网页 UI，即可开始聊天。

![](https://s2.loli.net/2024/08/22/Gdx9rCv7B3wjShf.png)

网页 UI 的使用方法比较简单直观，请用户自行尝试。网页 UI 的高级用法请参阅 [Tutorial](https://docs.openwebui.com/category/-tutorial)。Pipelines 插件的使用方法可以参阅 [Getting Started with OpenWebUI Pipelines](https://ikasten.io/2024/06/03/getting-started-with-openwebui-pipelines/)。

## 使用说明

* 应用数据全部存储在随应用创建的 PVC `app-open-webui-xxxxxx` 中，包括聊天记录、上传的文件、工具模型（文本嵌入模型等）、向量数据等。

* 默认的 PVC 大小为 2 GiB，请根据应用的使用规模进行适当的调整。另外，该 PVC 在创建完成后也可以进行扩容（取决于存储后端是否支持）。

* 首个注册的用户将自动成为应用的管理员，后续注册的用户需要由管理员手动激活（或者由管理员修改默认用户角色）。只有管理员可以进入管理员面板，修改外部连接、模型、Pipelines、数据库等关键设置。

## 配置

### 基本配置

考虑两种情况：

1. 如果你想要让当前应用调用已有的 Ollama API 服务端点（Ollama 应用的推理服务），将 `ollamaUrls` 字段的值设为包含该服务端点（需要添加 `http://` 前缀）的列表。

2. 如果你想要让当前应用部署一个新的 Ollama 服务，将 `ollama.enabled` 字段的值设为 `true`，并参照 Ollama 应用的 README 修改 `ollama` 字段的其余子字段。

需要说明的是，1. 和 2. 并不矛盾，可以同时设置。

### 示例

应用本身申请 1 个 CPU（核心）和 2 GiB 内存资源，创建一个大小 2 GiB 的 PVC 以持久化应用数据；部署一个新的 Ollama 服务，其申请 1 个 CPU（核心）、16 GiB 内存资源以及 1 个 NVIDIA GPU，创建一个大小 30GiB 的 PVC 以存储 Ollama 服务器数据，启动时拉取两个模型；启用 Pipelines：

```yaml
image:
  registry: docker.io
  repository: t9kpublic/open-webui
  tag: "git-96c8654"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 1
    memory: 2Gi

persistence:
  storageClass: ""
  size: 2Gi
  accessModes:
    - ReadWriteOnce
  existingClaim: ""

ollama:
  enabled: true

  ollama:
    gpu:
      enabled: true
      type: 'nvidia'
      number: 1
    models:
     - llama3.1
     - qwen2

  resources:
    requests:
      cpu: 1
      memory: 8Gi
    limits:
      cpu: 1
      memory: 16Gi

  persistentVolume:
    enabled: true
    size: 30Gi

ollamaUrls: []

pipelines:
  enabled: true
  extraEnvVars: []

env: []
```

调用已有的 Ollama API 服务端点；禁用 Pipelines：

```yaml
image:
  registry: docker.io
  repository: t9kpublic/open-webui
  tag: "git-96c8654"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 1
    memory: 2Gi

persistence:
  size: 2Gi
  storageClass: ""
  accessModes:
    - ReadWriteOnce
  existingClaim: ""

ollama:
  enabled: false

  ollama:
    gpu:
      enabled: true
      type: 'nvidia'
      number: 1
    models: []

  resources:
    requests:
      cpu: 1
      memory: 8Gi
    limits:
      cpu: 1
      memory: 16Gi

  persistentVolume:
    enabled: true
    size: 30Gi

ollamaUrls: ["http://<OLLAMA_ENDPOINT>"]  # 安装 Ollama 应用，查看其应用信息以获取服务端点

pipelines:
  enabled: false
  extraEnvVars: []

env: []
```

### 字段

| 名称                        | 描述                                                                                                                                               | 值                      |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `image.registry`            | Open WebUI 镜像注册表                                                                                                                              | `docker.io`               |
| `image.repository`          | Open WebUI 镜像仓库                                                                                                                                | `t9kpublic/open-webui` |
| `image.tag`                 | Open WebUI 镜像标签                                                                                                                                | `git-96c8654`           |
| `image.pullPolicy`          | Open WebUI 镜像拉取策略                                                                                                                            | `IfNotPresent`          |
| `resources.limits.cpu`      | Open WebUI 容器能使用的 CPU 上限                                                                                                                   | `1`                     |
| `resources.limits.memory`   | Open WebUI 容器能使用的内存上限                                                                                                                    | `2Gi`                   |
| `persistence.size`          | PVC 的大小                                                                                                                                         | `2Gi`                   |
| `persistence.storageClass`  | PVC 的存储类型                                                                                                                                     | `""`                    |
| `persistence.accessModes`   | PVC 的访问模式，多个副本时需使用 `ReadWriteMany`                                                                                                   | `["ReadWriteOnce"]`     |
| `persistence.existingClaim` | 使用的现有 PVC 的名称                                                                                                                                | `""`                    |
| `ollama.enabled`            | 是否从 https://otwld.github.io/ollama-helm/ 安装 Ollama Helm chart，使用 [Helm Values](https://github.com/otwld/ollama-helm/#helm-values) 进行配置 | `true`                  |
| `ollama.*`                  | 请参考 [Helm Values](https://github.com/otwld/ollama-helm/#helm-values) 或 Ollama 应用的参数                                                       |                         |
| `ollamaUrls`                | Ollama API 服务端点列表。注意服务端点需要添加 `http://` 前缀                                                                                       | `[]`                    |
| `ollama.image.registry`            | Ollama 镜像注册表                                                                                                                              | `docker.io`               |
| `ollama.image.repository`          | Ollama 镜像仓库                                                                                                                                | `t9kpublic/ollama` |
| `ollama.image.tag`                 | Ollama 镜像标签                                                                                                                                | `0.3.6`           |
| `ollama.image.pullPolicy`          | Ollama 镜像拉取策略                                                                                                                            | `IfNotPresent`          |
| `ollama.resources.limits.cpu`      | Ollama 容器能使用的 CPU 上限                                                                                                                   | `2`                     |
| `ollama.resources.limits.memory`   | Ollama 容器能使用的内存上限                                                                                                                    | `16Gi`                   |
| `pipelines.enabled`         | 是否安装 Pipelines chart 以使用 Pipelines 扩展 Open WebUI 功能：https://github.com/open-webui/pipelines                                            | `true`                  |
| `pipelines.extraEnvVars`    | Pipelines 的额外的环境变量数组                                                                                                                     | `[]`                    |
| `pipelines.image.registry`            | Pipelines 镜像注册表                                                                                                                              | `docker.io`               |
| `pipelines.image.repository`          | Pipelines 镜像仓库                                                                                                                                | `t9kpublic/pipelines` |
| `pipelines.image.tag`                 | Pipelines 镜像标签                                                                                                                                | `main`           |
| `pipelines.image.pullPolicy`          | Pipelines 镜像拉取策略                                                                                                                            | `IfNotPresent`          |
| `pipelines.resources.limits.cpu`      | Pipelines 容器能使用的 CPU 上限                                                                                                                   | `4`                     |
| `pipelines.resources.limits.memory`   | Pipelines 容器能使用的内存上限                                                                                                                    | `8Gi`                   |
| `env`                       | 额外的环境变量数组                                                                                                                                 | `[]`                    |
