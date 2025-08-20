#!/bin/bash

# Usage: chart-mirror.sh [options]
# Options:
#   -c, --config <file>           Specify config file path (default: <script_dir>/../register-list/core-appstore-config.yaml)
#   --source <registry>           Source registry (default: docker.io/t9kpublic)  
#   --target <registry>           Target registry (default: registry.t9kcloud.cn/t9kcharts)

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

# Get script directory to calculate default paths
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set default parameters based on script location
configFile="$scriptDir/../register-list/core-appstore-config.yaml"
sourceRegistry="docker.io/t9kpublic"
targetRegistry="registry.t9kcloud.cn/t9kcharts"

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
      echo "  --target <registry>           Target registry (default: registry.t9kcloud.cn/t9kcharts)"
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

echo "Using config file: $configFile"

downloadDir=$(mktemp -d -t helm-download-XXXXXX)

# Read apps and versions from config file
charts=()
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
        
        # Find the chart for this specific version in app-artifacts.yaml
        chart=$($YQ e ".versions[] | select(.version == \"$version\") | .chart" "$appArtifactFile")
        
        if [[ "$chart" == "null" || -z "$chart" ]]; then
            echo "    Warning: No chart found for version $version in $appArtifactFile"
            continue
        fi
        
        # 去掉 oci:// 前缀
        chartPath=$(echo "$chart" | sed 's|oci://||')
        charts+=("$chartPath")
    done

done

# 去重
unique_charts=($(printf "%s\n" "${charts[@]}" | sort -u))

# 镜像操作
for chart in "${unique_charts[@]}"; do
    # 提取 registry/chartname:version
    chartWithVersion=$(echo "$chart" | sed 's|.*/||')
    # 提取 chartname (去掉 :version 部分)
    chartName=$(echo "$chartWithVersion" | sed 's|:.*||')
    # 提取 version (去掉 chartname: 部分)
    chartVersion=$(echo "$chartWithVersion" | sed 's|.*:||')
    
    helmMirror "$sourceRegistry" "$targetRegistry" "$chartName" "$chartVersion" "$downloadDir"
done

rm -rf "$downloadDir"
