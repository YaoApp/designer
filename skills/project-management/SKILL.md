---
name: project-management
trigger: When creating a new design project, initializing project structure, or setting up design workspace
description: Create and manage design project structure — project.yml, directory layout, and medium separation (web/app/poster)
---

# Project Management

Create and manage the design project directory structure. Each project is
self-contained under `$WORKDIR/design-works/{project-name}/`.

## Create a New Project

```bash
PROJECT="my-saas-dashboard"
mkdir -p $WORKDIR/design-works/$PROJECT/{pages,.library}
```

## project.yml Format

Create `$WORKDIR/design-works/{project-name}/project.yml`:

```yaml
project:
  name: "My SaaS Dashboard"
  version: "1.0"
  created: "2026-06-10"

  medium: "web"                   # web | app | poster
  style: "enterprise"             # one of 20 styles
  mode: "light"                   # light | dark

  palette:
    ref: ".library/palettes/2024/saas-blue.yml"
    name: "SaaS Blue"

  typography:
    body: "Inter"
    heading: "Inter"
    mono: "JetBrains Mono"
    hand: "LXGW WenKai"

  layout:
    type: "sidebar-left"          # single-column | sidebar-left
    max_width: 1440
    responsive: true
    header_height: 56
    sidebar_width: 240

pages:
  - name: "Home"
    route: "index.html"
    template: "hero"
  - name: "Dashboard"
    route: "dashboard.html"
    template: "grid"
```

## Medium-Specific Defaults

### Web
```yaml
layout:
  type: "sidebar-left"
  max_width: 1440
  header_height: 56
  sidebar_width: 240
```

### App
```yaml
layout:
  type: "single-column"
  max_width: 375
  header_height: 44
  tab_bar_height: 56
```

### Poster
```yaml
layout:
  type: "single-column"
  max_width: 800
  header_height: 0
```

## Read Global Conventions

Before creating project.yml, check for global conventions:

```bash
cat $WORKDIR/design-works/.conventions.yml 2>/dev/null || echo "{}"
```

Global conventions override defaults for `max_width`, `header_height`, and
`sidebar_width`.

## Caching Downloaded Assets

When a palette or design scheme is downloaded from the registry, copy it to
the local library for reuse:

```bash
# Download palette
curl -s https://raw.githubusercontent.com/YaoApp/design-assets/main/palettes/2024/saas-blue.yml \
  -o $WORKDIR/design-works/.cache/assets/palettes/2024/saas-blue.yml

# Copy to library
mkdir -p $WORKDIR/design-works/.library/palettes/2024
cp $WORKDIR/design-works/.cache/assets/palettes/2024/saas-blue.yml \
   $WORKDIR/design-works/.library/palettes/2024/saas-blue.yml
```

## Rules

- Project names are kebab-case
- project.yml is the single source of truth for project configuration
- palette is referenced by path (not inlined) — the same palette can be shared across projects
- Design schemes (manifest.yml + design-spec.css) go under `.library/designs/{year}/{scheme}/`
- When downloading, always show the user what's being fetched: "Downloading SaaS Blue palette (2024)..."
- Downloaded assets are cached in `.cache/assets/` and copied to `.library/`
