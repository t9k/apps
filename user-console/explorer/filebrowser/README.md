# FileBrowser

[FileBrowser](https://github.com/filebrowser/filebrowser) 在指定目录中提供了一个文件管理界面，可用于上传、删除、预览、重命名和编辑您的文件。

## 配置

### 示例

挂载存储卷 `tutorial` 作为文件管理空间：

```yaml
apiVersion: tensorstack.dev/v1beta1
kind: Explorer
metadata:
  name: "<would-be-auto-generated-and-DO-NOT-TOUCH-IT>"
spec:
  storageName: "tutorial"
  storageType: pvc
  type: FileBrowser
```

### 参数

| 名称               | 描述                                             | 值   |
| ------------------ | ------------------------------------------------ | ---- |
| `spec.storageName` | 指定一个 PVC，用 FileBrowser 管理 PVC 中的文件。 | `""` |
