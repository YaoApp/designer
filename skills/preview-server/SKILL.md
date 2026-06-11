---
name: preview-server
trigger: When previewing a project, starting the preview server, taking screenshots, or after creating/modifying a design project
description: Preview server — download, start, stop, and control the design preview with live reload at port 3000
---

# Preview Server

Start and manage the design preview server. The server is hosted at GitHub
`YaoApp/design-assets` and downloaded on demand. It provides live reload
via WebSocket and serves all design projects under the workspace.

The preview server is a **daemon** — once started, it stays running for the
entire session. Use `start.sh` to ensure it's alive (idempotent: it skips
if already running). Only restart when the server itself has been updated.

## Lifecycle Scripts

All scripts are in `$CTX_SKILLS_DIR/preview-server/`. Run them via bash:

| Script | Purpose |
|--------|---------|
| `download.sh` | Download or update the preview server from GitHub |
| `check.sh` | Check if the preview server is running |
| `start.sh` | **Idempotent start** — download + start if not already running |
| `stop.sh` | Stop the running preview server |
| `restart.sh` | Stop then start (use after server version update) |

## Ensuring the Server is Running (Most Common)

```bash
bash $CTX_SKILLS_DIR/preview-server/start.sh
```

This downloads the server if needed, then starts it if it's not already running.
It is safe to call after every file change — it won't restart unnecessarily.

## Checking Status

```bash
bash $CTX_SKILLS_DIR/preview-server/check.sh
```

## Restarting (After Server Update)

Only needed when the preview server version changed and dist.zip was re-downloaded:

```bash
bash $CTX_SKILLS_DIR/preview-server/restart.sh
```

## Stopping

```bash
bash $CTX_SKILLS_DIR/preview-server/stop.sh
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

## Rules

- Use `bash $CTX_SKILLS_DIR/preview-server/start.sh` to ensure the server is alive
- Do NOT restart the server every time a file changes — the daemon handles live reload
- `start.sh` is idempotent: call it freely, it skips if already running
- Only use `restart.sh` after the preview server dist.zip was re-downloaded (version bump)
- Preview server is downloaded on demand from GitHub `YaoApp/design-assets`, never bundled
- After extracting dist.zip, `download.sh` runs `npm install --production` if `node_modules/` is missing
- INDEX.md version changes trigger auto re-download of dist.zip
- One preview server instance per session
- Always attach `?theme=` and `?lang=` params to the preview link
- Theme from `$CTX.THEME`, locale from `$CTX.LOCALE`
- Never use `python3 -m http.server` as a substitute
- Use port 3000 (matching sandbox.yao ports configuration)
- Pass `WORKDIR` env so the server can resolve `.attachments/clips/` for clip_write
