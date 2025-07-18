# 应用开发

[English](./dev.md)

本文介绍 Helm 和 CRD 两种形式 Apps 的开发过程。

## Helm Apps

开发 Helm 形式的 Apps 包括如下步骤：

1. 把 App 容器化，构架容器镜像，并使用 K8s 的 APIs 和服务；
2. 使用 Helm Chart 打包应用，并符合 T9k Apps 的规范；
3. 发布 App，使用 T9k Apps 定义的规范和流程发布 Apps。

### 构建镜像

> [!NOTE]
> 1. 镜像是容器镜像（container image）简称。
> 1. 如果 App 使用已有镜像，则可跳过该步骤。

构建镜像一般需要：

* Dockerfile：一个文本文件，其中包含构建镜像的各个步骤。
* 上下文：构建镜像有时需要使用本地文件，这些本地文件就是构建镜像过程中的上下文。

参考 [Docker: Building Images](https://docs.docker.com/build/building/packaging/)。

以下是一个简单的 Dockerfile：

```dockerfile
FROM centos:7.6.1810

# install develope tools
RUN yum update -y && \
   yum install -y git \
     gcc \
     cmake \
     make \
     openssl-devel \
     zlib-devel \
     epel-release \
     json-c-devel

RUN yum install -y libuv-devel

# clone and compile libwebsockets
RUN git clone https://mirror.ghproxy.com/https://github.com/warmcat/libwebsockets.git && \
   cd libwebsockets && \
   git checkout v4.1-stable && \
   mkdir build && \
   cd build && \
   cmake .. -DLWS_WITH_LIBUV=ON && \
   make && \
   make install

# clone and compile ttyd
RUN git clone https://mirror.ghproxy.com/https://github.com/tsl0922/ttyd.git && \
   cd ttyd && \
   git checkout 1.6.3 && \
   mkdir build && \
   cd build && \
   cmake .. && \
   make && \
   make install

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
CMD ["ttyd", "-p", "8080", "bash"]
```

在该镜像中，我们使用 `centos:7.6.1810` 基础镜像，安装了 `gcc` 等工具，并安装了 `ttyd` 软件。在最后指定 `ttyd -p 8080 bash` 作为容器默认启动命令。
Dockerfile 更多语法，请参考 [Docker: Dockerfile Reference](https://docs.docker.com/reference/dockerfile/)。

在准备好 Dockerfile 和上下文后，使用以下命令构建镜像：

```bash
docker build -f <dockerfile-path> -t <image-tag> <runtime-path>
```

构建好的镜像需要上传到一个镜像仓库中，方便在其他机器上使用时拉取：

```bash
docker push <image-tag>
```

### 开发 Helm Chart

> [!NOTE]
> 如果使用已有 Helm Chart，跳过该步骤。但由于 T9k Apps 的 Charts 需要符合特定的规范，一般情况下，用户总是需要自己构建 Charts。

一个 Helm Chart 示例：

```
chart
├── Chart.yaml
├── README.md
├── templates
│   ├── NOTES.txt
│   ├── deployment.yaml
│   ├── service.yaml
│   └── virtualservice.yaml
└── values.yaml
```

其中：

* `Chart.yaml`：Chart 的基本信息。
* `README.md`：Chart 的介绍，在应用注册成功后，用户可以在 User Console 的应用介绍页面看到这部分内容。
* `templates`：Helm 模版文件，其中一般包括：
  * `NOTES.txt`：介绍一个 Helm Release（部署后的 Helm Chart 实例）信息。
  * 模版文件：K8s 资源模版，可以使用一些逻辑语句和函数。
* `values.yaml`：Helm Chart 的默认配置（Default Values）。
* 更多 Helm Chart 的介绍请参考 [Helm: Getting Started](https://helm.sh/docs/chart_template_guide/getting_started/)。

#### 设置 Values

T9k Apps 支持 2 种方式设置 Charts 的 `Values` ：

1. Default Values：Helm Chart 的默认变量值，在开发 Helm Chart 时，记录在 `values.yaml` 文件中。
2. User Values：额外变量值。用户在部署应用的时候时设置，服务器会将该 Values 与 Default Values 合并（字段冲突时，User Values 优先级更高），然后用于部署 App。

#### 调试

在上传 Helm Chart 前，开发者应在集群中完成完整的测试，以保证 Chart 确实可用。

这里叙述一个简单的流程，使用本地文件夹 `./chart` 中的内容进行测试：

1) 使用 `helm template` 生成部署清单：

```bash
helm template <release-name> -n <release-ns> ./chart > manifests.yaml
```

开发者检查生成的清单文件 `manifests.yaml` 以确保符合预期。

2) 使用 `helm install` 部署应用：

```bash
helm install <release-name> -n <release-ns> ./chart
```

3) 应用被部署到集群中后，开发人员检查应用是否运行正常，能否访问。

#### 上传

在调试好 Helm Chart 后，打包 Helm Chart：

```bash
helm package ./chart
```

在执行完命令后，Helm Chart 会被打包成一个 `.tgz` 文件，其名称格式为 `<chart-name>-<chart-version>.tgz`。

将打包后的 Helm Chart 压缩包上传到 Chart 仓库：

```bash
helm push <tgz-file> <registry-url>
```
>[!NOTE]
> 一般使用公开仓库如 Docker Hub，则 `<registry-url>` 格式类似 `oci://docker.io/t9kpublic`，
> 但如果 Docker Hub 不可访问，用户需要使用其它 OCI Registry 云服务或搭建自己的 `oci` 仓库，参考 [Harbor](https://goharbor.io/))

#### 注意事项

1. 如果 App 需要设置 Service Account，可使用 Proejct 中预置的 ServiceAccount `managed-project-sa`，该 ServiceAccount 具有用户 Proejct 中的全部权限。请勿另行创建 ServiceAccount、Role 和 RoleBinding 等 RBAC 资源。

1. 如果预制的 Service Account 不满足用户 App 的需求，用户需要联系系统管理员，以获得合适的 RBAC 设置。

### 发布 App

App 发布流程完成对 Helm Chart 定义相关 App Template 及配置文件，以支持 App 注册。

一般应准备以下内容：

```
.
├── configs
│   ├── v0_1_1.yaml
│   ├── v0_1_2.yaml
│   ├── v0_1_3.yaml
│   └── v0_1_4.yaml
├── icon.png
└── template.yaml
```

其中：

* `configs` 文件夹：存储各版本应用的默认部署配置，也就是用户在前端部署应用时显示的默认配置。
* `icon.png`：应用图标。
* `template.yaml`：应用模版文件。

上述内容的格式请参考[应用模版](./template.md#应用模版)。

以下为 Terminal 应用的模版文件：

```yaml
apiVersion: app.tensorstack.dev/v1beta1
kind: Template
metadata:
  name: terminal
  displayName: Terminal
  defaultVersion: "0.1.1"
  categories: ["Tool"]
  description: "This is a App Template Demo"
  icon: "file://$APP_DIR/icon.png"
template:
  helm: 
    repo: "oci://docker.io/t9kpublic"
    chart: "terminal"
    versions:
    - version: 0.1.1
      config: "file://$APP_DIR/manifests/v0_1_1.yaml"
      ...
```

其中：

* `metadata.icon` 中填写 `icon` 地址，除了本地文件以外，还支持通过 url 使用互联网图片.
* `template.helm.versions[@].config` 中设置各版本应用的默认部署配置文件。
* `template.helm.repo` 和 `template.helm.chart` 填写[开发 Helm Chart](#开发-helm-chart) 一节中 Chart 上传的仓库地址和名称。

更多应用模版介绍，请参考[应用模版](./template.md#应用模版)。

使用命令行工具 t9k-app 注册应用：

```bash
export APIKEY='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
export APP_SERVER='https://home.sample.t9kcloud.cn/t9k/app/server'
t9k-app register \
  -k $APIKEY \
  -s $APP_SERVER \
  -f template.yaml
```

使用如下命令检查应用是否注册成功：

```bash
t9k-app list -k $APIKEY -s $APP_SERVER | grep terminal
```

#### 部署及测试

登录 User Console 页面，进入所注册应用的部署界面：

检查：

1. 版本信息是否符合预期
1. 表单、YAML 编辑器、README 的内容是否符合预期
1. 部署后，查看集群中创建的资源是否符合预期；应用链接是否正常工作。

卸载应用，查看是否有数据残留。（有些数据遗留行为是符合预期的，比如卸载应用后，希望应用产生的数据可以保留，以用于其他用途。）

## CRD 应用

### CRD 开发

CRD 是对 Kubernetes API 的扩展，其定义参考 [K8s Custom Resource](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)。

K8s 提供了丰富的工具和代码包帮助开发者快速开发一个 CRD，比如 [Kubebuilder](https://book.kubebuilder.io/)，用户可参考该文档学习 CRD 的开发。

#### 调试

参考文档 [Running and deploying the controller](https://book.kubebuilder.io/cronjob-tutorial/running)：

* 部署 CRD 及控制器；
* 创建一个资源对象，确定资源对象的行为符合预期：
  * 如果 CRD 用于提供服务，则需要检查服务是否正常运行；
  * 如果 CRD 用于执行任务，则需要测试任务是否正常完成；
  * 在任务、服务执行完成或失败后，CRD 的状态是否符合预期；
  * …

### App 发布

注册 CRD 应用，一般应准备以下内容：

```
├── configs
│   └── v0_1_1.yaml
├── icon.png
├── README.md
├── NOTE.txt
└── template.yaml
```

其中：

* `configs` 文件夹：存储各版本应用的默认部署配置，也就是用户在前端部署应用时显示的默认配置。
* `icon.png`：应用图标。
* `README.md`：应用介绍。
* `NOTE.txt`：应用实例部署后，提供给用户的实例信息。
* `template.yaml`：应用模版文件。

上述内容的格式请参考 [应用模版](./template.md#应用模版)。

以下为 JupyterLab 应用的模版文件：

```yaml
apiVersion: app.tensorstack.dev/v1beta1
kind: Template
metadata:
  name: jupyterlab-cpu
  displayName: "JupyterLab (CPU)"
  defaultVersion: "0.1.1"
  categories: 
  - IDE
  description: "JupyterLab 是最新的基于 Web 的交互式开发环境，用于代码开发和数据处理。其灵活的界面允许用户配置和安排数据科学、科学计算、计算新闻和机器学习中的工作流程。"
  icon: "file://$APP_DIR/icon.svg"
template:
  crd:
    group: tensorstack.dev
    resource: notebooks
    versions:
    - version: v1beta1
      config: "file://$APP_DIR/configs/v0_1_1.yaml"
      readme: "file://$APP_DIR/README.md"
      note: "file://$APP_DIR/NOTE.txt"
      ...
```

其中：

* `metadata.icon` 中填写 icon 地址，除了本地文件以外，还支持通过 url 使用互联网图片.
* `template.crd.versions[@]` 中 `config`、`readme`、`note` 字段填写对应文件路径。
* `template.crd.versions[@].version` 需要与 CRD 的版本对应。
* `template.crd.group` 和 `template.crd.resource` 填写 CRD 的对应信息，参考。

更多应用模版介绍，请参考 [应用模版](./template.md#应用模版)。

使用命令行工具 `t9k-app` 注册应用：

```bash
export APIKEY='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
export APP_SERVER='https://home.sample.t9kcloud.cn/t9k/app/server'
t9k-app register \
  -k $APIKEY \
  -s $APP_SERVER \
  -f template.yaml
```

使用如下命令检查应用是否注册成功：

```bash
t9k-app list -k $APIKEY -s $APP_SERVER | grep terminal
```

#### 部署及测试

这部分与 [Helm 应用的部署及测试](#部署及测试) 相同，不再赘述。
