# Designer Agent

`smith.designer` — AI-powered visual design and prototyping agent
for web, app, and poster design projects.

Give it a design brief ("SaaS admin dashboard with enterprise blue theme")
and it plans the full project: picks a color palette, sets up typography,
scaffolds HTML pages from templates, generates a design-spec.css token file,
and serves it all with live reload via preview server.

## How to install

Send this repo URL to Agent Smith:

> Install the designer agent from https://github.com/YaoApp/designer.git

Agent Smith reads the files, deploys them, and `smith.designer` appears in
your agent list ready to use.

## What's inside

| Layer         | Files                                                   |
| ------------- | ------------------------------------------------------- |
| Config        | `package.yao`, `sandbox.yao`, `prompts.yml`             |
| Locales       | `locales/en-us.yml`, `locales/zh-cn.yml`                |
| Tests         | `tests/inputs.jsonl`, `tests/ctx.json`                  |
| Skills        | `skills/*/SKILL.md`                                     |

### Skills (8)

| #   | Skill                 | What it does                                  |
| --- | --------------------- | --------------------------------------------- |
| 1   | `project-planning`    | Collect requirements, match design library, output blueprint |
| 2   | `project-management`  | Create project.yml, directory layout, medium separation |
| 3   | `page-management`     | Create/edit/list HTML pages from design templates |
| 4   | `color-palette`       | Generate standard YAML palettes from built-in library, URLs, or trends |
| 5   | `design-spec`         | Generate design-spec.css from palette YAML, handle web/app/poster |
| 6   | `font-management`     | Install/list/recommend fonts from 11 seed typefaces + Google Fonts |
| 7   | `global-conventions`  | Cross-project defaults for fonts, viewport, CSS rules |
| 8   | `preview-server`      | Start/stop preview server with live reload at port 3000 |

## Architecture

```
User request → project-planning → DESIGN.md (blueprint)
                                   ↓
              project-management → project.yml + dirs
                                   ↓
              page-management    → HTML pages from templates
                                   ↓
              color-palette      → palette.yml (standard YAML)
                                   ↓
              design-spec        → design-spec.css (CSS tokens)
                                   ↓
              font-management    → fonts on demand
                                   ↓
              preview-server     → live preview at port 3000
```

## Design workspace

Everything goes under `$WORKDIR/design-works/{project-name}/`:

```
design-works/
  {project-name}/
    DESIGN.md              # Blueprint (generated in planning)
    project.yml            # Project metadata
    design-spec.css        # CSS custom properties (auto-generated)
    pages/                 # HTML pages
  .cache/assets/           # On-demand GitHub registry cache
  .library/                # Reusable palettes and design schemes
  .conventions.yml         # Global cross-project defaults
```

## Asset registry

Design assets (28 schemes, 31 palettes, 11 typefaces, 14 templates, preview-server dist)
are hosted at `YaoApp/design-assets` and downloaded on demand — nothing is bundled.
