# Instructions

[中文](./README_zh.md)

The scripts in `tools` are used to simplify some common operations when installing APPs in `user-console`, for example:

1. `image-mirror.sh` automatically migrates images from one repository to another based on the specified app configuration file and `app-artifacts.yaml`.
2. `chart-mirror.sh` automatically migrates Helm Charts from one repository to another based on the specified app configuration file and `app-artifacts.yaml`.
3. `app-register.sh` helps in registering applications by automating the necessary steps based on the provided configuration.

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

The script automatically detects default paths based on its location, so you can run it from any directory:

```bash
# Use default configuration (core apps)
./chart-mirror.sh

# Specify experimental apps configuration
./chart-mirror.sh -c ../register-list/experimental-appstore-config.yaml

# Customize all parameters
./chart-mirror.sh \
  -c /path/to/your-config.yaml \
  -u /path/to/user-console \
  --source docker.io/t9kpublic \
  --target registry.t9kcloud.cn/t9kcharts

# Show help information
./chart-mirror.sh --help
```

### Image Migration

Similarly, the image migration script also supports flexible parameter configuration:

```bash
# Use default configuration (core apps)
./image-mirror.sh

# Specify experimental apps configuration
./image-mirror.sh -c ../register-list/experimental-appstore-config.yaml

# Customize all parameters
./image-mirror.sh \
  -c /path/to/your-config.yaml \
  --source docker.io/t9kpublic \
  --target registry.cn-hangzhou.aliyuncs.com/t9k

# Show help information
./image-mirror.sh --help
```

### App Registration

The app registration script helps register applications to the app store. Before using this script, you need to set the required environment variables:

```bash
# Set required environment variables
export API_KEY="your-api-key"
export APP_SERVER="your-app-server-url"

# Use default configuration (core apps)
./app-register.sh

# Specify experimental apps configuration
./app-register.sh -c ../register-list/experimental-appstore-config.yaml

# Customize chart registry
./app-register.sh \
  -c /path/to/your-config.yaml \
  --chart registry.t9kcloud.cn/t9kcharts

# Show help information
./app-register.sh --help
```

### Parameter Description

The image and chart migration scripts support the following parameters:

- `-c, --config <file>`: Specify app configuration file path (default: `../register-list/core-appstore-config.yaml` relative to script)
- `--source <registry>`: Source image/Chart registry URL
- `--target <registry>`: Target image/Chart registry URL
- `-h, --help`: Show help message

The app registration script supports:

- `-c, --config <file>`: Specify app configuration file path (default: `../register-list/core-appstore-config.yaml` relative to script)
- `--chart <registry>`: App chart registry URL
- `-h, --help`: Show help message

Required environment variables for app registration:
- `API_KEY`: API key for authentication
- `APP_SERVER`: App server URL

### Path Handling

The scripts will automatically:
1. Calculate default configuration file and user-console paths based on the script's location
2. Validate that specified files and directories exist
3. Display the actual paths being used for debugging

This means you can run the scripts from any directory without worrying about path issues.
