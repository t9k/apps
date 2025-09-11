#!/bin/bash
set -e

# Ensure data directory exists
mkdir -p /app/backend/data

# Copy backup data into data directory without overwriting existing files if possible
if [ -d "/app/backend/data_backup" ]; then
  # Try cp -n if supported
  if cp --help 2>/dev/null | grep -q "\-n"; then
    cp -R -n /app/backend/data_backup/* /app/backend/data/ 2>/dev/null || true
  else
    # Fallback: only copy files that don't already exist
    for f in /app/backend/data_backup/*; do
      [ -e "$f" ] || continue
      dest="/app/backend/data/$(basename "$f")"
      [ -e "$dest" ] || cp -R "$f" "/app/backend/data/"
    done
  fi
fi

exec /app/backend/start.sh "$@"
