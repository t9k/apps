# Apps 注册与注销

t9k-app 命令行工具的下载和使用方式，请参考 [附录](./appendix.md#命令行工具-----t9k-app)。

注册和注销 Apps 需要管理员权限，可通过设置具有管理员权限的 API Key 达到（参考 [附录](./appendix.md#获取管理员-api-key)）； App Server 地址根据产品安装的 DNS 获得，例如：

```bash
export APIKEY='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

# APP_SERVER 的格式一般为 https://<home-domain>/t9k/app/server，其中 <home-domain>，可从 User Console URL 中获取
export APP_SERVER='https://home.sample.t9kcloud.cn/t9k/app/server'
```

注册一个 App 需要提供该 App 的定义，通过一个 Template 类型的 YAML 文件实现。例如 [jupyter-lab-cpu/template.yaml](https://github.com/t9k/apps/blob/master/user-console/notebook/jupyter-lab-cpu/template.yaml) 定义了一个 “CPU 版的 JupyterLab App”。

TensorStack 提供一些常用 Apps 的 Template 文件，存放在 [https://github.com/t9k/apps](https://github.com/t9k/apps)，可方便下载：

```bash
git clone https://github.com/t9k/apps.git
```

## 注册 Apps

注册单个 App：

```bash
t9k-app register \
  -k $APIKEY \
  -s $APP_SERVER \
  -f user-console/terminal/template.yaml
```

（模版文件介绍参考 [应用模版](./template.md#应用模版)）

更新（`-u`）已注册的单个 App（例如更新 Helm Chart 版本）：

```bash
t9k-app register -u \
  -k $APIKEY \
  -s $APP_SERVER \
  -f user-console/terminal/template.yaml
```

> [!NOTE]
> 如果使用 `-u` 参数而 App 尚未注册，则会直接注册 App。

批量注册多个 Apps：

```bash
# 方法 1: 使用 -f 参数选择多个应用模版
t9k-app register \
  -k $APIKEY \
  -s $APP_SERVER \
  -f user-console/terminal/template.yaml \
  -f user-console/notebook/template.yaml

# 方法 2: 使用通配符 * 匹配所有应用模版
t9k-app register \
  -k $APIKEY \
  -s $APP_SERVER \
  -f "user-console/*/template.yaml"
```

> [!NOTE]
> 一个模版文件中可以包含多个应用模版，用 `---` 分割。

## 注销 Apps

查看当前 Apps 列表：

```bash
t9k-app list -k $APIKEY -s $APP_SERVER
```

输出结果：

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

注销 Apps：

```bash
# 注销应用，应提供应用的 name 而非 display name
t9k-app unregister -k $APIKEY -s $APP_SERVER terminal
```

> [!NOTE]
> 目前 t9k-app 仅支持注销单个 App，不支持批量注销。

> [!NOTE]
> 目前 t9k-app 仅支持注销整个 App，不支持注销 App 的特定版本。如果用户想要注销 App 的某一特定版本，可以在 App 模板中去掉该版本信息，然后更新该 App。

> [!IMPORTANT]
> 注销应用不会卸载用户已经安装的 Apps。

## 用户权限

一些 Apps 可能需要特定的 RBAC 权限才能正确部署，管理员在注册新应用时，应评估这些 RBAC 需求的合理性，及其风险。

如需修改项目的 RBAC 设置，可通过执行以下命令：

```bash
kubectl edit clusterrole project-operator-project-role
```
