# FileBrowser

为指定目录提供了一个文件管理界面，用于上传、删除、预览、重命名和编辑文件。

## 镜像构建

FileBrowser 应用需要构建一个镜像：

- `filebrowser`: 应用镜像

### 构建 filebrowser 镜像

在 `products/discrete-images/filebrowser` 目录中执行以下命令：

```bash
# 设置环境变量
export VERSION=2.18.0
export IMAGE_PREFIX=tsz.io/t9k

# 构建 AMD64 架构镜像
[~/repos/products/discrete-images/filebrowser]$ ./docker-build.sh --arch amd64 --tag ${VERSION}-amd64

# 构建 ARM64 架构镜像
[~/repos/products/discrete-images/filebrowser]$ ./docker-build.sh --arch arm64 --tag ${VERSION}-arm64

# 推送镜像到仓库
docker push ${IMAGE_PREFIX}/filebrowser:${VERSION}-amd64 && docker push ${IMAGE_PREFIX}/filebrowser:${VERSION}-arm64

# 创建多架构镜像清单
docker manifest create ${IMAGE_PREFIX}/filebrowser:${VERSION} \
    ${IMAGE_PREFIX}/filebrowser:${VERSION}-amd64 \
    ${IMAGE_PREFIX}/filebrowser:${VERSION}-arm64

# 推送镜像清单
docker manifest push ${IMAGE_PREFIX}/filebrowser:${VERSION}
```

### 镜像说明

- **镜像前缀**: 通过 `IMAGE_PREFIX` 环境变量配置（默认: `tsz.io/t9k`）
- **支持架构**: AMD64, ARM64
- **版本号**: 通过 `VERSION` 环境变量配置，使用语义化版本号（如 `2.18.0`）
- **依赖仓库**:
  - `products/discrete-images/filebrowser`: 镜像构建代码目录

### 环境变量

| 变量名 | 描述 | 示例值 |
|--------|------|--------|
| `VERSION` | 镜像版本号 | `2.18.0` |
| `IMAGE_PREFIX` | 镜像仓库前缀 | `tsz.io/t9k` |

### 注意事项

1. 构建前确保已经克隆了相应的 git 仓库
2. 确保 Docker 客户端已登录到镜像仓库（通过 `IMAGE_PREFIX` 指定）
3. 根据实际版本和目标仓库调整环境变量值
4. 构建脚本为 `docker-build.sh`，位于 `products/discrete-images/filebrowser` 目录
5. 需要手动推送构建好的镜像到仓库 