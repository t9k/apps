# Application Template

[中文](./template_zh.md)

When registering an application, a template for the App must be provided to describe its information. Taking the Terminal App as an example:

```yaml
apiVersion: app.tensorstack.dev/v1beta2
kind: Template
metadata:
  name: terminal
  displayName: Terminal
  categories: ["Tool"]
  description: "This is a App Template Demo"
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

*   `apiVersion` and `kind` use the `metav1.TypeMeta` of the K8s API to mark the API type and version.
*   `metadata` records the basic information of the App, including its name, category, etc.
    *   `icon`: The URL of the application icon, pointing to the icon file address. It is an object containing a `url` field. The variable `$APP_DIR` can be used to represent the folder where the template file is located, making it easy to specify files in the local file system.
*   `template` defines the specific content of the App template.
    *   `versions`: Records the information of each version of the App. It is a list, where each item represents a version of the application and contains the following fields:
        *   `version`: The version of the App.
        *   `pausable`: A boolean that indicates whether the App instance can be paused.
        *   `chart`: This object specifies the Helm chart information, including `repo`, `name`, and `version`.
        *   `urls`: The access link of the App instance, which can be generated based on the installation/deployment configuration of the App instance. Both the `name` and `url` sub-fields can be filled in Go Template format (for the replacement rules of Go Template format strings, see [Go Template Replacement Rules](#go-template-replacement-rules)). The `url` sub-field is used to open the App link in the front end, so it meets the general processing method of the front end for URLs:
            *   If `url` contains a protocol (such as `http://`), a new tab page is opened with the complete `url`.
            *   If `url` does not contain a protocol but starts with `/`, the content of the `url` field is treated as a **path**, and a new tab page is opened in combination with the domain name of the current page (User Console).
            *   [Not recommended] If `url` does not contain a protocol and does not start with `/`, the content of the `url` field is treated as a **subpath**, and a new tab page is opened in combination with the domain name and path of the current page (User Console).
        *   `config`: The [deployment configuration](#deployment-configuration) of the App, which can be the specific content of the template (YAML string) or a reference to a local file.
        *   `readinessProbe`: Detects whether the App is running normally. For configuration methods, see [App Running Detection](#app-running-detection).
        *   `dependencies`: Records the cluster environment on which the App depends, including API resources and services in the cluster. For configuration methods, see [Application Dependencies](#application-dependencies).

## Helm Configuration

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
> 1.  Currently, `t9k-app` only supports unregistering a single App at a time, not batch unregistration.
> 2.  Currently, `t9k-app` only supports unregistering an entire App, not a specific version of an App. If a user wants to unregister a specific version of an App, they can remove the version information from the App template and then update the App.

## Deployment Configuration

When deploying Apps, users need to provide a **deployment configuration**.

When registering Apps, administrators can set a **deployment configuration template** for each version of an application through the `template.versions[@].config` field to help users construct the deployment configuration.

This field supports filling in with external files and inline content.

1)  External file:

    ```yaml
    apiVersion: app.tensorstack.dev/v1beta2
    kind: Template
    template:
      versions:
      # Use local file path to fill in
      - config: "file://$APP_DIR/manifests/v0_1_1.yaml"
    ```

2)  Inline content:

    ```yaml
    apiVersion: app.tensorstack.dev/v1beta2
    kind: Template
    template:
      versions:
      # Use inline content to fill in
      - config: "# +t9k:form:pattern v2\n# +t9k:description:en Terminal image config.\n# +t9k:description:zh Terminal 镜像信息。\nimage:\n  # +t9k:form\n  # +t9k:description:en Terminal image registry.\n  # +t9k:description:zh Terminal 镜像仓库。 \n  registry: \"$(T9K_APP_IMAGE_REGISTRY)\"\n  # +t9k:form\n  # +t9k:description:en Terminal image repository.\n  # +t9k:description:zh Terminal 镜像名称。\n  repository: \"$(T9K_APP_IMAGE_NAMESPACE)/terminal\"\n  # +t9k:form\n  # +t9k:description:en Terminal image tag.\n  # +t9k:description:zh Terminal 镜像���签。\n  tag: \"250423\"\n  # +t9k:form\n  # +t9k:description:en Terminal image pull policy.\n  # +t9k:description:zh Terminal 镜像拉取策略。\n  pullPolicy: IfNotPresent\n# sh, bash or zsh\n#\n# +t9k:form\n# +t9k:description:en Select a shell to start terminal.\n# +t9k:description:zh 选择一个 Shell 启动 Terminal。\nshell: bash\nresources:\n  # +t9k:description:en App resource limit.\n  # +t9k:description:zh App 资源限额。\n  limits:\n    # +t9k:form\n    # +t9k:description:en CPU limit for the App container.\n    # +t9k:description:zh App CPU 限制。\n    cpu: 200m\n    # +t9k:form\n    # +t9k:description:en Memory limit for the App container.\n    # +t9k:description:zh App 内存限制。\n    memory: 400Mi\n# +t9k:form\n# +t9k:description:en Mount pvcs to terminal.\n# +t9k:description:zh 挂载 pvcs 到 Terminal。\npvcs: []\nglobal:\n  t9k:\n    homeURL: \"$(T9K_HOME_URL)\"\n    securityService:\n      enabled: true\n      endpoints:\n        oidc: \"$(T9K_OIDC_ENDPOINT)\"\n        securityServer: \"$(T9K_SECURITY_CONSOLE_SERVER_ENDPOINT)\"\n    pepProxy:\n      args:\n        clientID: $(T9K_APP_AUTH_CLINET_ID)"
    ```

Below is the deployment configuration template for the Terminal application:

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
  # +t9k:description:zh Terminal 镜像标签。
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

Where:

*   The User Console's deployment page will recognize all comments starting with `# +t9k:` and integrate the fields specified by these comments into a web form to facilitate user filling.
    *   `# +t9k:form` indicates that the field is a form item.
    *   `# +t9k:description:en` and `# +t9k:description:zh` provide English and Chinese descriptions for the field.
*   When deploying an application, the application controller provides system variable support to achieve flexible configuration.
    *   In the configuration, the syntax for using variables is: `$(<variable-name>)`, for example, `"$(T9K_HOME_URL)"`.
    *   For the variables that can be used in the deployment configuration template, please refer to [System Variables](#system-variables).

### System Variables

Currently, the following variables are supported in the deployment configuration template:

1.  `$(T9K_HOME_URL)`: The domain name used by the platform to expose services. Administrators can configure the application to use this domain name to expose application services in the application template.
2.  `$(T9K_OIDC_ENDPOINT)`: The OIDC service address of the platform.
3.  `$(T9K_SECURITY_CONSOLE_SERVER_ENDPOINT)`: The Security Console server address of the platform.
4.  `$(T9K_APP_AUTH_CLINET_ID)`: Represents a Client ID (a concept in the OAuth protocol). Applications that require authorization should use this Client ID to apply for authorization from the authorization server.
5.  `$(T9K_HOME_DOMAIN)`: The domain name of the platform.
6.  `$(T9K_AUTH_DOMAIN)`: The domain name where the platform authorization service is located.
7.  `$(T9K_APP_IMAGE_REGISTRY)`: The Registry address for pulling images when installing an APP.
8.  `$(T9K_APP_IMAGE_NAMESPACE)`: The namespace or project for pulling images when installing an APP.

## App Running Detection

The `readinessProbe` field in the application template defines how to detect whether the application is running normally.

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

As shown in the YAML above, three types of `readinessProbe` can be defined in the App template:

*   `tcpSocket` checks whether a specified port on a Host (in the current environment, this refers to Pods, Services, etc.) can be connected to.
*   `httpGet` checks whether a Get request can be sent to a specified path.
*   `resources` checks the status of the specified resources; if this field is filled with the judgment conditions of multiple resources, the `readinessProbe` will only pass the judgment if all resources pass the judgment.
    *   When the string generated according to `currentStatus` is the same as `desiredStatus`, it means that the current resource is ready.
    *   If it is determined that the current resource is not ready, the controller will generate an error message based on the `message` field. This error message will be recorded in the Instance resource object and can also be seen on the User Console page.

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

Above is a `resources` type `readinessProbe`, which means: check the `status` sub-field of the `.status.conditions` field with `type` as `Ready`. If the content of this field is `True`, it means that the `notebook` resource is ready; otherwise, return the `message` sub-field of the `.status.conditions` field with `type` as `Ready` as an error message.

The application template can be left without any `readinessProbe`, which means that the application is in the `Ready` state as soon as it is deployed; you can also fill in multiple `readinessProbe` at the same time, which means that the application instance will only enter the `Ready` state after all `readinessProbe` have passed verification.

In the example at the beginning of the chapter, all `{{ .go-template }}` indicate that the current field can be filled with a Go Template string.

> [!NOTE]
> The Go Template variables for the `resources[@].currentStatus` and `resources[@].message` fields are filled using the resource object attributes in the running application instance, not the configuration used when deploying the application (CR Object definition, Helm Values). See [Go Template Replacement Rules](#go-template-replacement-rules).

## Application Dependencies

The `dependencies` field in the application template defines the dependencies of the application.

When registering an App, if the current cluster does not meet the application dependencies, the App server will reject the registration of the App; after registration, if these application dependencies are lost in the cluster, users will not be able to see these dependency-lost Apps when deploying them.

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

Two types of dependencies can be defined:

*   `crds`: The application depends on a specific CRD.
*   `services`: The application depends on a specific service. (Here, it is not checked whether the service is available, because the service may be temporarily unavailable due to network fluctuations, etc. When a similar situation occurs, it is easy for the application to fluctuate between "deployable" and "undeployable". Here, it is assumed that as long as the service exists, that is, the Service resource exists, the prerequisite for application deployment is met.)

## Go Template Replacement Rules

In the application template, some fields need to refer to the information of the application instance during deployment or the information of the resources generated after deployment, which are filled in Go Template format:

*   For Go Template syntax, please refer to: [https://developer.hashicorp.com/nomad/tutorials/templates/go-template-syntax](https://developer.hashicorp.com/nomad/tutorials/templates/go-template-syntax).
*   The variables used by Go Template are discussed below in the following three situations:
    1.  Helm Configuration;
    2.  The Go Template variables used by the `readinessProbe.resources[@].currentStatus|message` field.

### Helm Configuration

The available variables include:

1.  `{{ .Release.Namespace }}`: The namespace where the application instance is located.
2.  `{{ .Release.Name }}`: The name of the application instance.
3.  `{{ .Values.xxx }}`: The fields in the deployment configuration of the application instance.

Below is part of the deployment configuration for the Terminal application:

```yaml
shell: bash
pingIntervalSeconds: 30
```

Users can use `{{ .Values.shell }}` in Go Template to refer to the value of the `shell` field in the above configuration.

> [!NOTE]
> [Helm Build-in Object](https://helm.sh/docs/chart_template_guide/builtin_objects/) supports more variables, but most of these variables require reading Chart files, checking the local environment, etc., which are more troublesome to obtain and have little use in application templates. Therefore, only the two built-in variables `{{ .Release.Namespace }}` and `{{ .Release.Name }}` are supported in the application template.

### readinessProbe.resources[@].currentStatus|message

Refers to the following fields:

*   `template.versions[@].readinessProbe.resources[@].currentStatus`
*   `template.versions[@].readinessProbe.resources[@].message`

> [!NOTE]
> Unlike other fields that support Go Template format, `currentStatus` and `message` are used to determine the status of sub-resources after the application instance is deployed, while other fields are parsed when the application instance is deployed.

Below is part of the application template for the Terminal application:

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

Assuming the user deploys an application named `demo`, according to the rules in [Helm Configuration](#helm-configuration), the `name` field above is `demo`. Therefore, according to the `readinessProbe`, the instance controller needs to check the status of the `demo` Deployment. The variables in `currentStatus` above refer to the fields of the Deployment, and its logic is: find the `.status.conditions` with `type` as `Available` and return its `status` sub-field.
