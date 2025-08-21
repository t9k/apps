# Job Manager

用于管理 T9k Job 的控制台，通过直观的界面方便用户创建 Job、查看 Job 的详细信息以及监控计算资源的使用情况。

## 镜像构建

Job Manager 应用需要构建以下镜像：

- `job-manager-server`: 后端服务镜像，在私有的 gitlab 仓库 `products` 中，根据 `discrete-images/filebrowser` 目录中的说明进行构建。
- `job-manager-web`: 前端界面镜像，在私有的 gitlab 仓库 `products` 中，根据 `discrete-images/filebrowser` 目录中的说明进行构建。
