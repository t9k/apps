# Application Development

[中文](./dev_zh.md)

This article describes the development process for Apps.

## Helm Apps

The development of Helm-based Apps involves the following steps:

1.  Containerize the App, build a container image, and use K8s APIs and services.
2.  Package the application using a Helm Chart that conforms to the T9k Apps specification.
3.  Publish the App using the specifications and processes defined by T9k Apps.

### Building the Image

> [!NOTE]
> 1.  "Image" is short for container image.
> 2.  If the App uses an existing image, this step can be skipped.

Building an image generally requires:

*   A `Dockerfile`: A text file that contains the steps for building the image.
*   Context: Building an image sometimes requires local files, which constitute the context for the build process.

Refer to [Docker: Building Images](https://docs.docker.com/build/building/packaging/).

Here is a simple `Dockerfile`:

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

In this image, we use the `centos:7.6.1810` base image, install tools like `gcc`, and install the `ttyd` software. Finally, we specify `ttyd -p 8080 bash` as the default container startup command.
For more `Dockerfile` syntax, please refer to [Docker: Dockerfile Reference](https://docs.docker.com/reference/dockerfile/).

After preparing the `Dockerfile` and context, use the following command to build the image:

```bash
docker build -f <dockerfile-path> -t <image-tag> <runtime-path>
```

The built image needs to be uploaded to an image repository so that it can be pulled for use on other machines:

```bash
docker push <image-tag>
```

### Developing the Helm Chart

> [!NOTE]
> If you are using an existing Helm Chart, you can skip this step. However, since T9k Apps' Charts need to conform to specific specifications, users will generally need to build their own Charts.

A Helm Chart example:

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

Where:

*   `Chart.yaml`: Basic information about the Chart.
*   `README.md`: An introduction to the Chart. After the application is successfully registered, users can see this content on the application introduction page in the User Console.
*   `templates`: Helm template files, which generally include:
    *   `NOTES.txt`: Introduces information about a Helm Release (an instance of a deployed Helm Chart).
    *   Template files: K8s resource templates, which can use some logical statements and functions.
*   `values.yaml`: The default configuration (Default Values) of the Helm Chart.
*   For more information on Helm Charts, please refer to [Helm: Getting Started](https://helm.sh/docs/chart_template_guide/getting_started/).

#### Setting Values

T9k Apps supports two ways to set the `Values` of a Chart:

1.  Default Values: The default variable values of the Helm Chart, recorded in the `values.yaml` file during Helm Chart development.
2.  User Values: Additional variable values. Users set these when deploying the application. The server will merge these Values with the Default Values (User Values have higher priority in case of field conflicts) and then use them to deploy the App.

#### Debugging

Before uploading the Helm Chart, developers should complete a full test in the cluster to ensure that the Chart is indeed usable.

Here is a simple process for testing with the contents of the local folder `./chart`:

1) Use `helm template` to generate the deployment manifest:

```bash
helm template <release-name> -n <release-ns> ./chart > manifests.yaml
```

Developers should check the generated `manifests.yaml` file to ensure it meets expectations.

2) Use `helm install` to deploy the application:

```bash
helm install <release-name> -n <release-ns> ./chart
```

3) After the application is deployed to the cluster, developers should check whether the application is running normally and can be accessed.

#### Uploading

After debugging the Helm Chart, package it:

```bash
helm package ./chart
```

After executing the command, the Helm Chart will be packaged into a `.tgz` file with the format `<chart-name>-<chart-version>.tgz`.

Upload the packaged Helm Chart to the Chart repository:

```bash
helm push <tgz-file> <registry-url>
```

> [!NOTE]
> Generally, a public repository such as Docker Hub is used, in which case the `<registry-url>` format is similar to `oci://docker.io/t9kpublic`. However, if Docker Hub is not accessible, users will need to use other OCI Registry cloud services or set up their own `oci` repository, see [Harbor](https://goharbor.io/).

#### Notes

1.  If the App needs to set a Service Account, you can use the pre-configured ServiceAccount `managed-project-sa` in the Project, which has full permissions in the user's Project. Do not create additional ServiceAccounts, Roles, RoleBindings, or other RBAC resources.

2.  If the pre-configured Service Account does not meet the needs of the user's App, the user needs to contact the system administrator to obtain the appropriate RBAC settings.

### Publishing the App

The App publishing process completes the definition of the relevant App Template and configuration files for the Helm Chart to support App registration.

Generally, the following should be prepared:

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

Where:

*   `configs` folder: Stores the default deployment configurations for each version of the application, which is the default configuration displayed to the user when deploying the application in the frontend.
*   `icon.png`: The application icon.
*   `template.yaml`: The application template file.

The format of the above content can be found in [Application Template](./template.md).

Below is the template file for the Terminal application:

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
    chart:
      repo: "oci://docker.io/t9kpublic"
      name: "terminal"
      version: 0.2.1
    config: "file://$APP_DIR/configs/v0_2_1.yaml"
    ...
```

Where:

*   `metadata.icon.url` specifies the address of the icon. In addition to local files, it also supports using internet images via URL.
*   `template.versions[@].config` sets the default deployment configuration file for each version of the application.
*   `template.versions[@].chart` specify the repository address, name and version of the Chart uploaded in the [Developing the Helm Chart](#developing-the-helm-chart) section.

For more information on application templates, please refer to [Application Template](./template.md).

Use the command-line tool `t9k-app` to register the application:

```bash
export APIKEY='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
export APP_SERVER='https://home.sample.t9kcloud.cn/t9k/app/server'
t9k-app register \
  -k $APIKEY \
  -s $APP_SERVER \
  -f template.yaml
```

Use the following command to check if the application was registered successfully:

```bash
t9k-app list -k $APIKEY -s $APP_SERVER | grep terminal
```

#### Deployment and Testing

Log in to the User Console page and go to the deployment interface of the registered application:

Check:

1.  Whether the version information is as expected.
2.  Whether the content of the form, YAML editor, and README is as expected.
3.  After deployment, check whether the resources created in the cluster are as expected and whether the application link works properly.

Uninstall the application and check for any residual data. (Some data legacy behavior is expected, for example, if you want to keep the data generated by the application for other purposes after uninstalling it.)


