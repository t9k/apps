# TensorBoard

TensorBoard 是 TensorFlow 的可视化工具，它可以展示你的 TensorFlow 网络模型（以及其他框架的模型）训练过程中的各种可视化数据。

## 使用方法

待应用就绪后，点击右侧的 <svg width="1em" height="1em" class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg> 进入网页 UI，查看可视化数据。

![](https://s2.loli.net/2024/08/21/b3e4S2unxrCfydq.png)

对于 TensorFlow 框架，记录各种类型数据和使用网页 UI 的方法请参阅 <a target="_blank" rel="noopener noreferrer" href="https://www.tensorflow.org/tensorboard/get_started?hl=zh-cn">TensorBoard 指南</a>。

对于 PyTorch 框架，记录各种类型数据和使用网页 UI 的方法请参阅：

* <a target="_blank" rel="noopener noreferrer" href="https://pytorch.org/docs/stable/tensorboard.html">torch.utils.tensorboard</a>
* <a target="_blank" rel="noopener noreferrer" href="https://pytorch.org/tutorials/intermediate/tensorboard_tutorial.html">Visualizing models, data, and training with TensorBoard</a>
* <a target="_blank" rel="noopener noreferrer" href="https://pytorch.org/tutorials/intermediate/tensorboard_profiler_tutorial.html">PyTorch Profiler With TensorBoard</a>

## 配置

### 说明

App 支持 PVC 和 S3 两种数据源，配置时必须且只能选择其中一种。

如使用 PVC 作为数据源，将 `logDir.pvc[0].name` 和 `logDir.pvc[0].subPath` 字段的值分别设为 PVC 的名称和目录，位于该目录及其子目录下的所有 tfevents 文件都将被可视化展示。

如使用 S3 作为数据源，将 `logDir.s3️.secretRef.name` 字段的值设为 [S3-env 类型的 Secret](https://t9k.github.io/ucman/latest/guide/manage-storage-network-and-auxiliary/secret-s3.html) 的名称，将 `logDir.s3️.uri` 字段的值设为以 `/` 结尾的 S3 URL，所有以该 URL 作为前缀的 tfevents 文件都将被可视化展示。

### 示例

可视化展示存储卷 `tutorial` 的 `train/logs` 目录下的所有 tfevents 文件：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/tensorboard"
  tag: "2.17.0"
  pullPolicy: IfNotPresent

logDir:
  pvc:
    - name: tutorial
      subPath:
        - "train/logs"

resources:
  limits:
    cpu: 200m
    memory: 4Gi
```

可视化展示 URL 匹配 `s3://folder/**` 的所有 tfevents 文件，由 Secret my-s3-env 提供访问凭证：

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/tensorboard"
  tag: "2.17.0"
  pullPolicy: IfNotPresent

logDir:
  s3:
    secretRef:
      name: "my-s3-env"
    uri:
      - "s3://folder/"

resources:
  limits:
    cpu: 200m
    memory: 4Gi
```

### 字段

| 名称                       | 描述                                                                                                      | 值                                       |
| -------------------------- | --------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `image.registry`           | TensorBoard 镜像注册表                                                                                    | `$(T9K_APP_IMAGE_REGISTRY)`              |
| `image.repository`         | TensorBoard 镜像仓库                                                                                      | `$(T9K_APP_IMAGE_NAMESPACE)/tensorboard` |
| `image.tag`                | TensorBoard 镜像标签                                                                                      | `2.17.0`                                 |
| `image.pullPolicy`         | TensorBoard 镜像拉取策略                                                                                  | `IfNotPresent`                           |
| `logDir`                   | TensorBoard 数据源，支持 PVC 和 S3 两种数据源                                                             | `{}`                                     |
| `logDir.pvc`               | 使用 PVC 作为 TensorBoard 数据源                                                                          | `[]`                                     |
| `logDir.pvc[@].name`       | PVC 名称                                                                                                  | `""`                                     |
| `logDir.pvc[@].subPath`    | PVC 中数据地址，该地址为数据在 PVC 中的相对地址                                                           | `[]`                                     |
| `logDir.s3`                | 使用 S3 数据库作为 TensorBoard 数据源                                                                     | `{}`                                     |
| `logDir.s3.secretRef.name` | 一个记录 S3 URL、密钥等信息的 K8s Secret 的名称                                                           | `""`                                     |
| `logDir.s3.uri`            | S3 [folder](https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-folders.html) 的 uri，以 `/` 结尾 | `""`                                     |
| `resources.limits.cpu`     | TensorBoard 容器能使用的 CPU 上限                                                                         | `200m`                                   |
| `resources.limits.memory`  | TensorBoard 容器能使用的内存上限                                                                          | `4Gi`                                    |
