# Fish Speech

[Fish Speech](https://github.com/fishaudio/fish-speech) 是一套全新的 TTS 解决方案，包括模型、微调工具和推理工具。[Fish Speech v1.5](https://huggingface.co/fishaudio/fish-speech-1.5) 模型在 100 万小时的多语言音频数据上训练，实现了接近人类水平的语音合成效果。

Fish Speech 的优势包括：

* **零样本 & 小样本 TTS**：输入 10 到 30 秒的声音样本即可生成高质量的 TTS 输出。
* **多语言 & 跨语言支持**：只需复制并粘贴多语言文本到输入框中，无需担心语言问题。目前支持英语、日语、韩语、中文、法语、德语、阿拉伯语和西班牙语。
* **无音素依赖**：模型具备强大的泛化能力，不依赖音素进行 TTS，能够处理任何文字表示的语言。
* **高准确率**：在 5 分钟的英文文本上，达到了约 2% 的 CER（字符错误率）和 WER（词错误率）。
* **快速**：通过 fish-tech 加速，在 Nvidia RTX 4060 笔记本上的实时因子约为 1:5，在 Nvidia RTX 4090 上约为 1:15。
* **WebUI 推理**：提供易于使用的基于 Gradio 的网页用户界面，兼容 Chrome、Firefox、Edge 等浏览器。

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始生成想要的语音。

![](https://s2.loli.net/2024/07/25/U1aswO2XAcpklZf.png)

网页 UI 的使用方法简单直观，请用户自行尝试。

## 配置

### 示例

默认配置：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/fish-speech"
  tag: "v1.5.0"
  pullPolicy: IfNotPresent

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
| `image.tag`                         | Fish Speech 镜像标签                     | `v1.5.0`                                 |
| `image.pullPolicy`                  | Fish Speech 镜像拉取策略                 | `IfNotPresent`                           |
| `resources.limits.cpu`              | Fish Speech 容器能使用的 CPU 上限        | `1`                                      |
| `resources.limits.memory`           | Fish Speech 容器能使用的内存上限         | `4Gi`                                    |
| `resources.limits."nvidia.com/gpu"` | Fish Speech 容器能使用的 NVIDIA GPU 上限 | `1`                                      |
