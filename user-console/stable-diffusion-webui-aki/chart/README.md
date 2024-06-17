# Stable Diffusion Webui

[Stable Diffusion web UI](https://github.com/AUTOMATIC1111/stable-diffusion-webui) 是一个用于运行 Stable Diffusion 模型的 gradio web UI。bilibili 用户 “秋葉 aaaki” 基于这一项目制作了[整合包](https://www.bilibili.com/video/BV1iM4y1y7oA/)。

## 配置

### 示例

```yaml
replicaCount: 1

image:
  registry: docker.io
  repository: t9kpublic/stable-diffusion-webui
  tag: "20240514"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 7860

ingress:
  enabled: false
  className: ""
  annotations: {}
  hosts: []
  tls: []

resources:
  limits:
    cpu: 4
    memory: 64Gi
    nvidia.com/gpu: 1

persistence:
  size: 32Gi
  storageClass: ""
  accessModes:
    - ReadWriteOnce
```

### 参数

| 名称                          | 描述                              | 值                                 |
| ----------------------------- | --------------------------------- | ---------------------------------- |
| `replicaCount`                | 副本数量                          | `1`                                |
| `image.registry`              | Docker 镜像的存储库               | `docker.io`                        |
| `image.repository`            | Docker 镜像的存储库名称           | `t9kpublic/stable-diffusion-webui` |
| `image.tag`                   | Docker 镜像的标签                 | `20240514`                         |
| `image.pullPolicy`            | Docker 镜像的拉取策略             | `IfNotPresent`                     |
| `service.type`                | Kubernetes 服务的类型             | `ClusterIP`                        |
| `service.port`                | Kubernetes 服务的端口             | `7860`                             |
| `ingress.enabled`             | 启用/禁用 Kubernetes Ingress      | `false`                            |
| `ingress.className`           | Ingress 类名称                    | ``                                 |
| `ingress.annotations`         | Kubernetes Ingress 注释           | `{}`                               |
| `ingress.hosts`               | Kubernetes Ingress 的主机列表     | `{}`                               |
| `ingress.tls`                 | Kubernetes Ingress 的 TLS 配置    | `[]`                               |
| `resources.limits.cpu`        | Kubernetes 资源的 CPU 限制        | `4`                                |
| `resources.limits.memory`     | Kubernetes 资源的内存限制         | `64Gi`                             |
| `resources.limits.nvidia-gpu` | Kubernetes 资源的 Nvidia GPU 限制 | `1`                                |
| `persistence.size`            | 持久卷声明的大小                  | `32Gi`                             |
| `persistence.storageClass`    | 持久卷声明的存储类别              | ``                                 |
| `persistence.accessModes`     | 持久卷声明的访问模式              | `["ReadWriteOnce"]`                |
