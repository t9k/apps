# Code Server

基于浏览器的 VSCode 环境。

## 支持 NVIDIA 以外的 GPU 类型

本应用模板使用 NVIDIA GPU 作为加速设备，如果你想要换用其他 GPU 类型并注册应用，请进行如下操作：

1. 修改 `template.yaml` 的第 4（模板名称）、5（模板展示名称）、11（helm chart repo）、13（helm chart 名称）行；
2. 修改最新 config（例如 `configs/v0.3.2.yaml`）的第 7-9（默认镜像）、17（扩展资源字段注解）、22（扩展资源名称）行，必要时添加环境变量、额外的卷/卷挂载、安全上下文等；
3. 修改 `chart/README.md` 的第 61-63（默认服务器镜像）、68（扩展资源名称）、86-93（使用加速设备可以选用的镜像）行，同时修改所有示例的服务器镜像和扩展资源名称，必要时在示例中添加环境变量、额外的卷/卷挂载、安全上下文等；
4. 修改 `chart/Chart.md` 的第 2（helm chart 名称）、6（JupyterLab 版本）行；
5. 打包 helm chart 并推送；
6. 注册修改后的应用。

你可以参考 `variations/` 下的示例文件。
