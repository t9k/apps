# Instructions

[中文](./README_zh.md)

The scripts in `tools` are used to simplify some common operations when installing APPs in `user-console`, for example:

1.  `image-mirror.sh` automatically migrates images from one repository to another based on the YAML in configs.
2.  `chart-mirror.sh` automatically migrates Helm Charts from one repository to another based on template.yaml.

## Requirements

Docker and Helm are installed, and you have logged in to the corresponding Registry:

```bash
docker login <registry>
```

```bash
helm registry login <registry>
```

Helm version must be greater than or equal to v3.8.0. The version used for testing is as follows:

```bash
helm version
version.BuildInfo{Version:"v3.9.0", GitCommit:"7ceeda6c585217a19a1131663d8cd1f7d641b2a7", GitTreeState:"clean", GoVersion:"go1.17.5"}
```

jq and yq are installed, and the version requirement for yq is 4.x.x. The versions used for testing are as follows:

```bash
$ jq --version
jq-1.6

$ yq --version
yq (https://github.com/mikefarah/yq/) version 4.25.2
```

## Usage

### [Optional] Set Environment Variables

If you have other versions of jq or yq installed locally, for example, yq 2.4.0, you can install yq 4 with a different name, such as yq-4, to avoid conflicts. Then, you can use the scripts here normally by setting environment variables:

```bash
export YQ=yq-4
export JQ=jq
```

### Chart Migration

Read the `template.yaml` file of a single APP and migrate all the Helm Charts used in it:

```bash
./chart-mirror.sh ../user-console/job-manager --source docker.io/t9kpublic --target registry.t9kcloud.cn/t9kcharts
```

Traverse all `template.yaml` files in a directory (e.g., user-console) and migrate all the Helm Charts used:

```bash
./chart-mirror.sh ../user-console --source docker.io/t9kpublic --target registry.t9kcloud.cn/t9kcharts
```

### Image Migration

Read the `configs` directory of a single APP and migrate all the container images used in all the config files in it:

```bash
./image-mirror.sh ../user-console/job-manager --source docker.io/t9kpublic --target registry.cn-hangzhou.aliyuncs.com/t9k
```

Note: Since different versions of configs in a single configs directory often use the same image, this may cause the same image to be mirrored multiple times. It is planned to remove duplicate images in the next version.

Traverse all files in all `configs` folders in a directory (e.g., user-console) and migrate all the container images used:

```bash
./image-mirror.sh ../user-console --source docker.io/t9kpublic --target registry.cn-hangzhou.aliyuncs.com/t9k
```
