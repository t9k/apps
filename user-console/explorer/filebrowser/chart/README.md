# FileBrowser

[FileBrowser](https://github.com/filebrowser/filebrowser) 在指定目录中提供了一个文件管理界面，可用于上传、删除、预览、重命名和编辑您的文件。

## 配置

### 示例

挂载存储卷 `tutorial` 作为工作空间：

```yaml
pvc: tutorial
```

### 参数

| 名称  | 描述                                                          | 值   |
| ----- | ------------------------------------------------------------- | ---- |
| `pvc` | 绑定一个 PVC 到 FileBrowser 上，作为 FileBrowser 的 workspace。 | `""` |
