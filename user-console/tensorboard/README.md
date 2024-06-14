# TensorBoard

TensorBoard 是 TensorFlow 的可视化工具，它可以展示你的 TensorFlow 网络模型运行过程中的各种可视化数据。

## 配置

| name | description | value |
|------|-------------|-------|
| `spec.image` | TensorBoard 容器镜像。 | `""` | 
| `spec.logDir.pvc[@].name` | 绑定一个 PVC 到 TensorBoard 上，让 TensorBoard 可以展示 PVC 中的数据。 | `""` | 
| `spec.logDir.pvc[@].subPath` | 指定 PVC 中需要被 TensorBoard 展示的文件路径。 | `[]` | 
| `spec.logDir.s3.secretRef.name` | 填入一个记录 S3 信息的 Secret 名称，TensorBoard 将用这个配置获得 S3 数据库中的数据并展示。 | `""` | 
| `spec.logDir.s3.uri` | S3 数据标识符。 | `[]` | 
| `spec.resources.limits.cpu` | TensorBoard 最多能使用的 CPU 数量。 | `100m` | 
| `spec.resources.limits.memory` | TensorBoard 最多能使用的内存数量。 | `200Mi` | 
