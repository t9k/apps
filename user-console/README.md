# User Console 应用

TensorStack AI 平台的 User Console 提供了运行应用的功能。管理员需要先向 App Server 注册**应用**，然后用户可以在 User Console 部署和使用**应用实例**。

## 目录结构

当前目录下组织存放了所有可注册应用的相关文件，结构如下：

1. 每个子目录一般对应一个应用，但也可多个（例如 `notebook/` 和 `vllm/` ）。
2. 每个子目录下的 `template.yaml` 文件为**应用模版**（参考：[应用模板规范](./specs.md)），用于注册应用。
3. 每个子目录下可进一步创建子目录以存放其他开发文件，例如 `chart/` 存放 Helm Chart 文件，`docker/` 存放 Dockerfile。

## 相关文档

* [应用的注册和注销](../docs/register.md)
* [应用模版的格式](../docs/template.md)
* [应用开发](../docs/develope.md)
