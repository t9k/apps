# 镜像

预装扩展的方法：启动一个任意的 Code Server 服务，在其 UI 中管理扩展至想要的状态后，将目录 `.local/share/code-server/extensions` 打包为文件 `extensions.tar.gz` 并放到当前目录下。

文件 `clp.tar.gz` 和 `languagepacks.json` 用于配置默认显示语言为简体中文（zh-cn）。

执行以下命令：

```bash
docker build . -t t9kpublic/code-server:20240923
docker build . -f sudo.Dockerfile -t t9kpublic/code-server:20240923-sudo
```