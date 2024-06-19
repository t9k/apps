# CodeServer

[CodeServer](https://github.com/coder/code-server) 是一个可以通过浏览器访问的 VSCode。

## 配置

### 示例

挂载存储卷 `tutorial` 作为工作空间：

```yaml
apiVersion: tensorstack.dev/v1beta1
kind: Explorer
metadata:
  name: "<would-be-auto-generated-and-DO-NOT-TOUCH-IT>"
spec:
  storageName: "tutorial"
  storageType: pvc
  type: CodeServer
```

### 参数

| 名称               | 描述                                                          | 值   |
| ------------------ | ------------------------------------------------------------- | ---- |
| `spec.storageName` | 绑定一个 PVC 到 CodeServer 上，作为 CodeServer 的 workspace。 | `""` |
