#!/bin/bash

# if you are using windows, you may need to convert the file to unix format
# sudo apt-get install dos2unix
# dos2unix entrypoint.sh

set -e

echo "Starting frontend server..."

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

# Verify the next.js app is in the correct location
if [ ! -f "/shared/web/.next/standalone/server.js" ]; then
  echo "Error: Cannot find the Next.js application at /shared/web/.next/standalone/server.js"
  echo "Build process may have failed or not completed."
  echo "Checking for build artifacts..."
  find /shared -type f -name "server.js" | grep -v "node_modules"
  exit 1
fi

# Start the application with PM2
echo "Starting the application..."
pm2 start /shared/web/.next/standalone/server.js --name dify-web --cwd /shared/web/.next/standalone -i ${PM2_INSTANCES} --no-daemon
