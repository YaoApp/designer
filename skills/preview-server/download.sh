#!/usr/bin/env bash
set -euo pipefail

RAW_BASE="https://raw.githubusercontent.com/YaoApp/design-assets/main"
CACHE_DIR="$WORKDIR/design-works/.cache/assets/preview-server"
REMOTE_VERSION="0.2.1"

LOCAL_VERSION=$(cat "$CACHE_DIR/version.txt" 2>/dev/null || echo "")

if [ "$LOCAL_VERSION" != "$REMOTE_VERSION" ] || [ ! -f "$CACHE_DIR/dist/index.js" ]; then
  echo "Downloading Preview Server v$REMOTE_VERSION (~175KB)..."
  mkdir -p "$CACHE_DIR"
  curl -# "$RAW_BASE/preview-server/dist.zip" -o "$CACHE_DIR/dist.zip"
  unzip -o "$CACHE_DIR/dist.zip" -d "$CACHE_DIR/"
  echo "$REMOTE_VERSION" > "$CACHE_DIR/version.txt"
  echo "Preview Server v$REMOTE_VERSION ready"
fi

if [ ! -d "$CACHE_DIR/node_modules" ]; then
  echo "Installing runtime dependencies..."
  cd "$CACHE_DIR" && npm install --production --no-audit --no-fund 2>&1
fi
