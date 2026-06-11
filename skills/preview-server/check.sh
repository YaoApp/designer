#!/usr/bin/env bash
pgrep -f "dist/index.js" > /dev/null && echo "running" || echo "stopped"
