#!/bin/bash

# Usage: app-register.sh [options]
# Options:
#   -c, --config <file>           Specify config file path (default: <script_dir>/../register-list/core-appstore-config.yaml)
#   --source <registry>           Source chart registry (default: oci://docker.io/t9kpublic)  
#   --target <registry>           Target chart registry (default: oci://registry.sample.t9kcloud.cn/appcharts)

export C_reset=$'\033[0m'
export C_green=$'\033[92m'
export C_yellow=$'\033[93m'
export C_red=$'\033[91m'

# When the SIGINT signal is captured, it will exit directly.
forceQuit() {
    echo " Ctrl-C has been pressed."
    exit 1
}

# Capture the SIGINT signal and excute forceQuit function.
trap forceQuit SIGINT

# Validate environment variables and dependencies
validateEnvironment() {
    echo "${C_green}Validating environment...${C_reset}"
    
    # Check API_KEY environment variable
    if [[ -z "$API_KEY" ]]; then
        echo "${C_red}Error: API_KEY environment variable is not set${C_reset}"
        echo "Please set API_KEY before running this script"
        exit 1
    fi
    
    # Check APP_SERVER environment variable
    if [[ -z "$APP_SERVER" ]]; then
        echo "${C_red}Error: APP_SERVER environment variable is not set${C_reset}"
        echo "Please set APP_SERVER before running this script"
        exit 1
    fi
    
    # Check if t9k-app command is available
    if ! command -v t9k-app &> /dev/null; then
        echo "${C_red}Error: t9k-app command not found${C_reset}"
        echo "Please install t9k-app command line tool"
        exit 1
    fi
    
    echo "${C_green}Environment validation passed${C_reset}"
}

# Filter template.yaml to keep only specified versions
filterTemplate() {
    local templateFile=$1
    local appName=$2
    local configFile=$3
    local tempFile=$(mktemp)
    
    echo "  ${C_yellow}Filtering template for specified versions...${C_reset}"
    
    # Get specified versions for this app from config file
    local specifiedVersions=()
    while IFS= read -r version; do
        specifiedVersions+=("$version")
    done < <($YQ e ".apps[] | select(.name == \"$appName\") | .versions[]" "$configFile")
    
    if [[ ${#specifiedVersions[@]} -eq 0 ]]; then
        echo "    Warning: No versions specified for $appName"
        return 1
    fi
    
    # Create filter expression for yq
    local filterExpr=""
    for version in "${specifiedVersions[@]}"; do
        if [[ -n "$filterExpr" ]]; then
            filterExpr="$filterExpr or "
        fi
        filterExpr="$filterExpr.version == \"$version\""
    done
    
    # Filter the template to keep only specified versions
    $YQ e "(.spec.versions[] | select($filterExpr)) as \$item ireduce ({}; . * {\"spec\": {\"versions\": [.spec.versions[] | select($filterExpr)]}}) | . *+ load(\"$templateFile\")" /dev/null > "$tempFile"
    
    # Replace original file
    cp "$tempFile" "$templateFile"
    rm -f "$tempFile"
    
    echo "    Kept versions: ${specifiedVersions[*]}"
}

# Update chart repository in template.yaml
updateChartRepo() {
    local templateFile=$1
    local sourceRegistry=$2
    local targetRegistry=$3
    
    echo "  ${C_yellow}Updating chart repository from $sourceRegistry to $targetRegistry...${C_reset}"
    
    # Use sed to replace the chart repository
    sed -i "s|repo: \"$sourceRegistry\"|repo: \"$targetRegistry\"|g" "$templateFile"
}

# Register single app
registerApp() {
    local templateFile=$1
    local appName=$2
    
    echo "  ${C_green}Registering app: $appName${C_reset}"
    
    # Run t9k-app register command
    if t9k-app -k "$API_KEY" -s "$APP_SERVER" register -u -f "$templateFile"; then
        echo "  ${C_green}Successfully registered $appName${C_reset}"
    else
        echo "  ${C_red}Failed to register $appName${C_reset}"
        return 1
    fi
}

# Set yq cli
# require yq 4.x.x, 4.25.2 for example.
YQ=${YQ:-yq}

# Get script directory to calculate default paths
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set default parameters based on script location
configFile="$scriptDir/../register-list/core-appstore-config.yaml"
sourceRegistry="oci://docker.io/t9kpublic"
targetRegistry="oci://docker.io/t9kpublic"

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
      echo "  --source <registry>           Source chart registry (default: oci://docker.io/t9kpublic)"  
      echo "  --target <registry>           Target chart registry (default: oci://registry.sample.t9kcloud.cn/appcharts)"
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
echo "Source chart registry: $sourceRegistry"
echo "Target chart registry: $targetRegistry"

# Validate environment
validateEnvironment

# Read apps and versions from config file
for appName in $($YQ e '.apps[].name' "$configFile"); do
    echo "Processing app: $appName"
    
    # Find the template.yaml file for this app
    templateFile="$scriptDir/../user-console/$appName/template.yaml"
    
    if [[ ! -f "$templateFile" ]]; then
        echo "Warning: template.yaml not found for $appName, skipping..."
        continue
    fi
    
    # Create a backup of the original template
    cp "$templateFile" "${templateFile}.original"
    
    # Filter template to keep only specified versions
    if ! filterTemplate "$templateFile" "$appName" "$configFile"; then
        echo "  Skipping $appName due to filtering error"
        # Restore original template
        mv "${templateFile}.original" "$templateFile"
        continue
    fi
    
    # Update chart repository
    updateChartRepo "$templateFile" "$sourceRegistry" "$targetRegistry"
    
    # Register the app
    if registerApp "$templateFile" "$appName"; then
        echo "  ${C_green}✓ $appName registered successfully${C_reset}"
    else
        echo "  ${C_red}✗ Failed to register $appName${C_reset}"
    fi
    
    # Restore original template
    mv "${templateFile}.original" "$templateFile"
    
    echo
done

echo "${C_green}App registration process completed!${C_reset}" 