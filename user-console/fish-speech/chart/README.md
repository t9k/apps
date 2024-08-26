# Fish Speech

[Fish Speech](https://github.com/fishaudio/fish-speech) 是一套全新的 TTS 解决方案，包括模型、微调工具和推理工具。Fish Speech v1.2 模型在 30 万小时的英语、汉语和日语音频数据上训练，实现了接近人类水平的语音合成效果。

Fish Speech 的优势包括：

* 显存需求低（仅需 4GB），推理速度快
* 无需微调，快速克隆音色
* 提供网页 UI

## 使用方法

待应用就绪后，按照应用信息的指引进入网页 UI，即可开始生成想要的语音：

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

| 名称                                | 描述                              | 值                      |
| ----------------------------------- | --------------------------------- | ----------------------- |
| `image.registry`                    | Docker 镜像的存储库               | `docker.io`             |
| `image.repository`                  | Docker 镜像的存储库名称           | `t9kpublic/fish-speech` |
| `image.tag`                         | Docker 镜像的标签                 | `v1.2`                  |
| `image.pullPolicy`                  | Docker 镜像的拉取策略             | `IfNotPresent`          |
| `service.type`                      | Kubernetes 服务的类型             | `ClusterIP`             |
| `service.port`                      | Kubernetes 服务的端口             | `7860`                  |
| `ingress.enabled`                   | 启用/禁用 Kubernetes Ingress      | `false`                 |
| `ingress.className`                 | Ingress 类名称                    | ``                      |
| `ingress.annotations`               | Kubernetes Ingress 注释           | `{}`                    |
| `ingress.hosts`                     | Kubernetes Ingress 的主机列表     | `[]`                    |
| `ingress.tls`                       | Kubernetes Ingress 的 TLS 配置    | `[]`                    |
| `resources.limits.cpu`              | Kubernetes 资源的 CPU 限制        | `1`                     |
| `resources.limits.memory`           | Kubernetes 资源的内存限制         | `4Gi`                   |
| `resources.limits."nvidia.com/gpu"` | Kubernetes 资源的 NVIDIA GPU 限制 | `1`                     |
