# Jupyter Lab (Hygon DCU)

[Jupyter Lab](https://github.com/jupyterlab/jupyterlab) 是最新的基于 Web 的交互式开发环境，用于代码开发和数据处理。其灵活的界面允许用户配置和安排数据科学、科学计算和机器学习中的工作流程。

Jupyter Lab (Hygon GPU) 额外配置了海光 DCU，你可以在其中进行 DCU 相关的开发和测试。

## 镜像列表

当前应用可以选用以下镜像：

| 名称                                                                      | 环境      |
| ------------------------------------------------------------------------- | --------- |
| `registry.cn-hangzhou.aliyuncs.com/t9k/jupyterlab-torch-2.1.0:240708-dcu` | PyTorch 2 |

每个镜像包含特定的机器学习框架，同时预装了一些 Python 包、命令行工具和最新版本的平台工具。

## 配置

### 示例

选用 PyTorch 环境，申请 4 个 CPU（核心）、8 GiB 内存资源以及 1 个海光 DCU，挂载存储卷 `tutorial`：

```yaml
apiVersion: tensorstack.dev/v1beta1
kind: Notebook
metadata:
  name: "<would-be-auto-generated-and-DO-NOT-TOUCH-IT>"
spec:
  type: jupyter
  template:
    spec:
      containers:
        - name: notebook
          image: registry.cn-hangzhou.aliyuncs.com/t9k/jupyterlab-torch-2.1.0:240708-dcu
          volumeMounts:
            - name: workingdir
              mountPath: /t9k/mnt
          resources:
            limits:
              cpu: "4"
              memory: 8Gi
              hygon.com/dcu: 1
      volumes:
        - name: workingdir
          persistentVolumeClaim:
            claimName: "tutorial"
```

### 参数

| 名称                                                                | 描述                                                          | 值                                      |
| ------------------------------------------------------------------- | ------------------------------------------------------------- | --------------------------------------- |
| `spec.template.spec.containers[0].image`                            | Jupyter Lab 容器镜像。                                        | `t9kpublic/torch-2.1.0-notebook:1.77.1` |
| `spec.template.spec.containers[0].resources.limits.cpu`             | Jupyter Lab 最多能使用的 CPU 数量。                           | `4`                                     |
| `spec.template.spec.containers[0].resources.limits.memory`          | Jupyter Lab 最多能使用的内存数量。                            | `8Gi`                                   |
| `spec.template.spec.containers[0].resources.limits."hygon.com/dcu"` | Jupyter Lab 能使用的海光 DCU 数量。                           | `1`                                     |
| `spec.template.spec.volumes[0].persistentVolumeClaim.claimName`     | 绑定一个 PVC 到 Jupyter Lab 上，作为 Jupyter Lab 的工作空间。 | `""`                                    |