#!/usr/bin/env bash
if pgrep -f "dist/index.js" > /dev/null; then
  echo "Stopping preview server (pid $(pgrep -f "dist/index.js" | head -1))..."
  pkill -f "dist/index.js"
  echo "Preview server stopped"
else
  echo "Preview server is not running"
fi
