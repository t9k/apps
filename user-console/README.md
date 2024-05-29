# README

使用如下命令注册 user-console 文件夹下所有 APP：

```
t9k-app registry -f */template.yaml
```

## APP Template 说明

```yaml
apiVersion: app.tensorstack.dev/v1beta1
kind: Template
metadata:
  name: terminal
  displayName: Terminal
  defaultVersion: "0.1.0"
  category: ["Tool"]
  description: "This is a APP Template Demo"
  icon: "file://$APP_DIR/icon.png"
template:
  helm: 
    repo: "oci://docker.io/t9kpublic"
    chart: "terminal"
    versions:
    - version: 0.1.1
      urls: 
      - name: terminal
        url: /t9k/app/terminal/{{ .Release.Namespace }}/{{ .Release.Name }}/
      readinessProbe:
        resources:
        - group: apps
          version: v1
          resource: deployments
          name: terminal-{{ .Release.Name }}
          currentStatus: "{{- range .status.conditions }}{{- if eq .type \"Available\" }}{{- .status }}{{- end }}{{- end }}"
          desiredStatus: "True"
      dependences: {}
```

* `apiVersion` 和 `kind` 采用 K8s API 的 metav1.TypeMeta 标记 API 类型和版本，此处 `kind` 确定为 `Template` 表示 APP 模版。
* `metadata` 记录 APP 的基本信息，包括名称、分类等。
  * `defaultVersion`：默认 APP 版本，在 APP 有多个版本的情况下，前端默认展示、创建该版本的 APP。如果管理员在注册 APP 时没有设置该字段，则视后面定义的第一个 APP 版本为默认版本（具体参考 `template.crd.versions` 和 `template.helm.versions`）。
  * `icon`：APP 图标 url，指向图标文件地址。可以用变量 `$APP_DIR` 表示模板文件所在文件夹， 方便指定本地文件系统中的文件。
* `template` 定义 APP 模版的具体内容
  * Helm APP 和 CRD APP 分别通过 `template.helm` 和 `template.crd` 字段定义，常见 Helm、CRD 的字段（如 `repo`、`chart`、`group`、`resource`）这里省去介绍，。
  * `urls`：APP 的访问链接，需要根据 APP 实例配置来生成，所以 `name` 和 `url` 两个子字段都可以用 go template 格式填写。（Go Template 格式字符串的替换规则见 [Go Template 替换规则](#go-template-替换规则)）
  * `readinessProbe`：记录如何检查一个 APP 是否正常运行。配置方法参考 [ReadinessProbe](#readinessprobe)。
  * `dependenes`：记录一个 APP 依赖的集群环境，包括 CRD 和集群中的服务。配置方法参考 [Dependences](#dependences)。

### ReadinessProbe

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

`Template` 中可以定义三种 `readinessProbe`，这些 `readinessProbe` 可以只使用一个也可以同时生效。

* `tcpSocket` 检查一个 Host（当前环境下，指 Pod、Service 等）上指定端口能否连通。
* `httpGet` 检查能否向一个指定路径发送 Get 请求。
* `resources` 检查指定资源的状态。

实例中所有 `{{ .go-template }}` 都表示当前字段可以用 go template 字符串来填写。值得注意的是，`resources[@].currentStatus` 字段的 go template 变量不是用部署 APP 时所用的清单（CR Object 定义、Helm Values）来填写的，而是用指定资源对象来填写，其他字段都是用部署 APP 时的清单填写。

### Dependences

```yaml
template:
  helm: 
    versions:
    - dependences:
        crds:
        - group: tensorstack.dev
          version: v1beta1
          resources: notebook
        services: 
        - namespace: t9k-system
          name: build-console-web
```

`Template` 中定义两种 APP 依赖：

* `crds`：APP 依赖特定的 CRD。
* `services`：APP 依赖特定的服务。（此处不检查服务是否可用，原因是服务可能因为网络波动等原因出现临时不可用的情况，当类似情况发生，容易出现 APP 在“可部署”和“不可部署”间波动。这里假设只要服务存在，即 Service 资源存在，就满足 APP 部署的前提）

### Go Template 替换规则

在 APP Template 中，有些字段需要引用 APP 实例部署时的信息或部署后产生的资源的信息，采用 Go Template 格式填写：

* Go Template 语法请参考：https://developer.hashicorp.com/nomad/tutorials/templates/go-template-syntax。
* Go Template 所使用的变量，分为以下三种情况在各章节进行讨论：
  1. APP 类型为 Helm；
  2. APP 类型为 CRD；
  3. `readinessProbe.resources[@].currentStatus` 字段所使用的 Go Template 变量。

#### APP 类型为 Helm

可使用的变量包括：

1. `{{ .Release.Namespace }}`：APP 实例所在的命名空间。
2. `{{ .Release.Name }}`：APP 实例名称。
3. `{{ .Values.xxx }}`：APP 实例部署清单中的字段。

以下为 template APP 的部分部署清单：

```
shell: bash
pingIntervalSeconds: 30
```

用户在 Go Template 中可以用 `{{ .Values.shell }}` 引用上述清单中 `shell` 字段的值。

说明：
[Helm Build-in Object](https://helm.sh/docs/chart_template_guide/builtin_objects/) 支持更多变量，但这些变量大多需要读取 Chart 文件、检查本地环境等，获取较为麻烦且在 APP Template 中用途较小。所以在 APP Template 中只支持 `{{ .Release.Namespace }}` 和 `{{ .Release.Name }}` 两个内置变量。

#### APP 类型为 CRD

CRD APP Template 中的 Go Template，可以引用 APP 部署清单中的字段。

以下为 t9k-notebook APP 的部分部署清单：

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

用户可以用 `{{ .metadata.namespace }}` 引用 APP 实例所在命名空间，用 `{{ .spec.type }}` 引用 Notebook 类型。

说明：如果 CRD APP 清单中 `.metadata.namespace` 字段如果没有填写，则 APP Server 会自动根据用户所在 namespace 填写该字段，所以不用担心 `{{ .metadata.namespace }}` 变量会引用空值。但其他字段则没有默认值，所以需要注意。

#### readinessProbe.resources[@].currentStatus

指 `template.crd.versions[@].readinessProbe.resources[@].currentStatus` 和 `template.helm.versions[@].readinessProbe.resources[@].currentStatus` 这两个字段。

与其他支持 Go Template 格式的字段不同：其他字段在部署 APP 实例时就会进行解析，而 currentStatus 是用于在 APP 实例部署后判断子资源状态。

以下为 template APP Template 的部分内容：

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

假定用户部署一个 terminal APP 实例，名为 `demo`，根据 [Helm APP 变量](#helm-app-变量) 中的规则，上述 `name` 字段为 `terminal-demo`。所以根据 `readinessProbe`，实例控制器需要检查 `terminal-demo` Deployment 的状态，上述 `currentStatus` 中的变量引用的就是该 Deployment 的字段，其逻辑为：查找 `type` 字段为 `Available` 的 `.status.conditions` 返回其 `status` 子字段。

## user-console 文件夹组织结构

user-console 文件夹中保存可在 User Console 平台中注册的 APPs，推荐开发者以如下方式使用该文件夹：

1. user-console 下每一个文件夹对应一个 APP，如 notebook、terminal。
2. 在每一个 APP 文件夹中，创建 template.yaml 文件记录 APP 模版，该模版用于注册 APP。如果模版中使用本地图片，则将图片同样放在 APP 文件夹中，图片的引用方式参考 [APP Template 说明](#app-template-说明)。
3. 其他 APP 开发文件，根据其开发方式在 APP 文件夹创建对应的文件夹存放，如 docker、chart 等。
