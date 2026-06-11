#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

bash "$SCRIPT_DIR/stop.sh"
sleep 0.5
bash "$SCRIPT_DIR/start.sh"
