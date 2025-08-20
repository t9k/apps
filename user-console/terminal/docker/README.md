# 镜像

## 镜像构建

Terminal 应用需要构建一个镜像：

- `terminal`: 应用镜像，在当前目录构建。

### 构建 terminal 镜像

在 `apps/user-console/terminal/docker` 目录中执行以下命令：

```bash
# 设置环境变量
export VERSION=250423
export IMAGE_PREFIX=tsz.io/t9k

# 构建 AMD64 架构镜像
[~/repos/apps/user-console/terminal/docker]$ docker build --platform linux/amd64 -f Dockerfile-amd64 . --tag ${IMAGE_PREFIX}/terminal:${VERSION}-amd64

# 构建 ARM64 架构镜像
[~/repos/apps/user-console/terminal/docker]$ docker build --platform linux/arm64 -f Dockerfile-arm64 . --tag ${IMAGE_PREFIX}/terminal:${VERSION}-arm64

# 推送镜像到仓库
docker push ${IMAGE_PREFIX}/terminal:${VERSION}-amd64 && docker push ${IMAGE_PREFIX}/terminal:${VERSION}-arm64

# 创建多架构镜像清单
docker manifest create ${IMAGE_PREFIX}/terminal:${VERSION} \
    ${IMAGE_PREFIX}/terminal:${VERSION}-amd64 \
    ${IMAGE_PREFIX}/terminal:${VERSION}-arm64

# 推送镜像清单
docker manifest push ${IMAGE_PREFIX}/terminal:${VERSION}
```

### 镜像说明

- **镜像前缀**: 通过 `IMAGE_PREFIX` 环境变量配置（默认: `tsz.io/t9k`）
- **支持架构**: AMD64, ARM64
- **版本号**: 通过 `VERSION` 环境变量配置，使用日期格式（如 `250423` 表示 2025年4月23日）

### 环境变量

| 变量名 | 描述 | 示例值 |
|--------|------|--------|
| `VERSION` | 镜像版本号 | `250423` |
| `IMAGE_PREFIX` | 镜像仓库前缀 | `tsz.io/t9k` |
