# TensorBoard

TensorBoard 是 TensorFlow 的可视化工具，它可以展示你的 TensorFlow 网络模型运行过程中的各种可视化数据。

## 使用方法

部署当前应用，将 `spec.logDir.pvc[0].name` 和 `spec.logDir.pvc[0].subPath` 字段的值分别修改为存储卷的名称和目录，位于该目录及其子目录下的所有 tfevents 文件都将被可视化展示。

## 配置

### 示例

可视化展示存储卷 `tutorial` 的 `train/logs` 目录下的 tfevents 文件。

```yaml
image:
  registry: docker.io
  repository: t9kpublic/tensorflow-2.11.0
  tag: "cpu-sdk-0.5.2"
  pullPolicy: IfNotPresent

logDir:
  pvc:
    - name: tutorial
      subPath:
        - "train/logs"
  # s3:
  #   secretRef:
  #     name: ""
  #   uri:
  #     - ""

resources:
  cpu: 100m
  memory: 200Mi
```

### 参数

| 名称               | 描述                                            | 值                            |
| ------------------ | ----------------------------------------------- | ----------------------------- |
| `image.registry`   | TensorBoard 容器镜像注册表。                    | `docker.io`                   |
| `image.repository` | TensorBoard 容器镜像仓库。                      | `t9kpublic/tensorflow-2.11.0` |
| `image.tag`        | TensorBoard 容器镜像标签。                      | `cpu-sdk-0.5.2`               |
| `image.pullPolicy` | TensorBoard 容器镜像拉取策略。                  | `IfNotPresent`                |
| `spec.logDir`      | TensorBoard 数据源，支持 PVC 和 S3 两种数据源。 | `{}`                          |
| `resources.cpu`    | TensorBoard 最多能使用的 CPU 数量。             | `100m`                        |
| `resources.memory` | TensorBoard 最多能使用的内存数量。              | `200Mi`                       |
