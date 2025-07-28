# Service Manager

用于管理推理服务的控制台，可执行创建服务、查看服务状态、监控服务事件等操作。

## 镜像构建

Service Manager 应用需要构建一个镜像：

- `service-manager-web`: 前端界面镜像

### 构建 service-manager-web 镜像

在 `mdeploy-web` git 仓库中执行以下命令：

```bash
# 设置环境变量
export VERSION=250423
export IMAGE_PREFIX=tsz.io/t9k

# 构建 ARM64 架构镜像
[~/repos/mdeploy-web]$ ./repo/workflows/docker-build-common.sh --arch arm64 -t ${VERSION}-arm64
[~/repos/mdeploy-web]$ docker tag ${IMAGE_PREFIX}/mdeploy-web:${VERSION}-arm64 ${IMAGE_PREFIX}/service-manager-web:${VERSION}-arm64
[~/repos/mdeploy-web]$ docker push ${IMAGE_PREFIX}/service-manager-web:${VERSION}-arm64

# 构建 AMD64 架构镜像
[~/repos/mdeploy-web]$ ./repo/workflows/docker-build-common.sh --arch amd64 -t ${VERSION}-amd64
[~/repos/mdeploy-web]$ docker tag ${IMAGE_PREFIX}/mdeploy-web:${VERSION}-amd64 ${IMAGE_PREFIX}/service-manager-web:${VERSION}-amd64
[~/repos/mdeploy-web]$ docker push ${IMAGE_PREFIX}/service-manager-web:${VERSION}-amd64

# 创建多架构镜像清单
docker manifest create ${IMAGE_PREFIX}/service-manager-web:${VERSION} \
    ${IMAGE_PREFIX}/service-manager-web:${VERSION}-amd64 \
    ${IMAGE_PREFIX}/service-manager-web:${VERSION}-arm64

# 推送镜像清单
docker manifest push ${IMAGE_PREFIX}/service-manager-web:${VERSION}
```

### 镜像说明

- **镜像前缀**: 通过 `IMAGE_PREFIX` 环境变量配置（默认: `tsz.io/t9k`）
- **支持架构**: AMD64, ARM64
- **版本号**: 通过 `VERSION` 环境变量配置，建议使用日期格式（如 `250423` 表示 2025年4月23日）
- **依赖仓库**:
  - `mdeploy-web`: 前端界面代码仓库（构建后重新标记为 `service-manager-web`）

### 环境变量

| 变量名 | 描述 | 示例值 |
|--------|------|--------|
| `VERSION` | 镜像版本号 | `250423` |
| `IMAGE_PREFIX` | 镜像仓库前缀 | `tsz.io/t9k` |


### 注意事项

1. 构建前确保已经克隆了 `mdeploy-web` git 仓库
2. 确保 Docker 客户端已登录到镜像仓库（通过 `IMAGE_PREFIX` 指定）
3. 根据实际发布日期和目标仓库调整环境变量值
4. 注意镜像重命名步骤：从 `mdeploy-web` 标记为 `service-manager-web`
