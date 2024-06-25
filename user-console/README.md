# User-Console Applications

管理员在系统中注册 App 之后，用户就可以在 user-console 中部署+使用了。

## 目录结构

`user-console` 文件夹中保存可注册的 Apps，组织如下：

1. user-console 下每一个文件夹对应一个 App，如 notebook、terminal。
2. 在每一个 App 文件夹中，`template.yaml` 文件记录 App 模版，用于注册 App。如果模版中使用本地图片，可将图片同样放在 App 文件夹中，图片的引用方式参考 [Template 说明](#template-说明)。
3. 其他 App 开发文件。根据其开发方式在 App 文件夹创建对应的文件夹存放，如 dockerbuild、helm charts 等。

## App 的注册与注销

### 注册 Apps

注册 App 需要设置 APIKEY 和服务地址：

```bash
export APIKEY='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
export APP_SERVER='https://home.example.t9kcloud.cn/t9k/app/server'
```

注册单个 App 示例：

```bash
# 使用如下命令注册 Terminal App
t9k-app register -k $APIKEY -s $APP_SERVER \
  -f user-console/terminal/template.yaml
```

如果当前 App 已注册，但是需要更新 App 信息（如添加新版本）：

> 说明：如果 App 未注册而使用 `-u`，则直接注册。

```bash
# 在上述注册命令后面加上 -u 参数以说明若 App 已存在则更新
t9k-app register -k $APIKEY -s $APP_SERVER \
  -f user-console/terminal/template.yaml -u
```

使用如下命令注册 user-console 文件夹下所有 App：

```bash
# 1. 使用 -f 参数设置多个模版文件
t9k-app register -k $APIKEY -s $APP_SERVER \
  -f user-console/terminal/template.yaml \
  -f user-console/notebook/template.yaml

# 2. 使用通配符 * 匹配多个模版文件
t9k-app register -k $APIKEY -s $APP_SERVER -f "user-console/*/template.yaml"
```

### 注销 App

注销 App 示例：

```bash
# 使用如下命令注销 Terminal App，命令中应使用 App Name 而非 DisplayName
t9k-app unregister -k $APIKEY -s $APP_SERVER terminal
```

> 说明：目前 t9k-app 仅支持注销单个 App，不支持批量注销。

> 说明：目前 t9k-app 仅支持注销整个 App，不支持单独注销 App 的特定版本。如果用户想要注销 App 的某一特定版本，可以在原 App Template 中去掉该版本信息，然后使用 `t9k-app register -u` 命令来更新该 App。

> 注意：注销 App 并不会删除已部署的 App 实例。

### 用户权限

一些应用可能需要特定的 RBAC 权限才能正确运行，管理员在注册新应用时，应评估这些 RBAC 需求的合理性，及其风险。

如需修改项目的 RBAC 设置，可通过如下方式：

```
kubectl edit clusterrole project-operator-project-role
```

## 命令行工具 - t9k-app

管理员使用命令行工具 t9k-app 管理应用。

**注册/更新 App**

使用以下命令注册（更新）一个或多个 App：

```bash
t9k-app register -k $APIKEY -s $APP_SERVER \
  -f user-console/terminal/template.yaml -u
```

参数说明：

* `-k`：一个具有管理员权限的 API Key。
* `-s`：App Server 服务地址。
* `-f`：App 模版文件地址。
  * 一条命令中可以多次使用 `-f` 参数，读取多个模版文件，如 `t9k-app register -f template-1.yaml -f template-2.yaml`。
  * 模版文件地址中可以包含通配符，命令行工具会读取所有匹配的模版文件，如 `t9k-app register -f "apps/t9k_*/template.yaml"`。
  * App 模版文件说明：
    * 必须用 YAML 格式填写;
    * 一个模版文件中可以填写多个 App 模版，用 `---` 分割；
    * App 模版格式参考 [Template 说明](#template-说明)。
* `-u`：如果 App 已经存在，则更新该 App。
  * 如果 App 已经存在且未设置该参数，则不注册该 App。

**注销 App**

使用以下命令卸载 `terminal` App：

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
    repo: "oci://docker.io/t9kpublic"
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
      dependencies: {}
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

用户在 Go Template 中可以用 `{{ .Values.shell }}` 引用上述配置中 `shell` 字段的值。

说明：
[Helm Build-in Object](https://helm.sh/docs/chart_template_guide/builtin_objects/) 支持更多变量，但这些变量大多需要读取 Chart 文件、检查本地环境等，获取较为麻烦且在 App Template 中用途较小。所以在 App Template 中只支持 `{{ .Release.Namespace }}` 和 `{{ .Release.Name }}` 两个内置变量。

#### App 类型为 CRD

CRD App Template 中的 Go Template，可以引用 App 部署配置中的字段。

以下为 t9k-notebook App 的部分部署配置：

```
apiVersion: tensorstack.dev/v1beta1
kind: Notebook
metadata:
  name: notebook-demo
  namespace: demo
spec:
  type: jupyter
  ...
```

用户可以用 `{{ .metadata.namespace }}` 引用 App 实例所在命名空间，用 `{{ .spec.type }}` 引用 Notebook 类型。

说明：如果 CRD App 配置中 `.metadata.namespace` 字段如果没有填写，则 App Server 会自动根据用户所在 namespace 填写该字段，所以不用担心 `{{ .metadata.namespace }}` 变量会引用空值。但其他字段则没有默认值，所以需要注意。

#### readinessProbe.resources[@].currentStatus

指 `template.crd.versions[@].readinessProbe.resources[@].currentStatus` 和 `template.helm.versions[@].readinessProbe.resources[@].currentStatus` 这两个字段。

> 注意：与其他支持 Go Template 格式的字段不同：`currentStatus` 是用于在 App 实例部署后判断子资源状态，而其他字段在部署 App 实例时就会进行解析。

以下面的 Template （App Terminal）片段为例：

```yaml
apiVersion: app.tensorstack.dev/v1beta1
kind: Template
template:
  helm: 
    versions:
    - readinessProbe:
        resources:
        - group: apps
          version: v1
          resource: deployments
          name: terminal-{{ .Release.Name }}
          currentStatus: "{{- range .status.conditions }}{{- if eq .type \"Available\" }}{{- .status }}{{- end }}{{- end }}"
          desiredStatus: "True"
```

假定用户部署 App 名为 `demo`，根据 [Helm App 变量](#app-类型为-helm) 中的规则，上述 `name` 字段为 `terminal-demo`。所以根据 `readinessProbe`，实例控制器需要检查 `terminal-demo` Deployment 的状态。上述 `currentStatus` 中的变量引用 Deployment 的字段，其逻辑为：查找 `type` 字段为 `Available` 的 `.status.conditions` 并返回其 `status` 子字段。
