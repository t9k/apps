# Fish Speech

[Fish Speech](https://github.com/fishaudio/fish-speech) 是一套全新的 TTS 解决方案，包括模型、微调工具和推理工具。[Fish Speech v1.4](https://huggingface.co/fishaudio/fish-speech-1.4) 模型在 70 万小时的多语言音频数据上训练，实现了接近人类水平的语音合成效果。

Fish Speech 的优势包括：

* 显存需求低（仅需 4GB），推理速度快
* 无需微调，快速克隆音色
* 提供网页 UI

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始生成想要的语音。

![](https://s2.loli.net/2024/07/25/U1aswO2XAcpklZf.png)

网页 UI 的使用方法简单直观，请用户自行尝试。

## 配置

### 示例

默认配置：

```yaml
resources:
  limits:
    cpu: 1
    memory: 4Gi
    nvidia.com/gpu: 1
```

### 字段

| 名称                                | 描述                                     | 值                                       |
| ----------------------------------- | ---------------------------------------- | ---------------------------------------- |
| `image.registry`                    | Fish Speech 镜像注册表                   | `$(T9K_APP_IMAGE_REGISTRY)`              |
| `image.repository`                  | Fish Speech 镜像仓库                     | `$(T9K_APP_IMAGE_NAMESPACE)/fish-speech` |
| `image.tag`                         | Fish Speech 镜像标签                     | `v1.4.1`                                 |
| `image.pullPolicy`                  | Fish Speech 镜像拉取策略                 | `IfNotPresent`                           |
| `resources.limits.cpu`              | Fish Speech 容器能使用的 CPU 上限        | `16`                                     |
| `resources.limits.memory`           | Fish Speech 容器能使用的内存上限         | `32Gi`                                   |
| `resources.limits."nvidia.com/gpu"` | Fish Speech 容器能使用的 NVIDIA GPU 上限 | `1`                                      |
