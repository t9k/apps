# TensorBoard

TensorBoard 是 TensorFlow 的可视化工具，它可以展示你的 TensorFlow 网络模型（以及其他框架的模型）运行过程中的各种可视化数据。

## 使用方法

部署当前应用，将 `logDir.pvc[0].name` 和 `logDir.pvc[0].subPath` 字段的值分别修改为存储卷的名称和目录，位于该目录及其子目录下的所有 tfevents 文件都将被可视化展示。

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
  memory: 4Gi
```

### 参数

| 名称                       | 描述                                                             | 值                            |
| -------------------------- | ---------------------------------------------------------------- | ----------------------------- |
| `image.registry`           | TensorBoard 容器镜像注册表。                                     | `docker.io`                   |
| `image.repository`         | TensorBoard 容器镜像仓库。                                       | `t9kpublic/tensorflow-2.11.0` |
| `image.tag`                | TensorBoard 容器镜像标签。                                       | `cpu-sdk-0.5.2`               |
| `image.pullPolicy`         | TensorBoard 容器镜像拉取策略。                                   | `IfNotPresent`                |
| `logDir`                   | TensorBoard 数据源，支持 PVC 和 S3 两种数据源。                  | `{}`                          |
| `logDir.pvc`               | 使用 PVC 作为 TensorBoard 数据源。                               | `[]`                          |
| `logDir.pvc[@].name`       | PVC 名称。                                                       | `""`                          |
| `logDir.pvc[@].subPath`    | PVC 中数据地址，该地址为数据在 PVC 中的相对地址。                | `[]`                          |
| `logDir.s3`                | 使用 S3 数据库作为 TensorBoard 数据源。                          | `{}`                          |
| `logDir.s3.secretRef.name` | 一个记录 S3 URL、密钥等信息的 K8s Secret 的名称。                | `""`                          |
| `logDir.s3.secretRef.uri`  | S3 数据库中数据对象的 uri，其格式为 `s3://<bucket>/<obj-path>`。 | `""`                          |
| `resources.cpu`            | TensorBoard 最多能使用的 CPU 数量。                              | `100m`                        |
| `resources.memory`         | TensorBoard 最多能使用的内存数量。                               | `4Gi`                         |
