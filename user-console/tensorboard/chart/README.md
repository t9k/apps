# TensorBoard

TensorBoard 是 TensorFlow 的可视化工具，它可以展示你的 TensorFlow 网络模型（以及其他框架的模型）训练过程中的各种可视化数据。

## 使用方法

待应用就绪后，点击右侧的 <span class="twemoji"><svg class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg></span> 进入网页 UI，查看可视化数据。

![](https://s2.loli.net/2024/08/21/b3e4S2unxrCfydq.png)

对于 TensorFlow 框架，记录各种类型数据和使用网页 UI 的方法请参阅 <a target="_blank" rel="noopener noreferrer" href="https://www.tensorflow.org/tensorboard/get_started?hl=zh-cn">TensorBoard 指南</a>。

对于 PyTorch 框架，记录各种类型数据和使用网页 UI 的方法请参阅：

* <a target="_blank" rel="noopener noreferrer" href="https://pytorch.org/docs/stable/tensorboard.html">torch.utils.tensorboard</a> 文档
* <a target="_blank" rel="noopener noreferrer" href="https://pytorch.org/tutorials/intermediate/tensorboard_tutorial.html">Visualizing models, data, and training with TensorBoard</a> 教程
* <a target="_blank" rel="noopener noreferrer" href="https://pytorch.org/tutorials/intermediate/tensorboard_profiler_tutorial.html">PyTorch Profiler With TensorBoard</a> 教程

## 配置

### 说明

如使用 PVC 作为 TensorBoard 数据源，将 `spec.logDir.pvc[0].name` 和 `spec.logDir.pvc[0].subPath` 字段的值分别修改为存储卷的名称和目录，位于该目录及其子目录下的所有 tfevents 文件都将被可视化展示。

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

### 字段

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
