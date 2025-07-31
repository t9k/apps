# 使用说明

[English](./README.md)

`tools` 中的脚本用于简化安装 `user-console` 中 APP 时的一些常见操作，例如：

1. `image-mirror.sh` 根据指定的应用列表，读取应用的配置文件 `app-artifacts.yaml`，自动将镜像从一个仓库迁移到另一个仓库中。
1. `chart-mirror.sh` 根据指定的应用列表，读取应用的配置文件 `app-artifacts.yaml`，自动将 Helm Chart 从一个仓库迁移到另一个仓库中。
1. `app-register.sh` 根据指定的应用列表注册应用程序，通过自动化必要的步骤来完成注册。

## 运行要求

安装了 Docker 和 Helm，并且已经登录了相应的 Registry：

```bash
docker login <registry>
```

```bash
helm registry login <registry>
```

Helm 版本大于等于 v3.8.0，测试时使用的版本如下：

```bash
helm version
version.BuildInfo{Version:"v3.9.0", GitCommit:"7ceeda6c585217a19a1131663d8cd1f7d641b2a7", GitTreeState:"clean", GoVersion:"go1.17.5"}
```

安装了 jq 和 yq，其中 yq 的版本要求是 4.x.x。测试时使用的版本如下：

```bash
$ jq --version
jq-1.6

$ yq --version
yq (https://github.com/mikefarah/yq/) version 4.25.2
```

## 使用方式

### [可选]设置环境变量

如果本地已经安装了其他版本的 jq 或者 yq，例如：安装了 yq 2.4.0

为了避免冲突，可以使用其他名称安装 yq 4，例如 yq-4，然后通过设置环境变量来正常使用这里的脚本：

```bash
export YQ=yq-4
export JQ=jq
```

### Chart 迁移

脚本自动根据脚本所在位置检测默认路径，你可以在任何目录下运行脚本：

```bash
# 使用默认配置（core apps）
./chart-mirror.sh

# 指定实验性应用配置
./chart-mirror.sh -c ../register-list/experimental-appstore-config.yaml

# 自定义所有参数
./chart-mirror.sh \
  -c /path/to/your-config.yaml \
  -u /path/to/user-console \
  --source docker.io/t9kpublic \
  --target registry.t9kcloud.cn/t9kcharts

# 显示帮助信息
./chart-mirror.sh --help
```

### 镜像迁移

类似地，镜像迁移脚本也支持灵活的参数配置：

```bash
# 使用默认配置（core apps）
./image-mirror.sh

# 指定实验性应用配置
./image-mirror.sh -c ../register-list/experimental-appstore-config.yaml

# 自定义所有参数
./image-mirror.sh \
  -c /path/to/your-config.yaml \
  -u /path/to/user-console \
  --source docker.io/t9kpublic \
  --target registry.cn-hangzhou.aliyuncs.com/t9k

# 显示帮助信息
./image-mirror.sh --help
```

### 参数说明

两个脚本都支持以下参数：

- `-c, --config <file>`：指定应用配置文件路径（默认：相对于脚本的 `../register-list/core-appstore-config.yaml`）
- `-u, --user-console <path>`：指定 user-console 目录路径（默认：相对于脚本的 `../user-console`）
- `--source <registry>`：源镜像/Chart 仓库地址
- `--target <registry>`：目标镜像/Chart 仓库地址
- `-h, --help`：显示帮助信息

### 路径处理

脚本会自动：
1. 根据脚本自身的位置计算默认的配置文件和 user-console 路径
2. 验证指定的文件和目录是否存在
3. 显示实际使用的路径，便于调试

这意味着你可以在任何目录下运行脚本，不用担心路径问题。
