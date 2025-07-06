# 应用发布

[English](./release.md)

本文介绍[应用开发](./dev.md)完成后，如何在 TensorStack AI 平台中发布应用。需要发布的内容包括三类：

1. 对应的 [镜像](./dev.md#构建镜像)；
2. 对应的 [Helm Chart](./dev.md#开发-helm-chart)；
3. 对应的 [注册相关文件](./dev.md#发布-app)。

## 私有发布

如果开发的应用仅在自有环境（如私有化部署的 TensorStack AI 平台）使用，需要：

1. 将镜像上传至私有镜像仓库，例如内网部署的 [Harbor](https://goharbor.io/)；
2. 将 Helm Chart 上传至私有 Chart 仓库，例如内网部署的 [Harbor](https://goharbor.io/)；
3. 将 Apps [注册相关文件](./dev.md#发布-app) 保存好，例如上传至自有 Git 仓库。

## 公开发布

如果开发的应用希望更多用户使用、可在公网发布，需要：

1. 将镜像上传至公开镜像仓库，例如 DockerHub 或 TensorStack 提供的公开镜像仓库；
2. 将 Helm Chart 上传至公开 Chart 仓库，例如 DockerHub 或 TensorStack 提供的公开 Chart 仓库；
3. 将注册相关文件通过 Pull Request 提交给 [TensorStack GitHub 仓库](https://github.com/t9k/apps/pulls)。

注意：公开发布时，选择的 ”镜像/Chart 仓库” 时，需要考虑该仓库是不是可以高速、方便地被目标用户集群方便访问。
