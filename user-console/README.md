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
export APP_SERVER='https://home.example.t9kcloud.cn/t9k/app/server'
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
t9k-app unregister <app-name> -s <server> -k <apikey> [flags]
```

参数说明：

* <app-name>：应用的名称，注意不是展示名称（display name）。
* `-k`：一个具有管理员权限的 API key。
* `-s`：App Server 服务地址。

## 参考

[应用模板 (template.yaml) 规范](./specs.md)
