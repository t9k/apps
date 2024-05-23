# CephFS for K8s

https://github.com/ceph/ceph-csi/tree/v3.7.2/examples

```bash
k describe pod -n xuda cephfs-demo-pod

Events:
  Type     Reason              Age                  From                     Message
  ----     ------              ----                 ----                     -------
  Normal   Scheduled           7m16s                default-scheduler        Successfully assigned xuda/cephfs-demo-pod to nuc
  Warning  FailedMount         5m14s                kubelet                  Unable to attach or mount volumes: unmounted volumes=[mypvc], unattached volumes=[kube-api-access-k9vnh mypvc]: timed out waiting for the condition
  Warning  FailedAttachVolume  75s (x3 over 5m17s)  attachdetach-controller  AttachVolume.Attach failed for volume "pvc-ac5c052e-ce15-473b-a7b5-ad49f8d51d3c" : timed out waiting for external-attacher of cephfs.csi.ceph.com CSI driver to attach volume 0001-0024-0a5b9dda-762b-11ed-961b-1db3ce2e7b2f-0000000000000001-fc0369a1-76b9-11ed-9ddd-de4d64fb32c6
  Warning  FailedMount         47s (x2 over 3m1s)   kubelet                  Unable to attach or mount volumes: unmounted volumes=[mypvc], unattached volumes=[mypvc kube-api-access-k9vnh]: timed out waiting for the condition
```
