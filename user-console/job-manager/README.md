# Job Manager

用于管理 T9k Job 的控制台，通过直观的界面方便用户创建 Job、查看 Job 的详细信息以及监控计算资源的使用情况。

## 镜像构建

Job Manager 应用需要构建两个镜像：

- `job-manager-server`: 后端服务镜像
- `job-manager-web`: 前端界面镜像

### 构建 job-manager-server 镜像

在 `job-manager-server` git 仓库中执行以下命令：

```bash
# 设置环境变量
export VERSION=250423
export IMAGE_PREFIX=tsz.io/t9k

# 构建 ARM64 架构镜像
[~/repos/job-manager-server]$ ./repo/workflows/docker-build-common.sh --arch arm64 -t ${VERSION}-arm64

# 构建 AMD64 架构镜像
[~/repos/job-manager-server]$ ./repo/workflows/docker-build-common.sh --arch amd64 -t ${VERSION}-amd64

# 创建多架构镜像清单
docker manifest create ${IMAGE_PREFIX}/job-manager-server:${VERSION} \
    ${IMAGE_PREFIX}/job-manager-server:${VERSION}-amd64 \
    ${IMAGE_PREFIX}/job-manager-server:${VERSION}-arm64

# 推送镜像清单
docker manifest push ${IMAGE_PREFIX}/job-manager-server:${VERSION}
```

### 构建 job-manager-web 镜像

在 `job-manager-web` git 仓库中执行以下命令：

```bash
# 设置环境变量
export VERSION=250423
export IMAGE_PREFIX=tsz.io/t9k

# 构建 ARM64 架构镜像
[~/repos/job-manager-web]$ ./repo/workflows/docker-build-common.sh --arch arm64 -t ${VERSION}-arm64

# 构建 AMD64 架构镜像
[~/repos/job-manager-web]$ ./repo/workflows/docker-build-common.sh --arch amd64 -t ${VERSION}-amd64

# 创建多架构镜像清单
docker manifest create ${IMAGE_PREFIX}/job-manager-web:${VERSION} \
    ${IMAGE_PREFIX}/job-manager-web:${VERSION}-amd64 \
    ${IMAGE_PREFIX}/job-manager-web:${VERSION}-arm64

# 推送镜像清单
docker manifest push ${IMAGE_PREFIX}/job-manager-web:${VERSION}
```

### 镜像说明

- **镜像前缀**: 通过 `IMAGE_PREFIX` 环境变量配置（默认: `tsz.io/t9k`）
- **支持架构**: AMD64, ARM64
- **版本号**: 通过 `VERSION` 环境变量配置，建议使用日期格式（如 `250423` 表示 2025年4月23日）
- **依赖仓库**:
  - `job-manager-server`: 后端服务代码仓库
  - `job-manager-web`: 前端界面代码仓库

### 环境变量

| 变量名 | 描述 | 示例值 |
|--------|------|--------|
| `VERSION` | 镜像版本号 | `250423` |
| `IMAGE_PREFIX` | 镜像仓库前缀 | `tsz.io/t9k` |

### 注意事项

1. 构建前确保已经克隆了相应的 git 仓库
2. 确保 Docker 客户端已登录到镜像仓库（通过 `IMAGE_PREFIX` 指定）
3. 根据实际发布日期和目标仓库调整环境变量值
