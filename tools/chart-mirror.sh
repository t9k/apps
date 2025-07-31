#!/bin/bash

# Usage: chart-mirror.sh <user-console-path> --source <source_registry> --target <target_registry>

export C_reset=$'\033[0m'
export C_green=$'\033[92m'

# When the SIGINT signal is captured, it will exit directly.
forceQuit() {
    echo " Ctrl-C has been pressed."
    exit 1
}

# Capture the SIGINT signal and excute forceQuit function.
trap forceQuit SIGINT

helmMirror () {
    sourceRegistry=$1
    targetRegistry=$2
    chartName=$3
    version=$4
    downloadDir=$5

    echo "${C_green}mirror chart $sourceRegistry/$chartName:$version to $targetRegistry${C_reset}"
    helm pull "oci://$sourceRegistry/$chartName" --version "$version" -d "$downloadDir"
    helm push "$downloadDir/$chartName-$version.tgz" oci://$targetRegistry
}

# Set yq cli
# require yq 4.x.x, 4.25.2 for example.
YQ=${YQ:-yq}

# Set command line parameters.
userconsolePath=${1:?"chart-mirror.sh <user-console-path> --source <source_registry> --target <target_registry>"}
source_registry="docker.io/t9kpublic"
target_registry="registry.t9kcloud.cn/t9kcharts"

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

downloadDir=$(mktemp -d -t helm-download-XXXXXX)
for appArtifact in $(find "$userconsolePath" -type f -name "app-artifacts.yaml"); do
    for chart in $($YQ e '.versions[].chart' "$appArtifact"); do
        # 去掉 oci:// 前缀
        chartPath=$(echo "$chart" | sed 's|oci://||')
        # 提取 registry/chartname:version
        chartWithVersion=$(echo "$chartPath" | sed 's|.*/||')
        # 提取 chartname (去掉 :version 部分)
        chartName=$(echo "$chartWithVersion" | sed 's|:.*||')
        # 提取 version (去掉 chartname: 部分)
        version=$(echo "$chartWithVersion" | sed 's|.*:||')
        
        helmMirror "$source_registry" "$target_registry" "$chartName" "$version" "$downloadDir"
    done
done
rm -rf "$downloadDir"
