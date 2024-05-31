# Terminal

在 Namespace 中部署一个 Terminal 程序，用户可以远程连接到该终端。通过该终端，用户可以管理当前 Namespace 中的 K8s 资源，也可以将该 APP 作为一个主机使用。

该 APP 中已下载以下工具：tmux、kubectl、helm、zsh。更多内容请自行探索。

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

1.  `chart/` 文件夹存储 Helm Chart 部署模版。
2. `docker/` 文件夹中存储该应用所需要的镜像构建文件。
3. `icon.png` 为该应用的图标。
4. `template.yaml` 为 APP 模版，用于注册 APP。

## 镜像构建

```bash
docker build -f docker/Dockerfile -t <tag> docker
```

构建镜像之后需要更新 chart 文件夹中部署模版，同时将新版本的 chart 上传到 oci 仓库中。

## Helm Chart

Helm Chart 的开发方式参考 [Helm Getting Start](https://helm.sh/docs/chart_template_guide/getting_started/) 。

打包并上传 Helm Chart：

```bash
helm package ./chart
helm push terminal-0.1.1.tgz oci://docker.io/t9kpublic
```
