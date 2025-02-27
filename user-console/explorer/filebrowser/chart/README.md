# File Browser

[File Browser](https://github.com/filebrowser/filebrowser) 在指定目录中提供了一个文件管理界面，可用于上传、删除、预览、重命名和编辑您的文件。

## 使用方法

待应用就绪后，点击右侧的 <svg width="1em" height="1em" class="MuiSvgIcon-root MuiSvgIcon-colorPrimary MuiSvgIcon-fontSizeMedium css-jxtyyz" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="OpenInNewIcon"><path d="M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3z"></path></svg> 进入网页 UI，即可管理文件。

![](https://s2.loli.net/2024/08/20/AeGUX6uPBSt47wq.png)

网页 UI 的使用方法简单直观，请用户自行尝试。

## 配置

请参阅[配置和使用说明](https://t9k.github.io/ucman/latest/app/filebrowser.html#%E9%85%8D%E7%BD%AE%E5%92%8C%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E)。

### 示例

挂载 PVC `tutorial` 作为工作空间：

```yaml
pvc: tutorial

resources:
  limits:
    cpu: 100m
    memory: 200Mi
```

### 字段

| 名称                      | 描述                                                            | 值      |
| ------------------------- | --------------------------------------------------------------- | ------- |
| `pvc`                     | 挂载到 File Browser 上的 PVC 名称，作为 File Browser 的工作空间 | `""`    |
| `resources.limits.cpu`    | File Browser 容器能使用的 CPU 上限                              | `100m`  |
| `resources.limits.memory` | File Browser 容器能使用的内存上限                               | `200Mi` |
