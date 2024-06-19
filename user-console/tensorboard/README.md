# TensorBoard

TensorBoard 是 TensorFlow 的可视化工具，它可以展示你的 TensorFlow 网络模型运行过程中的各种可视化数据。

## 使用方法

部署当前应用，将 `spec.logDir.pvc[0].name` 和 `spec.logDir.pvc[0].subPath` 字段的值分别修改为存储卷的名称和目录，位于该目录及其子目录下的所有 tfevents 文件都将被可视化展示。

## 配置

### 示例

可视化展示存储卷 `tutorial` 的 `train/logs` 目录下的 tfevents 文件。

```yaml
apiVersion: tensorstack.dev/v1beta1
kind: TensorBoard
metadata:
  name: "<would-be-auto-generated-and-DO-NOT-TOUCH-IT>"
spec:
  image: t9kpublic/tensorflow-2.11.0:cpu-sdk-0.5.2
  logDir:
    pvc:
      - name: "tutorial"
        subPath:
          - "train/logs"
  resources:
    limits:
      cpu: 100m
      memory: 200Mi
```

### 参数

| 名称                            | 描述                                                                                       | 值      |
| ------------------------------- | ------------------------------------------------------------------------------------------ | ------- |
| `spec.image`                    | TensorBoard 容器镜像。                                                                     | `""`    |
| `spec.logDir.pvc[@].name`       | 绑定一个 PVC 到 TensorBoard 上，让 TensorBoard 可以展示 PVC 中的数据。                     | `""`    |
| `spec.logDir.pvc[@].subPath`    | 指定 PVC 中需要被 TensorBoard 展示的文件路径。                                             | `[]`    |
| `spec.logDir.s3.secretRef.name` | 填入一个记录 S3 信息的 Secret 名称，TensorBoard 将用这个配置获得 S3 数据库中的数据并展示。 | `""`    |
| `spec.logDir.s3.uri`            | S3 数据标识符。                                                                            | `[]`    |
| `spec.resources.limits.cpu`     | TensorBoard 最多能使用的 CPU 数量。                                                        | `100m`  |
| `spec.resources.limits.memory`  | TensorBoard 最多能使用的内存数量。                                                         | `200Mi` |
