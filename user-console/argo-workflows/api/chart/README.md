# Argo Workflows API

[Argo Workflows](https://argo-workflows.readthedocs.io/en/latest/) 是一个开源的工作流引擎，用于编排多步骤并行作业。

本 chart 包含 Argo Workflows 的 CRD 和控制器部分，方便管理员安装在 TensorStack 平台的控制平面。

## 安装

通过以下命令在 TensorStack 平台中安装 Argo Workflows API：

```bash
helm install argo-workflows-api oci://docker.io/t9kpublic/argo-workflows-api --version 0.1.0 -n t9k-system -f ./values.yaml
```

查看安装情况：

```bash
kubectl get pod -n t9k-system -l app=argo-workflow-controller
NAME                                        READY   STATUS    RESTARTS   AGE
argo-workflow-controller-54b7d46d9b-cdhfh   1/1     Running   0          8s
```

## 配置

为了普通用户能够在项目中管理 Argo Workflows 相关资源，管理员需要编辑项目的 RBAC 设置（[参考](https://github.com/t9k/apps/blob/master/docs/register.md#%E7%94%A8%E6%88%B7%E6%9D%83%E9%99%90)）：

```bash
kubectl edit clusterrole project-operator-user-default-perms
```

在 `rules` 字段添加以下部分：

```yaml
- apiGroups:
  - argoproj.io
  resources:
  - '*'
  verbs:
  - '*'
```
