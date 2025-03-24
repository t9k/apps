# AnythingLLM

[AnythingLLM](https://github.com/Mintplex-Labs/anythingllm) 是一个全栈应用程序，您可以使用商用现成的 LLM 或流行的开源 LLM 及向量数据库解决方案，构建一个无需妥协的私有 ChatGPT。该应用既可以在本地运行，也可以远程托管，并能够智能地与您提供的任何文档进行对话。

AnythingLLM 将您的文档划分为称为“工作区”的对象。工作区的功能与线程非常相似，但增加了对文档的容器化处理。工作区之间可以共享文档，但它们彼此之间不会交流，从而确保每个工作区的上下文保持清晰独立。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始聊天。

![](https://s2.loli.net/2025/02/18/ytMnhIxejA2CNRa.png)

网页 UI 的使用方法简单直观，请用户自行尝试。

## 配置

### 示例

默认配置:

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/anythingllm"
  tag: "1.7.6"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 4
    memory: 8Gi

storage:
  size: 10Gi
```

### 字段

| 名称                      | 描述                              | 值                                       |
| ------------------------- | --------------------------------- | ---------------------------------------- |
| `image.registry`          | AnythingLLM 镜像注册表            | `$(T9K_APP_IMAGE_REGISTRY)`              |
| `image.repository`        | AnythingLLM 镜像仓库              | `$(T9K_APP_IMAGE_NAMESPACE)/anythingllm` |
| `image.tag`               | AnythingLLM 镜像标签              | `1.7.6`                                  |
| `image.pullPolicy`        | AnythingLLM 镜像拉取策略          | `IfNotPresent`                           |
| `resources.limits.cpu`    | AnythingLLM 容器能使用的 CPU 上限 | `4`                                      |
| `resources.limits.memory` | AnythingLLM 容器能使用的内存上限  | `8Gi`                                    |
| `storage.size`            | AnythingLLM 容器能使用的存储大小  | `10Gi`                                   |
