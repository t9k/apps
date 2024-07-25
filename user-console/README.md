# User Console 应用

TensorStack AI 平台的 User Console 提供了运行应用的功能。管理员需要先向 App Server 注册**应用**，然后用户可以在 User Console 部署和使用**应用实例**。

## 目录结构

当前目录下组织存放了所有可注册应用的相关文件，结构如下：

1. 每个子目录一般对应一个应用，但也可多个（例如 `notebook/` 和 `vllm/` ）。
2. 每个子目录下的 `template.yaml` 文件为**应用模版**（参考：[应用模板规范](./specs.md)），用于注册应用。
3. 每个子目录下可进一步创建子目录以存放其他开发文件，例如 `chart/` 存放 Helm Chart 文件，`docker/` 存放 Dockerfile。

## 注册和注销应用

注册和注销应用需要管理员权限，可通过设置具有管理员权限的 API key 达到； App Server 地址根据产品安装的 DNS 获得，例如：

```bash
export APIKEY='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
export APP_SERVER='https://home.sample.t9kcloud.cn/t9k/app/server'
```

### 注册应用

注册单个应用：

```bash
# 注册 Terminal 应用
t9k-app register -k $APIKEY -s $APP_SERVER -f user-console/terminal/template.yaml
```

更新已注册的应用（例如更新 Helm Chart 版本）：

```bash
# 如果 Terminal 应用已注册则更新
t9k-app register -k $APIKEY -s $APP_SERVER -f user-console/terminal/template.yaml -u
```

> [!NOTE]
> 如果使用 `-u` 参数而应用未注册，则正常注册应用。

批量注册多个应用：

```bash
# 方法 1: 使用 -f 参数选择多个应用模版
t9k-app register -k $APIKEY -s $APP_SERVER \
  -f user-console/terminal/template.yaml \
  -f user-console/notebook/template.yaml

# 方法 2: 使用通配符 * 匹配所有应用模版
t9k-app register -k $APIKEY -s $APP_SERVER -f "user-console/*/template.yaml"
```

### 注销应用

注销单个应用：

```bash
# 注销 Terminal 应用，应提供应用的 name 而非 display name
t9k-app unregister -k $APIKEY -s $APP_SERVER terminal
```

> [!NOTE]
> 目前 t9k-app 仅支持注销单个应用，不支持批量注销。

> [!NOTE]
> 目前 t9k-app 仅支持注销整个应用，不支持注销应用的特定版本。如果用户想要注销应用的某一特定版本，可以在应用模板中去掉该版本信息，然后更新该应用。

> [!IMPORTANT]
> 注销应用不会删除相应的的应用实例。

### 用户权限

一些应用可能需要特定的 RBAC 权限才能正确运行，管理员在注册新应用时，应评估这些 RBAC 需求的合理性，及其风险。

如需修改项目的 RBAC 设置，可通过执行以下命令：

```bash
kubectl edit clusterrole project-operator-project-role
```

## 命令行工具 t9k-app

管理员使用命令行工具 t9k-app 管理应用。

**注册/更新应用**

```bash
t9k-app register -f <app.yaml> -s <server> -k <apikey> [flags]
```

参数说明：

* `-f`：应用模版路径。
  * 一条命令中可以多次使用 `-f` 参数，读取多个应用模版，如 `t9k-app register -f template-1.yaml -f template-2.yaml`。
  * 应用模版路径可以包含通配符，t9k-app 会读取所有匹配的应用模版，如 `t9k-app register -f "apps/t9k_*/template.yaml"`。
* `-u`：如果应用已经存在，则更新该应用。
  * 如果应用已经存在且未设置该参数，则不注册该应用。
* `-k`：一个具有管理员权限的 API key。
* `-s`：App Server 服务地址。

**注销应用**

```bash
t9k-app unregister -k $APIKEY -s $APP_SERVER terminal
```

> 注意：注销 App 并不会删除已部署的 App 实例。

## Template 说明

`Template` 描述了一个可注册 App 的信息。

以 App Terminal 为例：

```yaml
apiVersion: app.tensorstack.dev/v1beta1
kind: Template
metadata:
  name: terminal
  displayName: Terminal
  defaultVersion: "0.1.0"
  categories: ["Tool"]
  description: "This is a App Template Demo"
  icon: "file://$APP_DIR/icon.png"
template:
  helm: 
    repo: oci://registry.dockermirror.com/t9kpublic
    chart: "terminal"
    versions:
    - version: 0.1.1
      config: "file://$APP_DIR/manifests/v0_1_1.yaml"
      urls: 
      - name: terminal
        url: /apps/{{ .Release.Namespace }}/terminal/{{ .Release.Name }}/
      readinessProbe:
        resources:
        - group: apps
          version: v1
          resource: deployments
          name: terminal-{{ .Release.Name }}
          currentStatus: "{{- range .status.conditions }}{{- if eq .type \"Available\" }}{{- .status }}{{- end }}{{- end }}"
          desiredStatus: "True"
      dependencies: 
        crds:
        - group: networking.istio.io
          version: v1beta1
          resource: virtualservices
```

* `apiVersion` 和 `kind` 采用 K8s API 的 `metav1.TypeMeta` 标记 API 类型和版本。
* `metadata` 记录 App 的基本信息，包括名称、分类等。
  * `defaultVersion`：默认 App 版本，在 App 有多个版本的情况下，示意默认版本。如果管理员在注册 App 时没有设置该字段，则 `versions[]` 中定义的第一个 App 版本为默认版本（具体参考 `template.crd.versions` 和 `template.helm.versions`）。
  * `icon`：App 图标 url，指向图标文件地址。可以用变量 `$APP_DIR` 表示模板文件所在文件夹， 方便指定本地文件系统中的文件。
* `template` 定义 App 模版的具体内容
  * 目前支持 Helm 和 CRD 形式的 App，分别通过 `template.helm` 和 `template.crd` 字段定义。
  * `versions`：记录 App 各版本信息，主要包含以下字段：
    * `urls`：App 的访问链接，可根据 App 实例安装/部署配置生成，`name` 和 `url` 两个子字段都可以用 Go Template 格式填写。（Go Template 格式字符串的替换规则见 [Go Template 替换规则](#go-template-替换规则)）
    * `config`：App 的 [部署配置](#部署配置)，可以是模版的具体内容（YAML 字符串），也可以引用一个本地文件。
    * `readinessProbe`：探测 App 是否正常运行。配置方法参考 [ReadinessProbe](#readinessprobe)。
    * `dependencies`：记录 App 依赖的集群环境，包括 API 资源和集群中的服务。配置方法参考 [Dependencies](#dependencies)。

### 部署配置

在部署 App 时，用户需要提交一个部署配置来提供 App 实例部署所需的必要信息。

管理员在注册 App 时，可以通过 `template.helm.versions[@].config` 和 `template.crd.versions[@].config` 两个字段分别为 Helm App 和 CRD App 设置部署配置模版，以帮助用户生成部署配置。

上述两个字段，都支持使用外部文件和内连内容（inline）两种方式填写。

外部文件：

```yaml
apiVersion: app.tensorstack.dev/v1beta1
kind: Template
template:
  helm: 
    versions:
    # 使用本地文件路径填写
    - config: "file://$APP_DIR/manifests/v0_1_1.yaml"
```

内连（inline）内容：

```yaml
apiVersion: app.tensorstack.dev/v1beta1
kind: Template
config:
  helm: 
    versions:
    # 使用 inline 内容填写
    - config: "# sh, bash or zsh\n## @param shell Select a shell to start terminal.\nshell: bash\n\n## @param resources.limits.cpu The maximum number of CPU the terminal can use.\n## @param resources.limits.memory The maximum number of memory the terminal can use.\nresources:\n  limits:\n    cpu: 200m\n    memory: 200Mi\n\n## @param resources.limits.cpu Mount pvcs to terminal.\npvcs: []\n\nglobal:\n  t9k:\n    homeURL: \"$(HOME_URL)\"\n    securityService:\n      enabled: true\n      endpoints:\n        oidc: \"$(OIDC_ENDPOINT)\"\n        securityServer: \"$(T9K_SECURITY_CONSOLE_SERVER_ENDPOINT)\"\n    pepProxy:\n      args:\n        clientID: $(APP_AUTH_CLINET_ID)"
```

以下为 Terminal 部署的配置模版：

```yaml
# sh, bash or zsh
## @param shell Select a shell to start terminal.
shell: bash

resources:
  limits:
    ## @param resources.limits.cpu The maximum number of CPU the terminal can use.
    ## @param resources.limits.memory The maximum number of memory the terminal can use.
    cpu: 200m
    memory: 200Mi

## @param resources.limits.cpu Mount pvcs to terminal.
pvcs: []

global:
  t9k:
    homeURL: "$(T9K_HOME_URL)"
    securityService:
      enabled: true
      endpoints:
        oidc: "$(T9K_OIDC_ENDPOINT)"
        securityServer: "$(T9K_SECURITY_CONSOLE_SERVER_ENDPOINT)"
    pepProxy:
      args:
        clientID: $(T9K_APP_AUTH_CLINET_ID)
```

其中：

* User Console 的部署页面会识别所有以 `## @param` 开头的注释，并将整合这些注释所指定的字段为一个表单（Web Form），方便用户填写。
  * 注释的格式为 `## @param <field-path> <field-description>`。
* 在部署 App 时，App 控制器提供系统变量支持，实现灵活配置。
  * 在配置中，使用变量的语法为： `$(<variable-name>)`，例如 `"$(T9K_HOME_URL)"`。
  * 部署配置模版中支持使用的变量请参考 [系统变量](#系统变量)

### readinessProbe

定义如何探测 App 是否在正常运行。

```yaml
template:
  helm: 
    versions:
    - readinessProbe:
        tcpSocket: 
          port: "{{ .go-template }}"
          host: "{{ .go-template }}"
        httpGet:
          scheme: "{{ .go-template }}"
          port: "{{ .go-template }}"
          host: "{{ .go-template }}"
          path: "{{ .go-template }}"
          httpHeaders: 
          - name: header-name
            value: "{{ .go-template }}"
        resources:
        - group: tensorstack.dev
          version: v1beta1
          resource: notebooks
          name: "{{ .go-template }}"
          currentStatus: "{{ .go-template }}"
          desiredStatus: "True"
```

`Template` 中可以定义三种 `readinessProbe`：

* `tcpSocket` 检查一个 Host（当前环境下，指 Pod、Service 等）上指定端口能否连通。
* `httpGet` 检查能否向一个指定路径发送 Get 请求。
* `resources` 检查指定资源的状态；如果该字段填写了多个资源的判定条件，则只有所有资源都通过判定，该 `readinessProbe` 才通过判定。

`Template` 可以不填写 `readinessProbe`，表示 App 实例一旦部署就处于 `Ready` 状态；也可以同时填写多个 `readinessProbe`，表示只有所有 `readinessProbe` 都通过验证，App 实例才进入 `Ready` 状态。

实例中所有 `{{ .go-template }}` 都表示当前字段可以用 Go Template 字符串来填写。

> 注意：`resources[@].currentStatus` 字段的 Go Template 变量是使用运行的 App 实例中的资源对象属性，而不是部署 App 时所用的配置（CR Object 定义、Helm Values）配置填写，参考 [Go Template 替换规则](#go-template-替换规则)。

### dependencies

```yaml
template:
  helm: 
    versions:
    - dependencies:
        crds:
        - group: tensorstack.dev
          version: v1beta1
          resources: notebook
        services: 
        - namespace: t9k-system
          name: build-console-web
```

`Template` 中定义两种 App 依赖：

* `crds`：App 依赖特定的 CRD。
* `services`：App 依赖特定的服务。（此处不检查服务是否可用，原因是服务可能因为网络波动等原因出现临时不可用的情况，当类似情况发生，容易出现 App 在“可部署”和“不可部署”间波动。这里假设只要服务存在，即 Service 资源存在，就满足 App 部署的前提）


### 系统变量

目前，App 配置模版中支持使用以下变量：

1. `$(T9K_HOME_URL)`：TensorStack 平台暴露服务所使用的域名。管理员可以在 App 模版中配置 App 使用该域名暴露 App 服务。
2. `$(T9K_OIDC_ENDPOINT)`：TensorStack 平台的 OIDC 服务地址。
3. `$(T9K_SECURITY_CONSOLE_SERVER_ENDPOINT)`：TensorStack 平台的 Security Console 服务器地址。
4. `$(T9K_APP_AUTH_CLINET_ID)`：表示一个 Client ID（OAuth 协议中的概念），需要授权的 App 应使用该 Client ID 向授权服务器申请授权。

### Go Template 替换规则

在 App Template 中，有些字段需要引用 App 实例部署时的信息或部署后产生的资源的信息，采用 Go Template 格式填写：

* Go Template 语法请参考：https://developer.hashicorp.com/nomad/tutorials/templates/go-template-syntax。
* Go Template 所使用的变量，分为以下三种情况在各章节进行讨论：
  1. App 类型为 Helm；
  2. App 类型为 CRD；
  3. `readinessProbe.resources[@].currentStatus` 字段所使用的 Go Template 变量。

#### App 类型为 Helm

可使用的变量包括：

1. `{{ .Release.Namespace }}`：App 实例所在的命名空间。
2. `{{ .Release.Name }}`：App 实例名称。
3. `{{ .Values.xxx }}`：App 实例部署配置中的字段。

以下为 template App 的部分部署配置：

```
shell: bash
pingIntervalSeconds: 30
```

参数说明：

* <app-name>：应用的名称，注意不是展示名称（display name）。
* `-k`：一个具有管理员权限的 API key。
* `-s`：App Server 服务地址。

## 参考

[应用模板 (template.yaml) 规范](./specs.md)
