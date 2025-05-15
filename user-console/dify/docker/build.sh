#!/bin/bash

# if you are using windows, you may need to convert the file to unix format
# sudo apt-get install dos2unix
# dos2unix build.sh

set -e

echo "Starting frontend build process..."

# Set environment variables
export NEXT_PUBLIC_DEPLOY_ENV=${DEPLOY_ENV}
export NEXT_PUBLIC_EDITION=${EDITION}
export NEXT_PUBLIC_API_PREFIX=${CONSOLE_API_URL}/console/api
export NEXT_PUBLIC_WEB_PREFIX=${CONSOLE_WEB_URL}
export NEXT_PUBLIC_PUBLIC_API_PREFIX=${APP_API_URL}/api
export NEXT_PUBLIC_PUBLIC_WEB_PREFIX=${APP_WEB_URL}
export NEXT_PUBLIC_MARKETPLACE_API_PREFIX=${MARKETPLACE_API_URL}/api/v1
export NEXT_PUBLIC_MARKETPLACE_URL_PREFIX=${MARKETPLACE_URL}

export NEXT_PUBLIC_SENTRY_DSN=${SENTRY_DSN}
export NEXT_PUBLIC_SITE_ABOUT=${SITE_ABOUT}
export NEXT_TELEMETRY_DISABLED=${NEXT_TELEMETRY_DISABLED}

export NEXT_PUBLIC_TEXT_GENERATION_TIMEOUT_MS=${TEXT_GENERATION_TIMEOUT_MS}
export NEXT_PUBLIC_CSP_WHITELIST=${CSP_WHITELIST}
export NEXT_PUBLIC_ALLOW_EMBED=${ALLOW_EMBED}
export NEXT_PUBLIC_TOP_K_MAX_VALUE=${TOP_K_MAX_VALUE}
export NEXT_PUBLIC_INDEXING_MAX_SEGMENTATION_TOKENS_LENGTH=${INDEXING_MAX_SEGMENTATION_TOKENS_LENGTH}
export NEXT_PUBLIC_MAX_TOOLS_NUM=${MAX_TOOLS_NUM}
export NEXT_PUBLIC_ENABLE_WEBSITE_JINAREADER=${ENABLE_WEBSITE_JINAREADER:-true}
export NEXT_PUBLIC_ENABLE_WEBSITE_FIRECRAWL=${ENABLE_WEBSITE_FIRECRAWL:-true}
export NEXT_PUBLIC_ENABLE_WEBSITE_WATERCRAWL=${ENABLE_WEBSITE_WATERCRAWL:-true}
export NEXT_PUBLIC_LOOP_NODE_MAX_COUNT=${LOOP_NODE_MAX_COUNT}
export NEXT_PUBLIC_MAX_PARALLEL_LIMIT=${MAX_PARALLEL_LIMIT}
export NEXT_PUBLIC_MAX_ITERATIONS_NUM=${MAX_ITERATIONS_NUM}

# First ensure the shared directory exists
echo "Preparing shared directory..."
mkdir -p /shared/web

# Extract BASE_PATH from NEXT_PUBLIC_WEB_PREFIX (fallback to /dify if not set or extraction fails)
if [ -n "${NEXT_PUBLIC_WEB_PREFIX}" ]; then
  # Remove protocol and domain, keep only the path
  EXTRACTED_PATH=$(echo "${NEXT_PUBLIC_WEB_PREFIX}" | sed -E 's|^https?://[^/]+(/.*)?$|\1|')
  
  # If extraction succeeded and path is not empty, use it as BASE_PATH
  if [ -n "${EXTRACTED_PATH}" ]; then
    BASE_PATH=${EXTRACTED_PATH}
    echo "Extracted BASE_PATH from NEXT_PUBLIC_WEB_PREFIX: ${BASE_PATH}"
  else
    # Fallback to default
    BASE_PATH=${BASE_PATH:-/dify}
    echo "Could not extract path from NEXT_PUBLIC_WEB_PREFIX, using default: ${BASE_PATH}"
  fi
else
  # Fallback to environment variable or default
  BASE_PATH=${BASE_PATH:-/dify}
  echo "NEXT_PUBLIC_WEB_PREFIX not set, using BASE_PATH: ${BASE_PATH}"
fi

# Update basePath in var-basePath.js - also update assetPrefix to the same value
echo "Updating basePath and assetPrefix in var-basePath.js"
sed -i "s|basePath: ''|basePath: '${BASE_PATH}'|g" /app/web/utils/var-basePath.js
sed -i "s|assetPrefix: ''|assetPrefix: '${BASE_PATH}'|g" /app/web/utils/var-basePath.js

# Update basePath in var.ts
echo "Updating basePath in var.ts"
sed -i "s|export const basePath = ''|export const basePath = '${BASE_PATH}'|g" /app/web/utils/var.ts

# Display the updated configuration
echo "Updated config in var-basePath.js:"
cat /app/web/utils/var-basePath.js

echo "Updated config in var.ts:"
grep "export const basePath" /app/web/utils/var.ts

# Build the application with updated basePath in the source directory
echo "Building application with updated basePath..."
export NODE_OPTIONS="--max-old-space-size=4096"
cd /app/web && pnpm build

# Verify the static assets are in place
echo "Checking static assets directory..."
ls -la /app/web/.next/static || echo "Static directory not found at expected location"

# Copy only the necessary files to shared directory
echo "Copying build artifacts to shared directory..."
mkdir -p /shared/web/.next/standalone/.next
cp -r /app/web/.next/standalone /shared/web/.next/
cp -r /app/web/.next/static /shared/web/.next/standalone/.next/
cp -r /app/web/public /shared/web/.next/standalone/
echo "Build artifacts copied to shared directory"

# Ensure correct permissions for the shared directory
chown -R 1001:1001 /shared/web
chmod -R 775 /shared/web

# Verify the static assets have been copied
ls -la /shared/web/.next/standalone/.next/static || echo "Failed to copy static directory"

echo "Build completed successfully." 
