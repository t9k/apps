# Argo Workflows API

[Argo Workflows](https://argo-workflows.readthedocs.io/en/latest/) 是一个开源的工作流引擎，用于编排多步骤并行作业。

本 chart 包含 Argo Workflows 的 CRD 和控制器部分，方便管理员安装在 TensorStack 平台的控制平面。

## 安装

通过以下命令在 TensorStack 平台中安装 Argo Workflows API：

```bash
helm install argo-workflows-api oci://docker.io/t9kpublic/argo-workflows-api --version 0.2.0 -n t9k-system -f ./values.yaml
```

查看安装情况：

```bash
kubectl get pod -n t9k-system -l app=argo-workflow-controller
NAME                                        READY   STATUS    RESTARTS   AGE
argo-workflow-controller-54b7d46d9b-cdhfh   1/1     Running   0          8s
```
