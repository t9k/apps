# Open WebUI

[Open WebUI](https://www.openwebui.com/) 是一个可扩展、功能丰富且用户友好的自托管 WebUI，旨在完全离线运行。它支持各种 LLM 运行器，包括 Ollama 和兼容 OpenAI 的 API。

当前应用的 Helm Chart 修改自 [open-webui/helm-charts](https://github.com/open-webui/helm-charts)。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始聊天。

![](https://s2.loli.net/2024/08/22/Gdx9rCv7B3wjShf.png)

网页 UI 的使用方法比较简单直观，请用户自行尝试。网页 UI 的高级用法请参阅 [Tutorial](https://docs.openwebui.com/category/-tutorial)。Pipelines 插件的使用方法可以参阅 [Getting Started with OpenWebUI Pipelines](https://ikasten.io/2024/06/03/getting-started-with-openwebui-pipelines/)。

## 使用说明

* 应用数据全部存储在随应用创建的 PVC `app-open-webui-xxxxxx` 中，包括聊天记录、上传的文件、工具模型（文本嵌入模型等）、向量数据等。

* 默认的 PVC 大小为 2 GiB，请根据应用的使用规模进行适当的调整。另外，该 PVC 在创建完成后也可以进行扩容（取决于存储后端是否支持）。

* 首个注册的用户将自动成为应用的管理员，后续注册的用户需要由管理员手动激活（或者由管理员修改默认用户角色）。只有管理员可以进入管理员面板，修改外部连接、模型、Pipelines、数据库等关键设置。

## 配置

### 示例

默认配置：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/open-webui"
  tag: "v0.5.18"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 2
    memory: 4Gi

persistence:
  size: 2Gi
  storageClass: ""
  accessModes:
    - ReadWriteOnce
  existingClaim: ""

env: []
```

### 字段

| 名称                                | 描述                                                                                                    | 值                                      |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| `image.registry`                    | Open WebUI 镜像注册表                                                                                   | `$(T9K_APP_IMAGE_REGISTRY)`             |
| `image.repository`                  | Open WebUI 镜像仓库                                                                                     | `$(T9K_APP_IMAGE_NAMESPACE)/open-webui` |
| `image.tag`                         | Open WebUI 镜像标签                                                                                     | `v0.5.18`                               |
| `image.pullPolicy`                  | Open WebUI 镜像拉取策略                                                                                 | `IfNotPresent`                          |
| `resources.limits.cpu`              | Open WebUI 容器能使用的 CPU 上限                                                                        | `2`                                     |
| `resources.limits.memory`           | Open WebUI 容器能使用的内存上限                                                                         | `4Gi`                                   |
| `persistence.size`                  | PVC 的大小                                                                                              | `2Gi`                                   |
| `persistence.storageClass`          | PVC 的存储类型                                                                                          | `""`                                    |
| `persistence.accessModes`           | PVC 的访问模式，多个副本时需使用 `ReadWriteMany`                                                        | `["ReadWriteOnce"]`                     |
| `persistence.existingClaim`         | 使用的现有 PVC 的名称                                                                                   | `""`                                    |
| `pipelines.enabled`                 | 是否安装 Pipelines chart 以使用 Pipelines 扩展 Open WebUI 功能：https://github.com/open-webui/pipelines | `false`                                 |
| `pipelines.extraEnvVars`            | Pipelines 的额外的环境变量数组                                                                          | `[]`                                    |
| `pipelines.image.registry`          | Pipelines 镜像注册表                                                                                    | `docker.io`                             |
| `pipelines.image.repository`        | Pipelines 镜像仓库                                                                                      | `t9kpublic/pipelines`                   |
| `pipelines.image.tag`               | Pipelines 镜像标签                                                                                      | `main`                                  |
| `pipelines.image.pullPolicy`        | Pipelines 镜像拉取策略                                                                                  | `IfNotPresent`                          |
| `pipelines.resources.limits.cpu`    | Pipelines 容器能使用的 CPU 上限                                                                         | `4`                                     |
| `pipelines.resources.limits.memory` | Pipelines 容器能使用的内存上限                                                                          | `8Gi`                                   |
| `env`                               | 额外的环境变量数组                                                                                      | `[]`                                    |
