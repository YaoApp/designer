---
name: project-planning
trigger: When the user describes a design need, asks for design guidance, or initiates a new design project
description: Guide the user through design project planning — collect requirements, match design library, output DESIGN.md blueprint
---

# Project Planning

Before creating any files, plan the design project. This skill covers the
planning workflow: requirements gathering, resource matching, and blueprint output.

**IMPORTANT**: After writing DESIGN.md, STOP and present it for confirmation.
Do NOT generate pages or CSS until the user confirms.

## Goal

Produce `$WORKDIR/design-works/{project-name}/DESIGN.md` — the blueprint
that answers: what medium, what style, what colors, and what pages.

## Step 1 — Collect Requirements

Read the design registry index first:

```bash
# Download the asset index (first use)
mkdir -p $WORKDIR/design-works/.cache/assets
curl -s https://raw.githubusercontent.com/YaoApp/design-assets/main/INDEX.md \
  -o $WORKDIR/design-works/.cache/assets/INDEX.md
```

Then ask the user (use AskUserQuestion for interactive mode):

1. **Medium** — web, app, or poster?
2. **Scene type** — dashboard, landing, hero, gallery, list, detail, form, or content?
3. **Style** — enterprise, playful, minimalist, tech, editorial, swiss-modern, art-deco,
   noir, industrial, brutalist, glassmorphism, neumorphism, neobrutalism, vibrant,
   organic, cyberpunk, retro-futurism, modern-agency, soft, luxury?
4. **Reference** — any URL or image to draw inspiration from?

For one-shot mode, infer reasonable defaults from the user's description.

## Step 2 — Match Design Resource Library

Read the INDEX.md to find matching schemes:

```bash
cat $WORKDIR/design-works/.cache/assets/INDEX.md
```

Match on industry, style, and scene:
- **Exact match** → propose the scheme directly
- **Near match** → propose with adjustments
- **No match** → generate from scratch (trigger color-palette skill)

## Step 3 — Resolve Color Palette

If a matching scheme has a `colors_ref`, download its palette:

```bash
curl -s https://raw.githubusercontent.com/YaoApp/design-assets/main/palettes/2024/saas-blue.yml \
  -o $WORKDIR/design-works/.cache/assets/palettes/2024/saas-blue.yml
```

If no matching scheme or user wants custom colors, read the color-palette skill:

```
cat $CTX_SKILLS_DIR/color-palette/SKILL.md
```

## Step 4 — Output DESIGN.md

Write to `$WORKDIR/design-works/{project-name}/DESIGN.md`:

```markdown
# {Project Name} — Design Blueprint

## Overview
- Medium: web | app | poster
- Style: {style name}
- Color Palette: {palette name} ({year})
- Mood: {mood description}

## Design System
- colors_ref: ".library/palettes/{year}/{palette-name}.yml"
- body font: {font family}
- heading font: {font family}
- mono font: {font family}
- layout: {type}, max_width: {px}
- responsive: true | false

## Page Inventory
| # | Page | Template | Purpose |
|---|------|----------|---------|
| 1 | Home | hero | Landing page with hero banner |
| 2 | Dashboard | grid | Dashboard with card grid |
...

## Color Palette Preview
Primary: #XXXXXX
Secondary: #XXXXXX
Accent: #XXXXXX
Surface: #XXXXXX
Text: #XXXXXX
```

## Step 5 — STOP & CONFIRM

Present the blueprint summary. Ask the user to confirm before proceeding to
implementation. Key points to highlight:
- The matched (or custom) palette
- The page list and template choices
- Any assumptions made

**Skip confirmation ONLY when**:
- Mode is "task"
- User says "直接做" / "just do it" / "不用确认"

## Tips

- Default to `web` medium if the user doesn't specify
- For SaaS/dashboard requests, default to `saas-blue` (2024)
- For e-commerce, default to `ecommerce-warm` (2024)
- For AI/tech, default to `ai-landing-dark` (2025) if they want dark mode
- For mobile apps, default to `healthcare-soft` or `food-app-warm` based on industry
- The asset registry is at GitHub `YaoApp/design-assets` — always check it first
- Use `curl -sI` (HEAD request) to check if an asset is cached locally before downloading
