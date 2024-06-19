# RStudio

[RStudio](https://github.com/rstudio/rstudio) 集成开发环境旨在帮助你提高 R 和 Python 的工作效率。

## 镜像列表

当前应用可以选用以下镜像：

| 名称                                    | 环境      |
| --------------------------------------- | --------- |
| `t9kpublic/rocker-4.2.3-rstudio:1.72.1` | R, Python |

## 配置

### 示例

申请较多的 CPU、内存资源，挂载存储卷 `tutorial`：

```yaml
apiVersion: tensorstack.dev/v1beta1
kind: Notebook
metadata:
  name: "<would-be-auto-generated-and-DO-NOT-TOUCH-IT>"
spec:
  type: rstudio
  template:
    spec:
      containers:
        - name: notebook
          image: t9kpublic/rocker-4.2.3-rstudio:1.72.1
          volumeMounts:
            - name: workingdir
              mountPath: /t9k/mnt/workspace
          resources:
            limits:
              cpu: "16"
              memory: 32Gi
      volumes:
        - name: workingdir
          persistentVolumeClaim:
            claimName: tutorial"
```

### 参数

| 名称                                                            | 描述                                                  | 值                                      |
| --------------------------------------------------------------- | ----------------------------------------------------- | --------------------------------------- |
| `spec.template.spec.containers[0].image`                        | RStudio 容器镜像。                                    | `t9kpublic/rocker-4.2.3-rstudio:1.72.1` |
| `spec.template.spec.containers[0].resources.limits.cpu`         | RStudio 最多能使用的 CPU 数量。                       | `16`                                    |
| `spec.template.spec.containers[0].resources.limits.memory`      | RStudio 最多能使用的内存数量。                        | `32Gi`                                  |
| `spec.template.spec.volumes[0].persistentVolumeClaim.claimName` | 绑定一个 PVC 到 RStudio 上，作为 RStudio 的工作空间。 | `""`                                    |
