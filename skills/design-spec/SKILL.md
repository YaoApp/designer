---
name: design-spec
trigger: When creating design-spec.css, setting brand colors, extracting design tokens from a reference, searching design trends, or generating CSS custom properties
description: Manage design-spec.css — match resource library, handle medium differentiation (web/app/poster), auto-learn from completed projects
---

# Design Spec Management

Create and manage `design-spec.css` — the single source of CSS custom properties for
a design project. Design specs are generated from palette YAML + medium-specific defaults.

## Priority: Resource Library First

Before generating from scratch, check the resource library for matching schemes:

```bash
cat $WORKDIR/design-works/.cache/assets/INDEX.md
```

Matching logic:
1. **Exact match** (industry + scene + medium) → copy `design-spec.css` directly, present for confirmation
2. **Near match** → propose with adjustments noted, confirm before applying
3. **No match** → generate from scratch with palette YAML

## Medium Differentiation

design-spec.css must be scoped to the correct medium. Properties vary:

| Property | Web | App | Poster |
|----------|-----|-----|--------|
| Default width | 1200-1440px | 375px | 800px |
| Base font size | 16px | 16px (touch-friendly) | dynamic (vw units) |
| Min font size | 12px | 14px (legibility) | no limit |
| Spacing grid | 4px base | 8px base | free |
| Color contrast | WCAG AA required | WCAG AA required | not enforced |
| Interaction states | hover + focus + active | active only (no hover) | none |
| Border radius | 4-8px | 12-16px | free |
| Font preference | Inter / Roboto | Roboto / system fonts | Playfair / display fonts |

## design-spec.css Output Format

```css
/* === Design Tokens for {Project Name} === */
/* Medium: {web|app|poster} */
/* Colors: from palette YAML (auto-generated) */

:root {
  /* Color System */
  --color-primary: #4F46E5;
  --color-primary-hover: #4338CA;
  --color-primary-light: #E0E7FF;
  --color-secondary: #0EA5E9;
  --color-secondary-hover: #0284C7;
  --color-secondary-light: #E0F2FE;
  --color-accent: #F59E0B;
  --color-accent-hover: #D97706;
  --color-accent-light: #FEF3C7;
  --color-surface: #FFFFFF;
  --color-surface-alt: #F9FAFB;
  --color-surface-hover: #F3F4F6;
  --color-text-primary: #111827;
  --color-text-secondary: #6B7280;
  --color-text-disabled: #D1D5DB;
  --color-text-inverse: #FFFFFF;
  --color-border: #E5E7EB;
  --color-border-focus: #4F46E5;
  --color-success: #10B981;
  --color-warning: #F59E0B;
  --color-error: #EF4444;
  --color-info: #3B82F6;

  /* Typography */
  --font-sans: 'Inter', 'Noto Sans SC', -apple-system, sans-serif;
  --font-serif: 'Playfair Display', 'Noto Serif SC', Georgia, serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', monospace;
  --font-hand: 'LXGW WenKai', cursive;
  --font-icon: 'Material Symbols Rounded';
  --font-body: var(--font-sans);
  --font-heading: var(--font-sans);

  --text-base: 16px;
  --text-sm: 0.875rem;
  --text-lg: 1.125rem;
  --text-xl: 1.25rem;
  --text-2xl: 1.5rem;
  --text-3xl: 1.875rem;

  /* Spacing (4px grid) */
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-5: 20px;
  --space-6: 24px;
  --space-8: 32px;
  --space-10: 40px;
  --space-12: 48px;

  /* Border Radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;

  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.07);
  --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);

  /* Layout */
  --page-width: 1200px;
  --page-width-narrow: 800px;
  --sidebar-width: 240px;
  --header-height: 56px;
}

/* Dark mode overrides — only when mode is "dark" */
[data-theme="dark"] {
  --color-surface: #1F2937;
  --color-surface-alt: #111827;
  --color-text-primary: #F9FAFB;
  --color-text-secondary: #9CA3AF;
}
```

## Generating from Palette YAML

```bash
# Read palette, generate color section of design-spec.css
python3 -c "
import yaml, sys
with open('.library/palettes/2024/saas-blue.yml') as f:
    pal = yaml.safe_load(f)['palette']
colors = pal['colors']
dark = pal.get('dark_mode', {})

for role in ['primary', 'secondary', 'accent']:
    if role in colors and colors[role]:
        for k, v in colors[role].items():
            suffix = '' if k == 'base' else f'-{k}'
            print(f'  --color-{role}{suffix}: {v};')

for role in ['surface', 'text', 'border']:
    if role in colors and colors[role]:
        for k, v in colors[role].items():
            if k == 'base':
                print(f'  --color-{role}: {v};')
            else:
                print(f'  --color-{role}-{k}: {v};')

if 'semantic' in colors and colors['semantic']:
    for k, v in colors['semantic'].items():
        print(f'  --color-{k}: {v};')
"
```

## Extracting from Reference

When user provides a reference URL:
1. `web_fetch` the page
2. Extract: colors, fonts, spacing, border-radius, layout patterns
3. Infer medium type (web/app/poster)
4. Generate design-spec.css with `/* Source: {url} */` comment
5. Ask user: "Save this scheme to the resource library?"

## Searching Design Trends

```bash
tai tool web_search '{"query": "2026 web design trends UI patterns typography"}'
```

Synthesize results, recommend, confirm, apply. Optionally save as new scheme to
`.library/designs/{year}/`.

## Auto-Learning from Completed Projects

When user confirms satisfaction ("looks good", "I like it", "ship it"):

1. Propose: "Save this as a reusable design scheme?"
2. If yes, extract from design-spec.css + HTML analysis:
   - Colors, fonts, spacing, layout patterns
   - Infer: industry, scenes, medium, style tags
3. Show extracted manifest for confirmation
4. Save to `.library/designs/{year}/{scheme-name}/`

## Workflow Summary

```
User Request
  ├─ "Create design spec" → Check resource library → Match?
  │     ├─ Exact → Copy scheme → Show → Confirm
  │     ├─ Near  → Recommend → Confirm → Tweak
  │     └─ None  → Generate from palette YAML (by medium)
  ├─ "Reference this page" → Extract → Show → Confirm → Update
  │     └─ Ask: "Save to library?"
  ├─ "Search trends" → web_search → Summarize → Recommend → Apply
  ├─ "Change brand color" → Update palette YAML → Regenerate design-spec.css colors
  └─ Project done + user happy → Auto-learn → Abstract → Save to .library/
```

## Rules

- ALWAYS check the resource library before generating from scratch
- Medium type must be annotated in the CSS header comment
- web/app/poster use different default values — never mix them
- Colors section is auto-generated from palette YAML (never hand-edit)
- When updating existing design-spec.css, preserve user-edited values (diff before overwrite)
- Extracted schemes: `source: "extracted"`, curated: `source: "curated"`, trends: `source: "trending"`
- Auto-learning cap: 20 extracted schemes per year, evict oldest on overflow
- Always ask before saving extracted schemes to the resource library
