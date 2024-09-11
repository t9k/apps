# 使用说明

`tools` 中的脚本用于简化安装 `user-console` 中 APP 时的一些常见操作，例如：

1. `image-mirror.sh` 根据 configs 中的 YAML，自动将镜像从一个仓库迁移到另一个仓库中。
1. `chart-mirror.sh` 根据 template.yaml，自动将 Helm Chart 从一个仓库迁移到另一个仓库中。

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

读取单个 APP 的 `template.yaml` 文件，迁移其中用到的所有 Helm Chart：

```bash
./chart-mirror.sh ../user-console/job-manager --source docker.io/t9kpublic --target registry.t9kcloud.cn/t9kcharts
```

遍历一个目录（例如 user-console）中所有 `template.yaml` 文件，迁移用到的所有 Helm Chart：

```bash
./chart-mirror.sh ../user-console --source docker.io/t9kpublic --target registry.t9kcloud.cn/t9kcharts
```

### 镜像迁移

读取单个 APP 的 `configs` 目录，迁移其中所有 config 文件中用到的所有容器镜像：

```bash
./image-mirror.sh ../user-console/job-manager --source docker.io/t9kpublic --target registry.cn-hangzhou.aliyuncs.com/t9k
```

注意：由于目前单个 configs 目录中的不同版本 config 往往会使用相同的镜像，这可能导致同样的镜像被多次 mirror。计划下一个版本去除掉重复的镜像。

遍历一个目录（例如 user-console）中所有 `configs` 文件夹中的所有文件，迁移用到的所有容器镜像：

```bash
./image-mirror.sh ../user-console --source docker.io/t9kpublic --target registry.cn-hangzhou.aliyuncs.com/t9k
```