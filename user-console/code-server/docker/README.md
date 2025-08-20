# 镜像

## 预装扩展

预装扩展的方法：启动一个任意的 Code Server 服务，在其 UI 中管理扩展至想要的状态后，将目录 `.local/share/code-server/extensions` 打包为文件 `extensions.tar.gz` 并放到当前目录下。

文件 `clp.tar.gz` 和 `languagepacks.json` 用于配置默认显示语言为简体中文（zh-cn）。


## 镜像构建

Code Server 应用需要用到一个镜像：

- `code-server`: 应用镜像，在当前目录下构建。

本目录中准备了基于 `pytorch/pytorch:2.5.0-cuda12.1-cudnn9-devel` 镜像构建 `code-server` 应用镜像的 Dockerfile，执行以下命令构建镜像：

```bash
docker build . -t docker.io/t9kpublic/code-server:20241023
docker build . -f sudo.Dockerfile -t docker.io/t9kpublic/code-server:20241023-sudo
```
