# AutoGen Studio

[AutoGen](https://github.com/microsoft/autogen) 是一个用于创建多智能体 AI 应用的框架，这些应用可以自主运行或与人类协作。

[AutoGen Studio](https://github.com/microsoft/autogen/tree/main/python/packages/autogen-studio) 是一个基于 AutoGen 的 AI 应用程序（用户界面），旨在帮助您快速原型开发 AI 代理，赋予它们技能，将其组成工作流，并与它们交互以完成任务。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始构建 agent 以及工作流。

![](https://s2.loli.net/2025/01/24/emtYaSfuv4NxPG2.png)

网页 UI 的使用方法简单直观，请用户自行尝试。

## 配置

### 示例

默认配置:

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/autogen-studio"
  tag: "v0.4.3"
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 2
    memory: 4Gi
```

### 字段

| 名称                                | 描述                                        | 值                                   |
| ----------------------------------- | ------------------------------------------- | ------------------------------------ |
| `image.registry`                    | AutoGen Studio 镜像注册表                   | `$(T9K_APP_IMAGE_REGISTRY)`          |
| `image.repository`                  | AutoGen Studio 镜像仓库                     | `$(T9K_APP_IMAGE_NAMESPACE)/autogen` |
| `image.tag`                         | AutoGen Studio 镜像标签                     | `v0.4.3`                             |
| `image.pullPolicy`                  | AutoGen Studio 镜像拉取策略                 | `IfNotPresent`                       |
| `resources.limits.cpu`              | AutoGen Studio 容器能使用的 CPU 上限        | `2`                                  |
| `resources.limits.memory`           | AutoGen Studio 容器能使用的内存上限         | `4Gi`                                |
