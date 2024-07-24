# CodeServer

[CodeServer](https://github.com/coder/code-server) 是一个可以通过浏览器访问的 VSCode。

## 配置

### 示例

挂载存储卷 `tutorial` 作为工作空间：

```yaml
pvc: tutorial
```

### 参数

| 名称  | 描述                                                          | 值   |
| ----- | ------------------------------------------------------------- | ---- |
| `pvc` | 绑定一个 PVC 到 CodeServer 上，作为 CodeServer 的 workspace。 | `""` |
