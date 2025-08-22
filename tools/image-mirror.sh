#!/bin/bash

# Usage: image-mirror.sh [options]
# Options:
#   -c, --config <file>           Specify config file path (default: <script_dir>/../register-list/core-appstore-config.yaml)
#   --source <registry>           Source registry (default: docker.io/t9kpublic)  
#   --target <registry>           Target registry (default: registry.cn-hangzhou.aliyuncs.com/t9k)

export C_reset=$'\033[0m'
export C_green=$'\033[92m'

# When the SIGINT signal is captured, it will exit directly.
forceQuit() {
    echo " Ctrl-C has been pressed."
    exit 1
}

# Capture the SIGINT signal and excute forceQuit function.
trap forceQuit SIGINT

dockerMirror () {
    sourceImage=$1 
    targetImage=$2 
    echo "${C_green}mirror image $sourceImage to $targetImage${C_reset}"
    docker pull $sourceImage
    docker tag $sourceImage $targetImage
    docker push $targetImage
}

# Set yq cli
# require yq 4.x.x, 4.25.2 for example.
YQ=${YQ:-yq}

# Set jq cli
# jq-1.6 for example
JQ=${JQ:-jq}

# Get script directory to calculate default paths
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set default parameters based on script location
configFile="$scriptDir/../register-list/core-appstore-config.yaml"
sourceRegistry="docker.io/t9kpublic"
targetRegistry=""

# Parse command line arguments
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
      -c|--config)
      configFile="$2"
      shift # past argument
      shift # past value
      ;;
      --source)
      sourceRegistry="$2"
      shift # past argument
      shift # past value
      ;;
      --target)
      targetRegistry="$2"
      shift # past argument
      shift # past value
      ;;
      -h|--help)
      echo "Usage: $0 [options]"
      echo "Options:"
      echo "  -c, --config <file>           Specify config file path (default: <script_dir>/../register-list/core-appstore-config.yaml)"
      echo "  --source <registry>           Source registry (default: docker.io/t9kpublic)"  
      echo "  --target <registry>           Target registry (default: registry.cn-hangzhou.aliyuncs.com/t9k)"
      echo "  -h, --help                    Show this help message"
      exit 0
      ;;
      *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

# Validate required files and directories
if [[ ! -f "$configFile" ]]; then
    echo "Error: Config file not found: $configFile"
    echo "Please specify a valid config file using -c/--config option"
    exit 1
fi

if [[ ! -d "$scriptDir/../user-console" ]]; then
    echo "Error: User console directory not found: $scriptDir/../user-console"
    exit 1
fi

if [[ -z "$targetRegistry" ]]; then
    targetRegistry=$($YQ e '.image.registry' "$configFile")/$($YQ e '.image.repository' "$configFile")
fi

echo "Using config file: $configFile"

# Read apps and versions from config file
images=()
for appName in $($YQ e '.apps[].name' "$configFile"); do
    echo "Processing app: $appName"
    
    # Find the app-artifacts.yaml file for this app
    appArtifactFile="$scriptDir/../user-console/$appName/app-artifacts.yaml"
    
    if [[ ! -f "$appArtifactFile" ]]; then
        echo "Warning: app-artifacts.yaml not found for $appName, skipping..."
        continue
    fi
    
    # Get versions for this specific app from config file
    for version in $($YQ e ".apps[] | select(.name == \"$appName\") | .versions[]" "$configFile"); do
        echo "  Processing version: $version"
        
        # Find the images for this specific version in app-artifacts.yaml
        for image in $($YQ e ".versions[] | select(.version == \"$version\") | .images[]" "$appArtifactFile"); do
            if [[ "$image" == "null" || -z "$image" ]]; then
                continue
            fi
            
            # 提取镜像名称，去掉变量前缀
            imageName=$(echo $image | sed 's|\$(T9K_APP_IMAGE_REGISTRY)/\$(T9K_APP_IMAGE_NAMESPACE)/||')
            images+=("$imageName")
        done
    done
done

# 去重
unique_images=($(printf "%s\n" "${images[@]}" | sort -u))

# 镜像操作
for imageName in "${unique_images[@]}"; do
    sourceImage="$sourceRegistry/$imageName"
    targetImage="$targetRegistry/$imageName"
    dockerMirror "$sourceImage" "$targetImage"
done
