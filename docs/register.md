# App Registration and Unregistration

[中文](./register_zh.md)

For instructions on how to download and use the `t9k-app` command-line tool, please refer to the [Appendix](./appendix.md#command-line-tool---t9k-app).

Registering and unregistering Apps requires administrator privileges, which can be obtained by setting an API Key with administrator privileges (see [Appendix](./appendix.md#get-administrator-api-key)). The App Server address is obtained from the DNS of the product installation, for example:

```bash
export APIKEY='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

# The format of APP_SERVER is generally https://<home-domain>/t9k/app/server, where <home-domain> can be obtained from the User Console URL
export APP_SERVER='https://home.sample.t9kcloud.cn/t9k/app/server'
```

Registering an App requires providing its definition through a Template-type YAML file. For example, [jupyter-lab-cpu/template.yaml](https://github.com/t9k/apps/blob/master/user-console/notebook/jupyter-lab-cpu/template.yaml) defines a "CPU version of JupyterLab App".

TensorStack provides Template files for some common Apps, which are stored at [https://github.com/t9k/apps](https://github.com/t9k/apps) and can be easily downloaded:

```bash
git clone https://github.com/t9k/apps.git
```

## Preparations

### [Optional] Using a Custom Helm Chart Source

When registering an APP, the APP Server pulls the Helm Chart from the address specified in the Template file.

For example, in [jupyter-lab-cpu/template.yaml](https://github.com/t9k/apps/blob/master/user-console/notebook/jupyter-lab-cpu/template.yaml), part of the file content is as follows:

```yaml
...
template:
  versions:
  - version: v1
    chart:
      repo: "oci://docker.io/t9kpublic"
      name: "jupyterlab-cpu"
      version: 0.2.0
...
```

Then, when registering the APP, the APP Server will pull the Helm Chart of version 0.2.0 from `oci://docker.io/t9kpublic/jupyterlab-cpu`, which is similar to:

```bash
helm pull oci://docker.io/t9kpublic/jupyterlab-cpu --version 0.2.0
```

Modify the Template file:

```bash
sed -i 's|repo: "oci://docker.io/t9kpublic"|repo: oci://<custom-chart-source>|g' <template-file>
```

> [!NOTE]
> You also need to upload the Helm Chart to the corresponding address. You can usually use the scripts in [tools](https://github.com/t9k/apps/blob/master/tools) to do this, for example, to read the APP's `template.yaml` file and migrate all the Helm Charts used in it:
>
> ```bash
> tools/chart-mirror.sh user-console/notebook/jupyterlab-cpu --source docker.io/t9kpublic --target <custom-chart-source>
> ```

This way, you can use a custom Helm Chart source to register the APP.

### [Optional] Using a Custom Image Source

When a user installs an APP, the APP needs to pull an image to run the container.

For example, in [jupyter-lab-cpu/configs/v0_2_0.yaml](https://github.com/t9k/apps/blob/master/user-console/notebook/jupyter-lab-cpu/configs/v0_2_0.yaml), part of the file content is as follows:

```yaml
image:
  registry: "$(T9K_APP_IMAGE_REGISTRY)"
  repository: "$(T9K_APP_IMAGE_NAMESPACE)/torch-2.1.0-notebook"
  tag: "20240716"
```

If the user does not modify the above configuration when installing the APP, the image `$(T9K_APP_IMAGE_REGISTRY)/$(T9K_APP_IMAGE_NAMESPACE)/torch-2.1.0-notebook:20240716` will be pulled by default.

You can customize the default image pull address by setting the [system variables](./template.md#system-variables) `$(T9K_APP_IMAGE_REGISTRY)` and `$(T9K_APP_IMAGE_NAMESPACE)`. The values of these system variables can be viewed as follows:

```bash
kubectl -n t9k-system get configmap app-config -o yaml
```

```yaml
...
data:
  client-config.json: |-
    {
      "variables":{
        ...
        "T9K_APP_IMAGE_REGISTRY": "docker.io",
        "T9K_APP_IMAGE_NAMESPACE": "t9kpublic",
        ...
      },
...
```

Run the following command to modify the system variables:

```bash
kubectl -n t9k-system edit configmap app-config
```

Restart the service and wait for the new Pod to run normally for the system variable changes to take effect:

```bash
kubectl -n t9k-system rollout restart deployment app-instance-controller-manager
kubectl -n t9k-system get pod -l control-plane=app-instance -w
```

> [!NOTE]
> You also need to upload the image to the corresponding address. You can usually use the scripts in [tools](https://github.com/t9k/apps/blob/master/tools) to do this, for example, to read all the files in the APP's `configs` folder and migrate all the images used in them:
>
> ```bash
> tools/image-mirror.sh user-console/notebook/jupyterlab-cpu --source docker.io/t9kpublic --target <custom-image-source>
> ```

This way, you can use a custom default image address.

## Registering Apps

Register a single App:

```bash
t9k-app register \
  -k $APIKEY \
  -s $APP_SERVER \
  -f user-console/terminal/template.yaml
```

(For an introduction to template files, see [Application Template](./template.md#application-template))

Update (`-u`) a single registered App (e.g., to update the Helm Chart version):

```bash
t9k-app register -u \
  -k $APIKEY \
  -s $APP_SERVER \
  -f user-console/terminal/template.yaml
```

> [!NOTE]
> If you use the `-u` parameter and the App is not yet registered, the App will be registered directly.

Register multiple Apps in batch:

```bash
# Method 1: Use the -f parameter to select multiple application templates
t9k-app register \
  -k $APIKEY \
  -s $APP_SERVER \
  -f user-console/terminal/template.yaml \
  -f user-console/notebook/template.yaml

# Method 2: Use the wildcard * to match all application templates
t9k-app register \
  -k $APIKEY \
  -s $APP_SERVER \
  -f "user-console/*/template.yaml"
```

> [!NOTE]
> A template file can contain multiple application templates, separated by `---`.

## Unregistering Apps

View the current list of Apps:

```bash
t9k-app list -k $APIKEY -s $APP_SERVER
```

Output:

```
NAME               DISPLAY NAME                DEFAULT VERSION     CATEGORIES
codeserver         Code Server                 0.1.2               Tool
comfyui            ComfyUI                     0.1.1               AI
dify               Dify                        0.3.7               AI
filebrowser        FileBrowser                 0.1.2               Tool
fish-speech        Fish Speech                 0.1.0               AI
gpt-researcher     GPT Researcher              0.1.5               AI
job-manager        Job Manager                 0.1.2               Tool, AI
jupyterlab-cpu     JupyterLab (CPU)            0.1.2               IDE
jupyterlab-gpu     JupyterLab (Nvidia GPU)     0.1.2               IDE
label-studio       Label Studio                1.4.8               AI, Tool
```

Unregister an App:

```bash
# To unregister an application, you should provide its name, not its display name
t9k-app unregister -k $APIKEY -s $APP_SERVER terminal
```

> [!NOTE]
> Currently, `t9k-app` only supports unregistering a single App at a time, not batch unregistration.

> [!NOTE]
> Currently, `t9k-app` only supports unregistering an entire App, not a specific version of an App. If a user wants to unregister a specific version of an App, they can remove the version information from the App template and then update the App.

> [!IMPORTANT]
> Unregistering an application will not uninstall Apps that users have already installed.

## User Permissions

Some Apps may require specific RBAC permissions to be deployed correctly. When registering a new application, administrators should evaluate the reasonableness and risks of these RBAC requirements.

To add additional namespace-scoped RBAC permissions for users, create a ClusterRole with the label `tensorstack.dev/user-namespace-perm: "true"`, for example:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    tensorstack.dev/user-namespace-perm: "true"
  name: user-namespace-perm-extra
rules:
- apiGroups:
  - tensorstack.dev
  resources:
  - simplemlservices
  verbs:
  - '*',
```

To add additional cluster-scoped RBAC permissions for users, create a ClusterRole with the label `tensorstack.dev/user-cluster-perm: "true"`, for example:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    tensorstack.dev/user-cluster-perm: "true"
  name: user-cluster-perm-extra
rules:
- apiGroups:
  - argoproj.io
  resources:
  - clusterworkflowtemplates
  verbs:
  - get
  - list
  - watch
```

> [!IMPORTANT]
> The cluster-scoped RBAC permissions for users should not exceed get/list/watch, otherwise users in different namespaces can modify the same cluster-scoped resources and affect each other.
