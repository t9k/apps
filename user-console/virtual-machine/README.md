# Virtual Machine API 安装

[kubevirt](https://kubevirt.io/) 是一个强大的虚拟化工具，它允许用户在 Kubernetes 容器化环境下启动一个虚拟机，并利用 Kubernetes 的扩展能力，让用户可以轻松地使用和管理虚拟机。

Virtual Machine 是一个基于 kubevirt 的虚拟机 App，允许用户快速部署一个虚拟机。在注册 Virtual Machine 应用之前，管理员应确保集群中已经安装 kubevirt。

本教程介绍如何安装 kubevirt 以及如何配置 kubevirt 的常用功能。

## 安装 kubevirt

在一台具有集群管理员权限的节点终端中，执行以下命令安装 kubevirt：

```bash
# Point at latest release
export RELEASE=$(curl https://storage.googleapis.com/kubevirt-prow/release/kubevirt/kubevirt/stable.txt)
# Deploy the KubeVirt operator
kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/kubevirt-operator.yaml
# Create the KubeVirt CR (instance deployment request) which triggers the actual installation
kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/kubevirt-cr.yaml
# wait until all KubeVirt components are up
kubectl -n kubevirt wait kv kubevirt --for condition=Available
```

如果硬件虚拟化不可用，则可以通过在 KubeVirt CR 中将 `spec.configuration.developerConfiguration.useEmulation` 设置为 `true` 来启用软件仿真，如下所示：

```bash
kubectl edit -n kubevirt kubevirt kubevirt
```

按照如下方式修改：

```yaml
spec:
  ...
  configuration:
    developerConfiguration:
        useEmulation: true
```

<aside class="note info">
<div class="title">硬件虚拟化检测</div>

连接到节点终端，执行以下命令，如果检测结果为 `PASS`，则表示硬件支持虚拟化：

```bash
$ virt-host-validate qemu
  QEMU: Checking for hardware virtualization                                 : PASS
  QEMU: Checking if device /dev/kvm exists                                   : PASS
  QEMU: Checking if device /dev/kvm is accessible                            : PASS
  QEMU: Checking if device /dev/vhost-net exists                             : PASS
  QEMU: Checking if device /dev/net/tun exists                               : PASS
...
```

</aside>

## 启用 GPU 功能

本节介绍如何配置集群，使虚拟机可以通过 passthrough 的方式使用 GPU。 

配置 GPU passthrough 需要执行以下步骤：

1. 准备节点环境：检查节点是否支持虚拟化、替换 GPU 驱动为 `vfio-pci`。
2. 安装 Device Plugin：将 GPU 资源暴露出来，以供虚拟机使用。
3. 配置 Kubevirt GPU 特性门：使虚拟机控制器知道如何给新创建的虚拟机绑定 GPU 设备。

<aside class="note warning">
<div class="title">注意</div>

在完成第一步后，对应节点上的 GPU 将只能用于虚拟机，无法再被其他容器使用。原因是普通的容器使用 GPU 需要节点上安装对应驱动，如 `nvidia`，但是虚拟机需要在节点上安装 `vfio-pci` 驱动。

</aside>

### 演示环境

节点名称：`node01`

GPU 型号及数量：`NVIDIA GeForce GTX 1080 Ti` * 2

### 配置方法

#### 准备工作

在修改节点环境时，会导致节点不可用。所以配置节点环境前，执行以下命令来清空节点并设置节点为不可被调度：

```bash
kubectl drain node01 --delete-emptydir-data --force --ignore-daemonsets
```

在本节内容全部配置完成后，再执行以下命令，重新启用该节点：

```bash
kubectl uncordon node01
```

将节点上 GPU 设置为通过 passthrough 方式访问，将导致 GPU 不能被普通容器使用，这会导致 GPU Operator 无法工作，运行下列命令可以清除节点 node01 上的 GPU Operator 组件：

```bash
kubectl label node node01 nvidia.com/gpu.deploy.operands=false
```

#### 准备节点环境

检查节点 CPU 是否支持硬件虚拟化：

```bash
egrep -c '(vmx|svm)' /proc/cpuinfo
```

输出结果不为 0，则表示 cpu 支持虚拟化.

连接 node01 节点终端：

```bash
ssh user@node01
```

本节剩余操作将全部在节点终端中执行。

启用 IOMMU、关闭 nouveau：

1. 修改 `/etc/default/grub` 文件
    1. 给 GRUB_CMDLINE_LINUX 变量添加 `intel_iommu=on modprobe.blacklist=nouveau`（多个参数之间用空格隔开）。
2. 使上述配置生效：`sudo update-grub`。
3. 重启节点：`sudo reboot`。

在节点启动后，重新执行 ssh 命令进入节点，检查上述配置是否生效：

* 检查 IOMMU 是否生效：`dmesg | grep -E "DMAR|IOMMU"`。
* 检查 nouveau 是否被禁止：`dmesg | grep -i nouveau`。
* 检查 interrupt remapping 是否可用：`dmesg | grep 'remapping'`。

启用 `vfio-pci` 驱动：

1. 获取节点 GPU 设备号：`lspci -nn | grep -i nvidia`，输出结果参考：
    ```bash
    02:00.0 VGA compatible controller [0300]: NVIDIA Corporation GP102 [GeForce GTX 1080 Ti] [10de:1b06] (rev a1)
    02:00.1 Audio device [0403]: NVIDIA Corporation GP102 HDMI Audio Controller [10de:10ef] (rev a1)
    83:00.0 VGA compatible controller [0300]: NVIDIA Corporation GP102 [GeForce GTX 1080 Ti] [10de:1b06] (rev a1)
    83:00.1 Audio device [0403]: NVIDIA Corporation GP102 HDMI Audio Controller [10de:10ef] (rev a1)
    ```
    1. `10de:1b06` 为设备 ID，在后续步骤中使用。
2. 在 modprobe 中注册 vfio：
    1. `echo "options vfio-pci ids=10de:1b06" > /etc/modprobe.d/vfio.conf`
    2. `echo 'vfio-pci' > /etc/modules-load.d/vfio-pci.conf`
3. 修改 `/etc/default/grub` 文件：
    1. 给 GRUB_CMDLINE_LINUX 变量添加 `vfio-pci.ids=10de:1b06`（多个参数之间用空格隔开）。
4. 使上述配置生效：`sudo update-grub`。
5. 重启节点：`sudo reboot`。

执行 `lspci -nnk -d 10de:`，如果 GPU 设备信息中出现 `Kernel driver in use: vfio-pci`，则表示 `vfio-pci` 驱动生效。

#### 安装 Device Plugin

下载 Device Plugin 代码：

```bash
git clone https://github.com/NVIDIA/kubevirt-gpu-device-plugin.git
```

部署 Device Plugin：

```bash
cd ./kubevirt-gpu-device-plugin/manifests
kubectl apply -f nvidia-kubevirt-gpu-device-plugin.yaml
```

查看 Device Plugin 添加的资源类型：

```bash
kubectl get nodes node01 -o json | jq .status.capacity
```

新添加的资源为 `nvidia.com/GP102_GEFORCE_GTX_1080_TI`，资源名称取决于节点上的设备名称。

#### 配置虚拟机控制器

执行以下命令修改 kubevirt 的配置：

```bash
$ kubectl edit kubevirt kubevirt -n kubevirt
```

按照如下 YAMl 修改 kubevirt 配置：

```yaml
...
spec:
  configuration:
    permittedHostDevices:
      pciHostDevices:
      - pciVendorSelector: "10DE:20F1"
        resourceName: "nvidia.com/GP102_GEFORCE_GTX_1080_TI"
        externalResourceProvider: true
    developerConfiguration:
      featureGates:
      - GPU
```

在上述配置中：

1. 添加资源类型：
    1. 设备名称：`nvidia.com/GP102_GEFORCE_GTX_1080_TI`。
    2. 设备号：`10DE:20F1`。
2. 打开 GPU 特性门。

（参考 https://kubevirt.io/user-guide/virtual_machines/host-devices/#listing-permitted-devices）
