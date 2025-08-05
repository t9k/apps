# 应用模版

[English](./template.md)

注册应用时需提供 App 的模版（Template），描述 App 的信息。以 Terminal App 为例：

```yaml
apiVersion: app.tensorstack.dev/v1beta2
kind: Template
metadata:
  name: terminal
  displayName: Terminal
  categories: ["Tool"]
  description: "Terminal 是一个在浏览器中直接打开和操作的集群终端，便于管理集群。"
  icon: 
    url: "file://$APP_DIR/icon.png"
template:
  versions: 
  - version: v1
    pausable: true
    chart:
      repo: "oci://docker.io/t9kpublic"
      name: terminal
      version: 0.2.1
    config: "file://$APP_DIR/configs/v2/v0_2_1.yaml"
    urls: 
    - name: terminal
      url: /apps/{{ .Release.Namespace }}/terminal/{{ .Release.Name }}/
    readinessProbe:
      resources:
      - group: apps
        version: v1
        resource: deployments
        name: "{{ .Release.Name }}"
        currentStatus: "{{- range .status.conditions }}{{- if eq .type \"Available\" }}{{- .status }}{{- end }}{{- end }}"
        desiredStatus: "True"
    dependencies:
      crds:
      - group: networking.istio.io
        version: v1beta1
        resource: virtualservices
```

*   `apiVersion` 和 `kind` 采用 K8s API 的 `metav1.TypeMeta` 标记 API 类型和版本。
*   `metadata` 记录 App 的基本信息，包括名称、分类等。
    *   `icon`：应用图标的 URL，指向图标文件地址。它是一个包含 `url` 字段的对象。可以用变量 `$APP_DIR` 表示模板文件所在文件夹， 方便指定本地文件系统中的文件。
*   `template` 定义 App 模版的具体内容。
    *   `versions`：记录 App 各版本信息。它是一个列表，其中每一项代表应用的一个版本，包含以下字段：
        *   `version`：App 的版本。
        *   `pausable`：一个布尔值，表示 App 实例是否可以暂停。
        *   `chart`：此对象指定 Helm chart 的信息，包括 `repo`、`name` 和 `version`。
        *   `urls`：App 实例的访问链接，可根据 App 实例安装/部署配置生成，`name` 和 `url` 两个子字段都可以用 Go Template 格式填写（Go Template 格式字符串的替换规则见 [Go Template 替换规则](#go-template-替换规则)）。`url` 子字段用于在前端打开 App 链接，所以满足前端对 URL 的通用处理方式：
            *   如果 `url` 中包含协议（如 `http://`），则用完整地 `url` 打开新的标签页。
            *   如果 `url` 中不包含协议，但是以 `/` 开头，则将 `url` 字段内容视为**路径**，结合当前页面（User Console）的域名，打开新标签页。
            *   [不推荐] 如果 `url` 中不包含协议且不以 `/` 开头，则将 `url` 字段内容视为**子路径**，结合当前页面（User Console）的域名和路径，打开新标签页。
        *   `config`：App 的 [部署配置](#部署配置)，可以是模版的具体内容（YAML 字符串），也可以引用一个本地文件。
        *   `readinessProbe`：探测 App 是否正常运行。配置方法参考 [App 运行检测](#app-运行检测)。
        *   `dependencies`：记录 App 依赖的集群环境，包括 API 资源和集群中的服务。配置方法参考 [应用依赖](#应用依赖)。

## Helm 配置

```yaml
apiVersion: app.tensorstack.dev/v1beta2
kind: Template
metadata:
 ...
template:
  versions:
  - version: v1
    chart:
      repo: "oci://docker.io/t9kpublic"
      name: "terminal"
      version: 0.2.1
    config: "file://$APP_DIR/manifests/v0_1_1.yaml"
    urls: []
    readinessProbe: {}
    dependencies: {}
```

> [!NOTE]
> 1. 目前 t9k-app 仅支持注销单个 App，不支持批量注销。
> 2. 目前 t9k-app 仅支持注销整个 App，不支持注销 App 的特定版本。如果用户想要注销 App 的某一特定版本，可以在 App 模板中去掉该版本信息，然后更新该 App。

## 部署配置

部署 Apps 时，用户需要提供一个**部署配置**。

管理员在注册 Apps 时，可以通过 `template.versions[@].config` 字段为应用的每个版本设置**部署配置模版**，以帮助用户构造部署配置。

该字段支持使用外部文件和内连内容（inline）两种方式填写。

1) 外部文件：

```yaml
apiVersion: app.tensorstack.dev/v1beta2
kind: Template
template:
  versions:
  # 使用本地文件路径填写
  - config: "file://$APP_DIR/manifests/v0_1_1.yaml"
```

2) 内连（inline）内容：

```yaml
apiVersion: app.tensorstack.dev/v1beta2
kind: Template
template:
  versions:
  # 使用 inline 内容填写
  - config: "# +t9k:form:pattern v2\n# +t9k:description:en Terminal image config.\n# +t9k:description:zh Terminal 镜像信息。\nimage:\n  # +t9k:form\n  # +t9k:description:en Terminal image registry.\n  # +t9k:description:zh Terminal 镜像仓库。 \n  registry: \"$(T9K_APP_IMAGE_REGISTRY)\"\n  # +t9k:form\n  # +t9k:description:en Terminal image repository.\n  # +t9k:description:zh Terminal 镜像名称。\n  repository: \"$(T9K_APP_IMAGE_NAMESPACE)/terminal\"\n  # +t9k:form\n  # +t9k:description:en Terminal image tag.\n  # +t9k:description:zh Terminal 镜像���签。\n  tag: \"250423\"\n  # +t9k:form\n  # +t9k:description:en Terminal image pull policy.\n  # +t9k:description:zh Terminal 镜像拉取策略。\n  pullPolicy: IfNotPresent\n# sh, bash or zsh\n#\n# +t9k:form\n# +t9k:description:en Select a shell to start terminal.\n# +t9k:description:zh 选择一个 Shell 启动 Terminal。\nshell: bash\nresources:\n  # +t9k:description:en App resource limit.\n  # +t9k:description:zh App 资源限额。\n  limits:\n    # +t9k:form\n    # +t9k:description:en CPU limit for the App container.\n    # +t9k:description:zh App CPU 限制。\n    cpu: 200m\n    # +t9k:form\n    # +t9k:description:en Memory limit for the App container.\n    # +t9k:description:zh App 内存限制。\n    memory: 400Mi\n# +t9k:form\n# +t9k:description:en Mount pvcs to terminal.\n# +t9k:description:zh 挂载 pvcs 到 Terminal。\npvcs: []\nglobal:\n  t9k:\n    homeURL: \"$(T9K_HOME_URL)\"\n    securityService:\n      enabled: true\n      endpoints:\n        oidc: \"$(T9K_OIDC_ENDPOINT)\"\n        securityServer: \"$(T9K_SECURITY_CONSOLE_SERVER_ENDPOINT)\"\n    pepProxy:\n      args:\n        clientID: $(T9K_APP_AUTH_CLINET_ID)"
```

以下为 Terminal 应用的部署配置模版：

```yaml
# +t9k:form:pattern v2

# +t9k:description:en Terminal image config.
# +t9k:description:zh Terminal 镜像信息。
image:
  # +t9k:form
  # +t9k:description:en Terminal image registry.
  # +t9k:description:zh Terminal 镜像仓库。 
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  # +t9k:form
  # +t9k:description:en Terminal image repository.
  # +t9k:description:zh Terminal 镜像名称。
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/terminal"
  # +t9k:form
  # +t9k:description:en Terminal image tag.
  # +t9k:description:zh Terminal 镜像���签。
  tag: "250423"
  # +t9k:form
  # +t9k:description:en Terminal image pull policy.
  # +t9k:description:zh Terminal 镜像拉取策略。
  pullPolicy: IfNotPresent

# sh, bash or zsh
#
# +t9k:form
# +t9k:description:en Select a shell to start terminal.
# +t9k:description:zh 选择一个 Shell 启动 Terminal。
shell: bash

resources:
  # +t9k:description:en App resource limit.
  # +t9k:description:zh App 资源限额。
  limits:
    # +t9k:form
    # +t9k:description:en CPU limit for the App container.
    # +t9k:description:zh App CPU 限制。
    cpu: 200m
    # +t9k:form
    # +t9k:description:en Memory limit for the App container.
    # +t9k:description:zh App 内存限制。
    memory: 400Mi

# +t9k:form
# +t9k:description:en Mount pvcs to terminal.
# +t9k:description:zh 挂载 pvcs 到 Terminal。
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

*   User Console 的部署页面会识别所有以 `# +t9k:` 开头的注释，并将整合这些注释所指定的字段为一个表单（Web Form），方便用户填写。
    *   `# +t9k:form` 表示该字段是一个表单项。
    *   `# +t9k:description:en` 和 `# +t9k:description:zh` 为字段提供中英文描述。
*   在部署应用时，应用控制器提供系统变量支持，实现灵活配置。
    *   在配置中，使用变量的语法为：`$(<variable-name>)`，例如 `"$(T9K_HOME_URL)"`。
    *   部署配置模版中支持使用的变量请参考[系统变量](#系统变量)。

### 系统变量

目前，部署配置模版中支持使用以下变量：

1.  `$(T9K_HOME_URL)`：平台暴露服务所使用的域名。管理员可以在应用模版中配置应用使用该域名暴露应用服务。
2.  `$(T9K_OIDC_ENDPOINT)`：平台的 OIDC 服务地址。
3.  `$(T9K_SECURITY_CONSOLE_SERVER_ENDPOINT)`：平台的 Security Console 服务器地址。
4.  `$(T9K_APP_AUTH_CLINET_ID)`：表示一个 Client ID（OAuth 协议中的概念），需要授权的应用应使用该 Client ID 向授权服务器申请授权。
5.  `$(T9K_HOME_DOMAIN)`：平台的域名。
6.  `$(T9K_AUTH_DOMAIN)`：平台授权服务所在域名。
7.  `$(T9K_APP_IMAGE_REGISTRY)`：安装 APP 时，拉取镜像的 Registry 地址。
8.  `$(T9K_APP_IMAGE_NAMESPACE)`：安装 APP 时，拉取镜像的命名空间或者项目。

## App 运行检测

应用模板中的 `readinessProbe` 字段定义如何检测应用是否在正常运行。

```yaml
template:
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
        message: "{{ .go-template }}"
        currentStatus: "{{ .go-template }}"
        desiredStatus: "True"
```

如上述 YAML 所示，App 模版中可以定义三种 `readinessProbe`：

*   `tcpSocket` 检查一个 Host（当前环境下，指 Pod、Service 等）上指定端口能否连通。
*   `httpGet` 检查能否向一个指定路径发送 Get 请求。
*   `resources` 检查指定资源的状态；如果该字段填写了多个资源的判定条件，则只有所有资源都通过判定，该 `readinessProbe` 才通过判定。
    *   当根据 `currentStatus` 生成的字符串与 `desiredStatus` 相同，说明当前资源就绪。
    *   如果判定当前资源未就绪，控制器会根据 `message` 字段生成错误提示，该错误提示将被记录在 Instance 资源对象中，也可以在 User Console 页面中看到。

```yaml
readinessProbe:
  resources:
  - group: tensorstack.dev
    version: v1beta1
    resource: notebooks
    name: "{{ .Release.Name }}"
    message: "{{- range .status.conditions }}{{- if eq .type \"Ready\" }}{{- .message }}{{- end }}{{- end }}"
    currentStatus: "{{- range .status.conditions }}{{- if eq .type \"Ready\" }}{{- .status }}{{- end }}{{- end }}"
    desiredStatus: "True"
```

以上为一个 `resources` 类型的 `readinessProbe`，其含义为：检查类型为 `Ready` 的 `.status.conditions` 字段的 `status` 子字段，如果该字段内容为 `True`，则说明 `notebook` 资源已就绪；否则返回 类型为 `Ready` 的 `.status.conditions` 字段的 `message` 子字段作为错误提示。

应用模板可以不填写任何 `readinessProbe`，表示应用一旦部署就处于 `Ready` 状态；也可以同时填写多个 `readinessProbe`，表示只有所有 `readinessProbe` 都通过验证，应用实例才进入 `Ready` 状态。

章节开头的示例中，所有 `{{ .go-template }}` 都表示当前字段可以用 Go Template 字符串来填写。

> [!NOTE]
> `resources[@].currentStatus` 和 `resources[@].message` 字段的 Go Template 变量是使用运行的应用实例中的资源对象属性，而不是部署应用时所用的配置（CR Object 定义、Helm Values）配置填写，参考 [Go Template 替换规则](#go-template-替换规则)。

## 应用依赖

应用模板中的 `dependencies` 字段定义应用的依赖。

在注册 App 时，如果当前集群不满足应用依赖，则 App 服务器会拒绝该 App 的注册；在注册之后，如果集群中这些应用依赖项丢失，则在用户部署 App 时，无法看到这些依赖丢失的 App。

```yaml
template:
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

可以定义两种依赖：

*   `crds`：应用依赖特定的 CRD。
*   `services`：应用依赖特定的服务。（此处不检查服务是否可用，原因是服务可能因为网络波动等原因出现临时不可用的情况，当类似情况发生，容易出现应用在“可部署”和“不可部署”间波动。这里假设只要服务存在，即 Service 资源存在，就满足应用部署的前提）

## Go Template 替换规则

在应用模板中，有些字段需要引用应用实例部署时的信息或部署后产生的资源的信息，采用 Go Template 格式填写：

*   Go Template 语法请参考：https://developer.hashicorp.com/nomad/tutorials/templates/go-template-syntax。
*   Go Template 所使用的变量，分为以下三种情况在下面进行讨论：
    1.  Helm 配置；
    2.  `readinessProbe.resources[@].currentStatus|message` 字段所使用的 Go Template 变量。

### Helm 配置

可使用的变量包括：

1. `{{ .Release.Namespace }}`：应用实例所在的命名空间。
2. `{{ .Release.Name }}`：应用实例的名称。
3. `{{ .Values.xxx }}`：应用实例的部署配置中的字段。

以下为 Terminal 应用的部分部署配置：

```yaml
shell: bash
pingIntervalSeconds: 30
```

用户在 Go Template 中可以用 `{{ .Values.shell }}` 引用上述配置中 `shell` 字段的值。

> [!NOTE]
> [Helm Build-in Object](https://helm.sh/docs/chart_template_guide/builtin_objects/) 支持更多变量，但这些变量大多需要读取 Chart 文件、检查本地环境等，获取较为麻烦且在应用模板中用途较小。所以在应用模板中只支持 `{{ .Release.Namespace }}` 和 `{{ .Release.Name }}` 两个内置变量。

### readinessProbe.resources[@].currentStatus|message

指以下字段：

*   `template.versions[@].readinessProbe.resources[@].currentStatus`
*   `template.versions[@].readinessProbe.resources[@].message`

> [!NOTE]
> 与其他支持 Go Template 格式的字段不同，`currentStatus` 和 `message` 用于在应用实例部署后判断子资源状态，而其他字段在部署应用实例时就会进行解析。

以下为 Terminal 应用的部分应用模板：

```yaml
apiVersion: app.tensorstack.dev/v1beta2
kind: Template
template:
  versions:
  - readinessProbe:
      resources:
      - group: apps
        version: v1
        resource: deployments
        name: "{{ .Release.Name }}"
        currentStatus: "{{- range .status.conditions }}{{- if eq .type \"Available\" }}{{- .status }}{{- end }}{{- end }}"
        desiredStatus: "True"
```

假定用户部署应用名为 `demo`，根据 [Helm 配置](#helm-配置) 中的规则，上述 `name` 字段为 `demo`。所以根据 `readinessProbe`，实例控制器需要检查 `demo` Deployment 的状态。上述 `currentStatus` 中的变量引用 Deployment 的字段，其逻辑为：查找 `type` 字段为 `Available` 的 `.status.conditions` 并返回其 `status` 子字段。
