# TensorStack AI 平台应用

本仓库包含一系列精选的第三方应用程序，这些程序经过打包，可轻松部署在 [TensorStack AI 平台](https://t9k.github.io/ucman/latest/index.html)上。这些被称为“应用”（Apps）的程序，旨在通过平台的用户控制台进行管理，从而为最终用户简化安装、配置和管理过程。

## 工作原理

该应用模型建立在 Kubernetes 原生功能之上。每个应用程序都由一组文件定义，其中包括：

*   **`template.yaml`**：一个清单文件，定义了应用程序的元数据、版本和部署配置。
*   **Helm Charts**：应用程序 Kubernetes 资源的核心打包格式。
*   **Dockerfiles & 镜像**：用于构建所需容器镜像的源文件。
*   **配置文件**：不同应用版本的默认值和设置。

管理员可以使用 `t9k-app` 命令行工具将这些应用注册到平台的应用服务器（App Server），从而让用户可以从用户控制台启动它们。

## 仓库结构

本仓库的组织结构如下：

```
.
├── .github/            # 用于发布应用的 CI/CD 工作流
├── docs/               # 关于应用系统、开发和发布流程的详细文档
├── tools/              # 用于镜像 Helm Chart 和容器镜像的辅助脚本
├── user-console/       # 可部署的活跃应用主目录
└── archived/           # 旧的或已弃用的应用定义
```

- **`user-console/`**：这是包含应用包的主目录。每个子目录代表一个单独的应用。
- **`docs/`**：包含理解应用架构、开发新应用和发布流程所需的所有文档。请参阅 [./docs/README.md](./docs/README_zh.md) 开始。
- **`tools/`**：包括 `image-mirror.sh` 和 `chart-mirror.sh` 等脚本，以帮助管理应用依赖。
- **`archived/`**：包含不再积极维护但为历史目的保留的应用定义。

## 开发与贡献

要了解如何为 TensorStack AI 平台开发和打包您自己的应用，请参阅 [应用开发指南](./docs/dev_zh.md)。

有关向本仓库发布和贡献应用的信息，请参阅 [应用发布指南](./docs/release_zh.md)。
