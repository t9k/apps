# Application Template

[中文](./template_zh.md)

When registering an application, a template for the App must be provided to describe its information. Taking the Terminal App as an example:

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
      dependencies: 
        crds:
        - group: networking.istio.io
          version: v1beta1
          resource: virtualservices
```

*   `apiVersion` and `kind` use the `metav1.TypeMeta` of the K8s API to mark the API type and version.
*   `metadata` records the basic information of the App, including its name, category, etc.
    *   `defaultVersion`: The default version. If the App has multiple versions, this indicates the default version. If the administrator does not set this field when registering the application, the first App version defined in `versions[]` will be the default version (see `template.crd.versions` and `template.helm.versions` for details).
    *   `icon`: The URL of the application icon, pointing to the icon file address. The variable `$APP_DIR` can be used to represent the folder where the template file is located, making it easy to specify files in the local file system.
*   `template` defines the specific content of the App template.
    *   Currently, it supports Helm and CRD type applications, which are defined by the `template.helm` and `template.crd` fields, respectively. See [CRD and Helm Templates](#crd-and-helm-templates).
    *   `versions`: Records the information of each version of the App, mainly including the following fields:
        *   `urls`: The access link of the App instance, which can be generated based on the installation/deployment configuration of the App instance. Both the `name` and `url` sub-fields can be filled in Go Template format (for the replacement rules of Go Template format strings, see [Go Template Replacement Rules](#go-template-replacement-rules)). The `url` sub-field is used to open the App link in the front end, so it meets the general processing method of the front end for URLs:
            *   If `url` contains a protocol (such as `http://`), a new tab page is opened with the complete `url`.
            *   If `url` does not contain a protocol but starts with `/`, the content of the `url` field is treated as a **path**, and a new tab page is opened in combination with the domain name of the current page (User Console).
            *   [Not recommended] If `url` does not contain a protocol and does not start with `/`, the content of the `url` field is treated as a **subpath**, and a new tab page is opened in combination with the domain name and path of the current page (User Console).
        *   `config`: The [deployment configuration](#deployment-configuration) of the App, which can be the specific content of the template (YAML string) or a reference to a local file.
        *   `readinessProbe`: Detects whether the App is running normally. For configuration methods, see [App Running Detection](#app-running-detection).
        *   `dependencies`: Records the cluster environment on which the App depends, including API resources and services in the cluster. For configuration methods, see [Application Dependencies](#application-dependencies).

## CRD and Helm Templates

The system currently supports two types of App templates: Helm and CRD.

1)  Helm type App template example (simplified version):

    ```yaml
    apiVersion: app.tensorstack.dev/v1beta1
    kind: Template
    metadata:
     ...
    template:
     helm:
        repo: "oci://docker.io/t9kpublic"
        chart: "terminal"
        versions:
        - version: 0.1.1
          config: "file://$APP_DIR/manifests/v0_1_1.yaml"
          urls: []
          readinessProbe: {}
          dependencies: {}
    ```

2)  CRD application template example (simplified version):

    ```yaml
    apiVersion: app.tensorstack.dev/v1beta1
    kind: Template
    metadata:
      ...
    template:
      crd:
        group: tensorstack.dev
        resource: notebooks
        versions:
        - version: v1beta1
          config: "file://$APP_DIR/config.yaml"
          readme: "file://$APP_DIR/README.md"
          note: "file://$APP_DIR/NOTE.txt"
          urls: []
          readinessProbe: {}
          dependencies: {}
    ```

Comparison of the two:

*   The format and meaning of the `apiVersion`, `kind`, and `metadata` fields of the template are the same.
*   Helm App and CRD use different application declaration methods. The former uses the `repo` and `chart` fields to specify the location of the Helm Chart, while the latter uses the `group` and `resource` fields to specify the CRD type.
*   The `version` of a Helm App refers to the `version` field in `Chart.yaml` ([Chart.yaml File](https://helm.sh/docs/topics/charts/#the-chartyaml-file)), while the `version` of a CRD application refers to the [API Version](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definition-versioning/) of a CRD.
*   Helm App supports uploading README.md and NOTE.txt files at the same time when packaging, but CRD does not have this information after development and deployment. Therefore, in the application template, `readme` and `note` fields are added for CRD applications to supplement this information. The content of `note` can be filled in with Go Template, and the template variables that can be referenced are described in [Go Template Replacement Rules](#go-template-replacement-rules).
*   The meaning and content of other fields of the two types of Apps are the same and will be introduced in the subsequent content of the document.

> [!NOTE]
> 1.  Currently, `t9k-app` only supports unregistering a single App at a time, not batch unregistration.
> 2.  Currently, `t9k-app` only supports unregistering an entire App, not a specific version of an App. If a user wants to unregister a specific version of an App, they can remove the version information from the App template and then update the App.

## Deployment Configuration

When deploying Apps, users need to provide a **deployment configuration**.

When registering Apps, administrators can set a **deployment configuration template** for Helm applications and CRD applications through the `template.helm.versions[@].config` and `template.crd.versions[@].config` fields, respectively, to help users construct the deployment configuration.

Both of the above fields support filling in with external files and inline content.

1)  External file:

    ```yaml
    apiVersion: app.tensorstack.dev/v1beta1
    kind: Template
    template:
      helm: 
        versions:
        # Use local file path to fill in
        - config: "file://$APP_DIR/manifests/v0_1_1.yaml"
    ```

2)  Inline content:

    ```yaml
    apiVersion: app.tensorstack.dev/v1beta1
    kind: Template
    config:
      helm: 
        versions:
        # Use inline content to fill in
        - config: "# sh, bash or zsh\n## @param shell Select a shell to start terminal.\nshell: bash\n\n## @param resources.limits.cpu The maximum number of CPU the terminal can use.\n## @param resources.limits.memory The maximum number of memory the terminal can use.\nresources:\n  limits:\n    cpu: 200m\n    memory: 200Mi\n\n## @param resources.limits.cpu Mount pvcs to terminal.\npvcs: []\n\nglobal:\n  t9k:\n    homeURL: \"$(HOME_URL)\"\n    securityService:\n      enabled: true\n      endpoints:\n        oidc: \"$(OIDC_ENDPOINT)\"\n        securityServer: \"$(T9K_SECURITY_CONSOLE_SERVER_ENDPOINT)\"\n    pepProxy:\n      args:\n        clientID: $(APP_AUTH_CLINET_ID)"
    ```

Below is the deployment configuration template for the Terminal application:

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

Where:

*   The deployment page of the User Console will recognize all comments starting with `## @param` and integrate the fields specified by these comments into a web form to facilitate user filling.
    *   The format of the comment is `## @param <field-path> <field-description>`.
    *   (User Console versions after 1.79.7 support using `## @param[required] <field-path> <field-description>` to indicate required fields)
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

Two types of dependencies can be defined:

*   `crds`: The application depends on a specific CRD.
*   `services`: The application depends on a specific service. (Here, it is not checked whether the service is available, because the service may be temporarily unavailable due to network fluctuations, etc. When a similar situation occurs, it is easy for the application to fluctuate between "deployable" and "undeployable". Here, it is assumed that as long as the service exists, that is, the Service resource exists, the prerequisite for application deployment is met.)

## Go Template Replacement Rules

In the application template, some fields need to refer to the information of the application instance during deployment or the information of the resources generated after deployment, which are filled in Go Template format:

*   For Go Template syntax, please refer to: [https://developer.hashicorp.com/nomad/tutorials/templates/go-template-syntax](https://developer.hashicorp.com/nomad/tutorials/templates/go-template-syntax).
*   The variables used by Go Template are discussed below in the following three situations:
    1.  The application type is Helm;
    2.  The application type is CRD;
    3.  The Go Template variables used by the `readinessProbe.resources[@].currentStatus|message` field.

### Application Type is Helm

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

### Application Type is CRD

The Go Template in the CRD application template can refer to the fields in the deployment configuration.

Below is part of the deployment configuration for the JupyterLab application:

```yaml
apiVersion: tensorstack.dev/v1beta1
kind: Notebook
metadata:
  name: notebook-demo
  namespace: demo
spec:
  type: jupyter
  ...
```

Users can use `{{ .metadata.namespace }}` to refer to the namespace where the application instance is located, and `{{ .spec.type }}` to refer to the Notebook type.

> [!NOTE]
> If the `.metadata.namespace` field in the deployment configuration of the CRD application is not filled in, the App Server will automatically fill in this field according to the user's namespace, so there is no need to worry that the `{{ .metadata.namespace }}` variable will refer to a null value. However, other fields do not have default values, so you need to pay attention.

### readinessProbe.resources[@].currentStatus|message

Refers to the following fields:

*   `template.crd.versions[@].readinessProbe.resources[@].currentStatus`
*   `template.crd.versions[@].readinessProbe.resources[@].message`
*   `template.helm.versions[@].readinessProbe.resources[@].currentStatus`
*   `template.helm.versions[@].readinessProbe.resources[@].message`

> [!NOTE]
> Unlike other fields that support Go Template format, `currentStatus` and `message` are used to determine the status of sub-resources after the application instance is deployed, while other fields are parsed when the application instance is deployed.

Below is part of the application template for the Terminal application:

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

Assuming the user deploys an application named `demo`, according to the rules in [Helm Application Variables](#application-type-is-helm), the `name` field above is `terminal-demo`. Therefore, according to the `readinessProbe`, the instance controller needs to check the status of the `terminal-demo` Deployment. The variables in `currentStatus` above refer to the fields of the Deployment, and its logic is: find the `.status.conditions` with `type` as `Available` and return its `status` sub-field.
