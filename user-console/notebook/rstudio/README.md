# RStudio

RStudio 集成开发环境 （IDE），旨在帮助你提高 R 和 Python 的工作效率。

## 配置

| name | description | value |
|------|-------------|-------|
| `spec.template.spec.containers[0].image` | RStudio 容器镜像。 | `t9kpublic/rocker-4.2.3-rstudio:1.72.1` | 
| `spec.template.spec.containers[0].resources.limits.cpu` | RStudio 最多能使用的 CPU 数量。 | `16` | 
| `spec.template.spec.containers[0].resources.limits.memory` | RStudio 最多能使用的内存数量。 | `32Gi` | 
| `spec.template.spec.volumes[0].persistentVolumeClaim.claimName` | 绑定一个 PVC 到 RStudio 上，作为 RStudio 的工作空间。 | `""` | 
