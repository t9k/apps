# Code Server

基于浏览器的 VSCode 环境。

## 镜像构建

Code Server 应用需要构建一个镜像：

- `codeserver`: 应用镜像

### 构建 codeserver 镜像

在 `products/discrete-images/codeserver` 目录中执行以下命令：

```bash
# 设置环境变量
export VERSION=4.23.1
export IMAGE_PREFIX=tsz.io/t9k

# 构建 AMD64 架构镜像
[~/repos/products/discrete-images/codeserver]$ ./docker-build.sh --arch amd64 --tag ${VERSION}-amd64

# 构建 ARM64 架构镜像
[~/repos/products/discrete-images/codeserver]$ ./docker-build.sh --arch arm64 --tag ${VERSION}-arm64

# 推送镜像到仓库
docker push ${IMAGE_PREFIX}/codeserver:${VERSION}-amd64 && docker push ${IMAGE_PREFIX}/codeserver:${VERSION}-arm64

# 创建多架构镜像清单
docker manifest create ${IMAGE_PREFIX}/codeserver:${VERSION} \
    ${IMAGE_PREFIX}/codeserver:${VERSION}-amd64 \
    ${IMAGE_PREFIX}/codeserver:${VERSION}-arm64

# 推送镜像清单
docker manifest push ${IMAGE_PREFIX}/codeserver:${VERSION}
```

### 镜像说明

- **镜像前缀**: 通过 `IMAGE_PREFIX` 环境变量配置（默认: `tsz.io/t9k`）
- **支持架构**: AMD64, ARM64
- **版本号**: 通过 `VERSION` 环境变量配置，使用语义化版本号（如 `4.23.1`）
- **依赖仓库**:
  - `products/discrete-images/codeserver`: 镜像构建代码目录

### 环境变量

| 变量名 | 描述 | 示例值 |
|--------|------|--------|
| `VERSION` | 镜像版本号 | `4.23.1` |
| `IMAGE_PREFIX` | 镜像仓库前缀 | `tsz.io/t9k` |

### 注意事项

1. 构建前确保已经克隆了相应的 git 仓库
2. 确保 Docker 客户端已登录到镜像仓库（通过 `IMAGE_PREFIX` 指定）
3. 根据实际版本和目标仓库调整环境变量值
4. 构建脚本为 `docker-build.sh`，位于 `products/discrete-images/codeserver` 目录
5. 需要手动推送构建好的镜像到仓库

## 支持 NVIDIA 以外的 GPU 类型

本应用模板使用 NVIDIA GPU 作为加速设备，如果你想要换用其他 GPU 类型并注册应用，请进行如下操作：

1. 修改 `template.yaml` 的第 4（模板名称）、5（模板展示名称）、11（helm chart repo）、13（helm chart 名称）行；
2. 修改最新 config（例如 `configs/v0.3.2.yaml`）的第 7-9（默认镜像）、17（扩展资源字段注解）、22（扩展资源名称）行，必要时添加环境变量、额外的卷/卷挂载、安全上下文等；
3. 修改 `chart/README.md` 的第 61-63（默认服务器镜像）、68（扩展资源名称）、86-93（使用加速设备可以选用的镜像）行，同时修改所有示例的服务器镜像和扩展资源名称，必要时在示例中添加环境变量、额外的卷/卷挂载、安全上下文等；
4. 修改 `chart/Chart.md` 的第 2（helm chart 名称）、6（JupyterLab 版本）行；
5. 打包 helm chart 并推送；
6. 注册修改后的应用。

你可以参考 `variations/` 下的示例文件。
