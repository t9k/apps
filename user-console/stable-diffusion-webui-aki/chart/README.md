# Stable Diffusion Webui

[Stable Diffusion web UI](https://github.com/AUTOMATIC1111/stable-diffusion-webui) 是一个用于运行 Stable Diffusion 模型的 gradio 网页 UI。bilibili 用户 “秋葉 aaaki” 基于这一项目制作了[整合包](https://www.bilibili.com/video/BV1iM4y1y7oA/)。

## 使用方法

待应用就绪后，点击右侧的 <svg width="1em" height="1em" class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg> 进入网页 UI，即可开始生成想要的图片。

![](https://s2.loli.net/2024/06/18/DEvIuZPtmCdkcz7.png)

网页 UI 的使用方法请参阅 [Stable Diffusion WebUI 从入门到卸载](https://docs.qq.com/doc/p/4d05d5a8f1282662dd5b7e526ecfe8d8ecbcee17)。

## 使用说明

* 网页 UI 所加载的模型文件全部存储在随应用创建的 PVC `app-stable-diffusion-webui-aki-xxxxxxxx` 的 `models` 目录下，已有的模型文件为镜像自带。你可以安装挂载该 PVC 的 Terminal 或 JupyterLab 应用，向其中下载更多的模型文件或删除已有的模型文件，完成后在网页 UI 点击相应的刷新按钮：

    ![](https://s2.loli.net/2024/06/18/WRPoig1Uk59uF7B.png)

* 生成的图像文件存储在同一个 PVC 的 `outputs` 目录下，你可以在这里或网页 UI 的 Infinite image browsing 标签页查看已生成的图片。

* 默认的 PVC 大小为 32 GiB，请根据要下载的模型文件的总大小以及要生成的图像文件的总大小进行适当的调整。另外，该 PVC 在创建完成后也可以进行扩容。

## 配置

### 示例

默认配置：

```yaml
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

### 字段

| 名称                                | 描述                              | 值                                 |
| ----------------------------------- | --------------------------------- | ---------------------------------- |
| `image.registry`                    | Docker 镜像的存储库               | `docker.io`                        |
| `image.repository`                  | Docker 镜像的存储库名称           | `t9kpublic/stable-diffusion-webui` |
| `image.tag`                         | Docker 镜像的标签                 | `20240514`                         |
| `image.pullPolicy`                  | Docker 镜像的拉取策略             | `IfNotPresent`                     |
| `service.type`                      | Kubernetes 服务的类型             | `ClusterIP`                        |
| `service.port`                      | Kubernetes 服务的端口             | `7860`                             |
| `ingress.enabled`                   | 启用/禁用 Kubernetes Ingress      | `false`                            |
| `ingress.className`                 | Ingress 类名称                    | ``                                 |
| `ingress.annotations`               | Kubernetes Ingress 注释           | `{}`                               |
| `ingress.hosts`                     | Kubernetes Ingress 的主机列表     | `{}`                               |
| `ingress.tls`                       | Kubernetes Ingress 的 TLS 配置    | `[]`                               |
| `resources.limits.cpu`              | Kubernetes 资源的 CPU 限制        | `4`                                |
| `resources.limits.memory`           | Kubernetes 资源的内存限制         | `64Gi`                             |
| `resources.limits."nvidia.com/gpu"` | Kubernetes 资源的 NVIDIA GPU 限制 | `1`                                |
| `persistence.size`                  | 持久卷声明的大小                  | `32Gi`                             |
| `persistence.storageClass`          | 持久卷声明的存储类别              | ``                                 |
| `persistence.accessModes`           | 持久卷声明的访问模式              | `["ReadWriteOnce"]`                |
