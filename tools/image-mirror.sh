#!/bin/bash

# Usage: image-mirror.sh <yaml> --source <source_registry> --target <target_registry>

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

# Set command line parameters.
userconsolePath=${1:?"image-mirror.sh <user-console-path> --source <source_registry> --target <target_registry>"}
source_registry="docker.io/t9kpublic"
target_registry="registry.cn-hangzhou.aliyuncs.com/t9k"

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
      --source)
      source_registry="$2"
      shift # past argument
      shift # past value
      ;;
      --target)
      target_registry="$2"
      shift # past argument
      shift # past value
      ;;
      *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

for appArtifact in $(find $userconsolePath -name "app-artifacts.yaml"); do
    for image in $($YQ e '.versions[].images[]' "$appArtifact"); do
        # 提取镜像名称，去掉变量前缀
        imageName=$(echo $image | sed 's|\$(T9K_APP_IMAGE_REGISTRY)/\$(T9K_APP_IMAGE_NAMESPACE)/||')
        sourceImage="$source_registry/$imageName"
        targetImage="$target_registry/$imageName"
        dockerMirror "$sourceImage" "$targetImage"
    done
done
