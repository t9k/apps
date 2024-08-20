# Virtual Machine

虚拟机（Virtual Machine）指通过软件模拟的具有完整硬件系统功能的、运行在一个完全隔离环境中的完整计算机系统。

通过该 App，用户可以在 K8s 容器化环境中部署一个虚拟机。

## 配置

### 示例

```yaml
rootDisk:
  containerDisk:
    enabled: false
    image:
      registry: docker.io
      repository: t9kpublic/fedora-cloud-container-disk-demo
      tag: v0.36.4
  dataVolume:
    enabled: true
    source:
      http:
        url: https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img
    fromOCIRegistry:
      enabled: true
      image:
        registry: docker.io
        repository: t9kpublic/ubuntu-server-cloud
        tag: 20.04-240819
    pvc:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 3Gi

# extraDevices:
#   gpus:
#   - deviceName: nvidia.com/GA100_A100_PCIE_40GB
#     name: gpu1
extraDevices: {}

resources:
  cpu: 8
  memory: 16Gi

# volumes:
#   filesystems:
#   - persistentVolumeClaim:
#       name: "pvc-name"
#     name: "volume-name"
#   disks:
#   - persistentVolumeClaim:
#       name: "pvc-name"
#     name: "volume-name"
volumes:
  filesystems: []
  disks: []

# network:
#   ports:
#   - name: "http"
#     port: 5901
#     protocol: "TCP"
network:
  ports: []

cloudInit:
  userData: |-
    #cloud-config
    user: ubuntu
    password: ubuntu
    chpasswd: { expire: False }
    package_update: true
    package_upgrade: true
    packages:
    - qemu-guest-agent
    runcmd:
    - [ systemctl, start, qemu-guest-agent ]
```

### 参数

| 名称                                                | 描述                                                                                                                                            | 值                                                                                                                  |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `rootDisk`                                          | 虚拟机启动盘配置。                                                                                                                              |                                                                                                                     |
| `rootDisk.containerDisk`                            | 使用一个容器镜像作为虚拟机启动盘，该启动盘不能持久化存储数据，仅建议在测试时使用。                                                              |                                                                                                                     |
| `rootDisk.containerDisk.enabled`                    | 是否使用一个容器镜像作为虚拟机启动盘。                                                                                                          | `false`                                                                                                             |
| `rootDisk.containerDisk.image`                      | 虚拟机启动盘所使用的容器镜像。                                                                                                                  | `{}`                                                                                                                |
| `rootDisk.dataVolume`                               | 使用一个 DataVolume 生成虚拟机启动盘。                                                                                                          |                                                                                                                     |
| `rootDisk.dataVolume.enabled`                       | 是否使用一个 DataVolume 生成虚拟机启动盘。                                                                                                      | `true`                                                                                                              |
| `rootDisk.dataVolume.source`                        | 启动盘数据来源，即系统镜像来源，[参考](https://pkg.go.dev/kubevirt.io/containerized-data-importer-api/pkg/apis/core/v1beta1#DataVolumeSource)。 | `{"http":{"url": "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"}}` |
| `rootDisk.dataVolume.fromOCIRegistry`               | 使用 OCI 仓库中的内容作为系统镜像数据源，当 `rootDisk.dataVolume.fromOCIRegistry.enabled` 为 `true` 时，`rootDisk.dataVolume.source` 无效。    | `{}`                                                                                                                |
| `rootDisk.dataVolume.pvc`                           | DataVolume 生成的虚拟机启动盘以 PVC 作为载体，该字段设置 PVC 的配置。                                                                           | `{"accessModes":["ReadWriteOnce"],"resources":{"requests":{"storage":"3Gi"}}}`                                      |
| `extraDevices`                                      | 额外设备信息，如 GPU 等。更多信息请参考 [Kubevirt](https://kubevirt.io/user-guide/compute/host-devices/)。                                      | `{}`                                                                                                                |
| `resources`                                         | 分配给虚拟机的计算资源，此处仅用于设置 CPU 和内存，GPU 等设备请通过 `extraDevices` 字段设置。                                                   |                                                                                                                     |
| `resources.cpu`                                     | 虚拟机所使用的 CPU 数量。                                                                                                                       | `8`                                                                                                                 |
| `resources.memory`                                  | 虚拟机所使用的内存大小。                                                                                                                        | `16Gi`                                                                                                              |
| `volumes`                                           | 给虚拟机绑定额外的存储卷（指 PVC）。                                                                                                            |                                                                                                                     |
| `volumes.filesystems`                               | 将 PVC 以文件系统的方式绑定给虚拟机。                                                                                                           |                                                                                                                     |
| `volumes.filesystems[*].persistentVolumeClaim.name` | PVC 名称。                                                                                                                                      | `""`                                                                                                                |
| `volumes.filesystems[*].name`                       | PVC 的绑定名称，用于在虚拟机配置中区分不同的 Volume。                                                                                           | `""`                                                                                                                |
| `volumes.disks`                                     | 将 PVC 以磁盘的方式绑定给虚拟机（需要对 PVC 进行格式化。）                                                                                      |                                                                                                                     |
| `volumes.disks[*].persistentVolumeClaim.name`       | PVC 名称。                                                                                                                                      | `""`                                                                                                                |
| `volumes.disks[*].name`                             | PVC 的绑定名称，用于在虚拟机配置中区分不同的 Volume。                                                                                           | `""`                                                                                                                |
| `network.ports`                                     | 虚拟机对外暴露的网络接口。                                                                                                                      | `[]`                                                                                                                |
| `cloudInit.userData`                                | CloudInit 配置，[参考](https://cloudinit.readthedocs.io/en/latest/reference/examples.html)。                                                    | `""`                                                                                                                |

### 说明

#### 在虚拟机中使用 GPU

如果希望在虚拟机中使用 GPU，则需要做以下事情：

1. 在节点上，将 GPU 的驱动（如 `nvidia`）替换为 `vfio-pci`。
2. 在集群中安装 `kubevirt-gpu-device-plugin`。
3. 在 kubevirt 配置中打开 GPU 特性门。

上述操作都需要节点、集群的管理员权限，请联系管理员根据管理员文档执行上述操作。

按如下方式修改配置中的 `extraDevices` 字段：

```yaml
extraDevices:
  gpus:
    - deviceName: nvidia.com/GA100_A100_PCIE_40GB
      name: gpu1
```

在上述配置中，`deviceName` 字段填写 GPU 的 k8s 扩展资源名称，该扩展资源由 `kubevirt-gpu-device-plugin` 探测并扩展。`name` 字段表示设备名称，在虚拟机中不应出现两个相同的设备名称。

#### 启动盘设置

目前，我们支持以下三种启动盘形式：

1. 使用一个容器作为启动盘。
2. 使用 DataVolume 下载系统镜像并构建启动盘。
3. 使用一个已经进行过磁盘格式化并安装了系统文件的 PVC 作为启动盘。

##### 使用容器作为启动盘

```yaml
rootDisk:
  containerDisk:
    enabled: true
    image: kubevirt/fedora-cloud-container-disk-demo:latest
```

在上述配置中，虚拟机会使用 `kubevirt/fedora-cloud-container-disk-demo:latest` 镜像创建一个容器，作为启动盘。

kubevirt 原生支持的可以作为启动盘的容器镜像请参考 [KubeVirt container-disk images](https://github.com/kubevirt/kubevirt/blob/main/containerimages/container-disk-images.md)。

`containerDisk` 属于临时存储设备，不具备持久性，即如果虚拟机重启则系统的修改丢失。

##### 使用 DataVolume 下载系统镜像并构建启动盘

```yaml
rootDisk:
  dataVolume:
    enabled: true
    template:
      source:
        http:
          url: https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img
      pvc:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 3Gi
```

在上述配置中，虚拟机控制器会创建一个 PVC（名称即为 App 名称），从 `https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img` 下载系统镜像并安装到 PVC 中，将该 PVC 作为虚拟机启动盘。

除了从 http 服务中下载系统镜像，DataVolume 还支持从多种数据源获取镜像，请参考 [DataVolumeSource](https://pkg.go.dev/kubevirt.io/containerized-data-importer-api/pkg/apis/core/v1beta1#DataVolumeSource)。

> [!NOTE]
>
> DataVolume 和 ContainerDisk 不能同时启用，否则将使用 ContainerDisk 作为系统启动盘，而 DataVolume 构建的启动盘将作为普通的磁盘。
> 目前不支持多启动项，如果有需求，建议启动多个虚拟机。

##### 使用一个 PVC 作为启动盘

```yaml
rootDisk:
  containerDisk:
    enabled: false
  dataVolume:
    enabled: false

volumes:
  disks:
    - persistentVolumeClaim:
        name: "pvc-name"
      name: "volume-name"
```

在上述配置中，禁用了 ContainerDisk 和 DataVolume。这种情况下，虚拟机会将第一个以 Disk 形式绑定的 PVC 作为启动盘。该 PVC 应已经进行格式化且安装过系统，否则虚拟机无法启动。

#### 数据卷

```yaml
volumes:
  filesystems:
    - persistentVolumeClaim:
        name: "pvc-as-fs"
      name: "fs-name"
  disks:
    - persistentVolumeClaim:
        name: "pvc-as-disk"
      name: "disk-name"

cloudInit:
  userData: |-
    ...
    runcmd:
    - "sudo mkdir /mnt/pvc"
    - "sudo mount -t virtiofs fs-name /mnt/pvc"
    - test "$(lsblk /dev/vdb)" && mkfs.ext4 /dev/vdb
    - mkdir -p /mnt/vdb
    mounts:
    - [ "/dev/vdb", "/mnt/vdb", "ext4", "defaults,nofail", "0", "2" ]
```

如上图所示，在该配置中：

1. 虚拟机绑定了两个 PVC：`pvc-as-fs` 和 `pvc-as-disk`，两者分别作为文件系统和磁盘。
2. 将 PVC 以文件系统的方式绑定给虚拟机时，需要使用 `sudo mount -t virtiofs fs-name /mnt/pvc` 命令将这个 PVC 绑定到 `/mnt/pvc` 路径下。
3. 将 PVC 以磁盘的方式绑定给虚拟机时，如果 PVC 没有进行过磁盘格式化，则需要执行 `mkfs.ext4 /dev/vdb` 命令格式化 PVC，同时需要执行 `mount` 命令将磁盘绑定在 `/mnt/vdb` 路径下。

> [!NOTE]
>
> 1. userData 中 `bootcmd`、`runcmd` 和 `mounts` 等命令，可以在虚拟机启动后，进入虚拟机后手动执行。不过如果一条命令是其他启动项的前置条件，则必须在 `bootcmd` 中填写。
> 2. 磁盘名称使用 `vdb`，是因为通过 `virtio` 总线挂载的磁盘默认命名格式为 `vdx`，启动盘被命名为是 `vda`，其他磁盘按顺序依次命名。用户也可以不通过 CloudInit 自动初始化，改为进入虚拟机后再手动执行挂载操作。
> 3. CloudInit 更多使用方式请参考 [Cloud Config](https://cloudinit.readthedocs.io/en/latest/reference/examples.html)。

## 使用方式

### 连接虚拟机终端

连接虚拟机终端需要安装 `kubectl virt` 插件，该插件在 0.1.5 以上版本的 Terminal App 中已经安装。

如果用户希望手动安装该插件，请参考[文档](https://github.com/kubevirt/kubectl-virt-plugin?tab=readme-ov-file#kubectl-virt-plugin)。

运行以下命令，连接到虚拟机终端：

```bash
kubectl virt console <app-name> -n <app-namespace>
```

### 图形界面

如果想要使用虚拟机的图形界面，请保证虚拟机启动了 VNC 服务，如果虚拟机没有启动该服务，请参考[文章](https://serverspace.io/support/help/install-tightvnc-server-on-ubuntu-20-04/)。

按如下方式修改配置中的 `network` 字段：

```yaml
network:
  ports:
    - name: "http"
      port: 5901
      protocol: "TCP"
```

上述配置将虚拟机的 `5901` 端口暴露出来，以便用户访问。（VNC 服务的端口一般为 `5901`，如果不是，请按照实际情况进行修改。）

将 VNC 服务暴露到本地：

```yaml
kubectl port-forward service/<virtual-machine-name> 5901:5901
```

使用本地的 VNC Client 链接到 `localhost:5901` 即可。
