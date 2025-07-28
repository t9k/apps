# Workflow

用于管理工作流的控制台，可执行创建工作流、查看运行状态等操作。

## 镜像构建

Workflow 应用需要构建一个镜像：

- `workflow-app`: 应用镜像

### 构建 workflow-app 镜像

在 `workflow-app` git 仓库中执行以下命令：

```bash
# 设置环境变量
export VERSION=250423
export IMAGE_PREFIX=tsz.io/t9k

# 构建 AMD64 架构镜像
[~/repos/workflow-app]$ ./repo/workflows/docker-build-app.sh --arch amd64 -t ${VERSION}-amd64

# 构建 ARM64 架构镜像
[~/repos/workflow-app]$ ./repo/workflows/docker-build-app.sh --arch arm64 -t ${VERSION}-arm64

# 创建多架构镜像清单
docker manifest create ${IMAGE_PREFIX}/workflow-app:${VERSION} \
    ${IMAGE_PREFIX}/workflow-app:${VERSION}-amd64 \
    ${IMAGE_PREFIX}/workflow-app:${VERSION}-arm64

# 推送镜像清单
docker manifest push ${IMAGE_PREFIX}/workflow-app:${VERSION}
```

### 镜像说明

- **镜像前缀**: 通过 `IMAGE_PREFIX` 环境变量配置（默认: `tsz.io/t9k`）
- **支持架构**: AMD64, ARM64
- **版本号**: 通过 `VERSION` 环境变量配置，建议使用日期格式（如 `250423` 表示 2025年4月23日）
- **依赖仓库**:
  - `workflow-app`: 应用代码仓库

### 环境变量

| 变量名 | 描述 | 示例值 |
|--------|------|--------|
| `VERSION` | 镜像版本号 | `250423` |
| `IMAGE_PREFIX` | 镜像仓库前缀 | `tsz.io/t9k` |

### 注意事项

1. 构建前确保已经克隆了 `workflow-app` git 仓库
2. 确保 Docker 客户端已登录到镜像仓库（通过 `IMAGE_PREFIX` 指定）
3. 根据实际发布日期和目标仓库调整环境变量值
4. 构建脚本为 `docker-build-app.sh`，不同于其他应用的 `docker-build-common.sh`
