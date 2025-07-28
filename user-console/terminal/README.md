# Terminal

一个提供通过 Web 使用的 Terminal 应用。用户可以使用浏览器连接到该终端，进行各项工作，包括使用 `kubectl` 管理 K8s 资源，运行 `helm` 等其它命令行程序。

该 APP 中已安装以下工具：tmux、kubectl、helm、vim 等。

## 文件结构

```bash
├── README.md
├── chart
│   ├── Chart.yaml
│   ├── templates
│   │   └── ...
│   └── values.yaml
├── docker
│   └── Dockerfile
├── icon.png
└── template.yaml
```

其中：

1.  `chart/` 文件夹存储 Helm Chart 安装模版。
2. `docker/` 文件夹中存储该应用所需要的镜像构建文件。
3. `icon.png` 为该应用的图标。
4. `template.yaml` 为 APP 模版，用于注册 APP。

## 镜像构建

Terminal 应用需要构建一个镜像：

- `terminal`: 应用镜像

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
- **构建位置**: `apps/user-console/terminal/docker` 目录
- **Dockerfile**: 分别使用 `Dockerfile-amd64` 和 `Dockerfile-arm64`

### 环境变量

| 变量名 | 描述 | 示例值 |
|--------|------|--------|
| `VERSION` | 镜像版本号 | `250423` |
| `IMAGE_PREFIX` | 镜像仓库前缀 | `tsz.io/t9k` |

### 注意事项

1. 构建前确保在正确的目录路径中（`apps/user-console/terminal/docker`）
2. 确保 Docker 客户端已登录到镜像仓库（通过 `IMAGE_PREFIX` 指定）
3. 根据实际发布日期和目标仓库调整环境变量值
4. 使用原生 `docker build` 命令，需要为不同架构指定不同的 Dockerfile
5. 需要手动推送构建好的镜像到仓库

构建镜像之后需要更新 chart 文件夹中安装模版，同时将新版本的 chart 上传到 oci 仓库中。

## Helm Chart

Helm Chart 的开发方式参考 [Helm Getting Start](https://helm.sh/docs/chart_template_guide/getting_started/) 。

打包并上传 Helm Chart：

```bash
helm package ./chart
helm push terminal-0.1.3.tgz oci://docker.io/t9kpublic
```
