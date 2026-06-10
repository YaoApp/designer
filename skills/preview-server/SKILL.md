---
name: preview-server
trigger: When previewing a project, starting the preview server, taking screenshots, or after creating/modifying a design project
description: Preview server — download, start, stop, and control the design preview with live reload at port 3000
---

# Preview Server

Start and manage the design preview server. The server is hosted at GitHub
`YaoApp/design-assets` and downloaded on demand. It provides live reload
via WebSocket and serves all design projects under the workspace.

## Downloading Preview Server

```bash
RAW_BASE="https://raw.githubusercontent.com/YaoApp/design-assets/main"
CACHE_DIR="$WORKDIR/design-works/.cache/assets/preview-server"

LOCAL_VERSION=$(cat "$CACHE_DIR/version.txt" 2>/dev/null || echo "")
# AI reads INDEX.md to get REMOTE_VERSION (e.g. "1.0.0")
REMOTE_VERSION="1.0.0"

if [ "$LOCAL_VERSION" != "$REMOTE_VERSION" ] || [ ! -d "$CACHE_DIR/dist" ]; then
  echo "Downloading Preview Server v$REMOTE_VERSION (~2MB)..."
  mkdir -p "$CACHE_DIR"
  curl -# "$RAW_BASE/preview-server/dist.zip" -o "$CACHE_DIR/dist.zip"
  unzip -o "$CACHE_DIR/dist.zip" -d "$CACHE_DIR/dist/"
  echo "$REMOTE_VERSION" > "$CACHE_DIR/version.txt"
  echo "Preview Server v$REMOTE_VERSION ready"
fi
```

## Starting Preview Server

```bash
# Check if already running
pgrep -f "dist/index.js" && echo "running" || echo "stopped"
```

If not running:

```bash
# Kill anything on port 3000
fuser -k 3000/tcp 2>/dev/null || true

# Start the server
cd $WORKDIR/design-works/.cache/assets/preview-server/dist && \
  PORT=3000 ROOT=$WORKDIR/design-works node index.js &
```

## Outputting the Preview Link

Always include `?theme=` and `?lang=` parameters:

```bash
# Parse theme
THEME="${CTX_THEME:-dark}"
case "$THEME" in
  light) THEME="light" ;;
  *)     THEME="dark" ;;
esac

# Parse locale
CTX_LOCALE="${CTX_LOCALE:-en-us}"
LANG="${CTX_LOCALE%%-*}"
case "$LANG" in
  zh) LANG="zh" ;;
  *)  LANG="en" ;;
esac
```

Then output the link:

```
[Design Preview](service://local/{session}/3000?theme=dark&lang=en)
```

### Preview Link Examples

| Context | Link |
|---------|------|
| Dark + English | `service://local/{session}/3000?theme=dark&lang=en` |
| Dark + Chinese | `service://local/{session}/3000?theme=dark&lang=zh` |
| Light + English | `service://local/{session}/3000?theme=light&lang=en` |
| Light + Chinese | `service://local/{session}/3000?theme=light&lang=zh` |

The preview server SPA (project list, sidebar, 404 page) applies theme and language
from these parameters. Users can toggle theme/language via sidebar buttons at runtime.

## File Change Notification

Preview server uses WebSocket for automatic live reload. No manual refresh needed
when project files change.

## Screenshot Capture

```bash
curl -X POST http://localhost:3000/api/screenshot \
  -H "Content-Type: application/json" \
  -d '{"path": "/{project}/index.html", "scale": 2, "width": 1200}' \
  -o $WORKDIR/design-works/{project}/.captures/screenshot.png
```

## Stopping Preview Server

```bash
pkill -f "dist/index.js"
```

## Rules

- Preview server is downloaded on demand from GitHub `YaoApp/design-assets`, never bundled
- Start only after checking `$WORKDIR/design-works/.cache/assets/preview-server/dist/` exists
- INDEX.md version changes trigger auto re-download of dist.zip
- One preview server instance per session
- Check port 3000 before starting; if occupied, `fuser -k 3000/tcp` first
- Always attach `?theme=` and `?lang=` params to the preview link
- Theme from `$CTX.THEME`, locale from `$CTX.LOCALE`
- Never use `python3 -m http.server` as a substitute
- Use port 3000 (matching sandbox.yao ports configuration)
