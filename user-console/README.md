# User Console 应用 （Apps）

TensorStack AI 平台的 User Console 提供了运行 **应用（Apps）** 的功能。管理员需要先向 App Server 注册 Apps，然后用户可以在 User Console 安装和使用 Apps。

## 目录结构

当前目录下组织存放了所有可注册 Apps 的相关文件，结构如下：

1. 每个子目录一般对应一个 App，但也可多个（例如 [notebook](./notebook/)）；
2. 每个子目录下的 `template.yaml` 文件为 **应用模版**（参考：[应用模板规范](../docs/template.md)），用于注册应用；
3. 每个子目录下可进一步创建子目录以存放其他开发文件，例如 `chart/` 存放 Helm Chart 文件，`docker/` 存放 Dockerfile。

## 相关文档

* [Apps 的注册和注销](../docs/register.md)
* [Apps 模版的格式](../docs/template.md)
* [Apps 开发](../docs/dev.md)
