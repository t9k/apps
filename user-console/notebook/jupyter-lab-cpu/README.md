# Jupyter Lab

Jupyter Lab 是最新的基于 Web 的交互式开发环境，用于代码开发和数据处理。其灵活的界面允许用户配置和安排数据科学、科学计算、计算新闻和机器学习中的工作流程。

## 配置

| name | description | value |
|------|-------------|-------|
| `spec.template.spec.containers[0].image` | Jupyter Lab 容器镜像。 | `t9kpublic/torch-2.1.0-notebook:1.77.1` | 
| `spec.template.spec.containers[0].resources.limits.cpu` | Jupyter Lab 最多能使用的 CPU 数量。 | `16` | 
| `spec.template.spec.containers[0].resources.limits.memory` | Jupyter Lab 最多能使用的内存数量。 | `32Gi` | 
| `spec.template.spec.volumes[0].persistentVolumeClaim.claimName` | 绑定一个 PVC 到 Jupyter Lab 上，作为 Jupyter Lab 的工作空间。 | `""` | 
