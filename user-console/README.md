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
  * `icon`：APP 图标，可以是一个超链接或者一个本地图片 url。如果使用本地图片，其格式为 `file:///absolute/path`，管理员可以用变量 `$APP_DIR` 表示模板文件所在文件夹，来解决 `file://` 协议不支持相对路径的问题。
* `template` 定义 APP 模版的具体内容
  * Helm APP 和 CRD APP 分别通过 `template.helm` 和 `template.crd` 字段定义，常见 Helm、CRD 的字段（如 `repo`、`chart`、`group`、`resource`）这里省去介绍，。
  * `urls`：APP 的访问链接，需要根据 APP 实例配置来生成，所以 `name` 和 `url` 两个子字段都可以用 go template 格式填写。对 CRD APP，用资源对象来填写 go template 变量；对 Helm APP，用 Helm Values 来填写 go template 变量。（后文所有 go template 字符串的填写，都与此相同，不再进行说明）
  * `readinessProbe`：记录如何检查一个 APP 是否正常运行。配置方法参考 [ReadinessProbe](#ReadinessProbe)。
  * `dependenes`：记录一个 APP 依赖的集群环境，包括 CRD 和集群中的服务。配置方法参考 [Dependences](#Dependences)。

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
* `resources` 检查指定资源的状态

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
