#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Ensure preview server is downloaded and dependencies installed
bash "$SCRIPT_DIR/download.sh"

# 2. Check if already running — daemon mode, skip if alive
if pgrep -f "dist/index.js" > /dev/null; then
  echo "Preview server already running (pid $(pgrep -f "dist/index.js" | head -1))"
  exit 0
fi

# 3. Clear port 3000 if something else is sitting on it
fuser -k 3000/tcp 2>/dev/null || true

# 4. Start the daemon
CACHE_DIR="$WORKDIR/design-works/.cache/assets/preview-server"
cd "$CACHE_DIR"

PORT=3000 ROOT="$WORKDIR/design-works" WORKDIR="$WORKDIR" node dist/index.js &

sleep 1

if pgrep -f "dist/index.js" > /dev/null; then
  echo "Preview server started (pid $(pgrep -f "dist/index.js" | head -1))"
else
  echo "ERROR: Preview server failed to start"
  exit 1
fi
