---
name: color-palette
trigger: When picking colors, generating color schemes, extracting colors from URLs, searching color trends, or using traditional Chinese colors
description: Color palette management — generate standard YAML palettes from built-in library, external search, URL extraction, or traditional Chinese colors
---

# Color Palette Management

Generate color palettes in the standard YAML format that can be consumed by
design-spec.css and HTML templates. This is the "source of truth" for all colors.

## Standard YAML Output Format

All palettes use this format for downstream compatibility:

```yaml
palette:
  name: "SaaS Blue"
  version: "1.0"
  source: "curated"           # curated | extracted | trending | traditional | custom
  source_url: null

  tags:
    industry: "saas"
    style: "enterprise"
    mode: "light"
    season: null
    culture: null

  colors:
    primary:
      base: "#4F46E5"
      hover: "#4338CA"
      light: "#E0E7FF"

    secondary:
      base: "#0EA5E9"
      hover: "#0284C7"
      light: "#E0F2FE"

    accent:
      base: "#F59E0B"
      hover: "#D97706"
      light: "#FEF3C7"

    surface:
      base: "#FFFFFF"
      alt: "#F9FAFB"
      hover: "#F3F4F6"

    text:
      primary: "#111827"
      secondary: "#6B7280"
      disabled: "#D1D5DB"
      inverse: "#FFFFFF"

    border:
      base: "#E5E7EB"
      focus: "#4F46E5"

    semantic:
      success: "#10B981"
      warning: "#F59E0B"
      error: "#EF4444"
      info: "#3B82F6"

  dark_mode:
    surface:
      base: "#1F2937"
      alt: "#111827"
    text:
      primary: "#F9FAFB"
      secondary: "#9CA3AF"
```

## YAML → CSS Conversion Rules

| YAML Path | CSS Variable | Rule |
|-----------|-------------|------|
| `primary.base` | `--color-primary` | base variant omits suffix |
| `primary.hover` | `--color-primary-hover` | |
| `primary.light` | `--color-primary-light` | |
| `secondary.base` | `--color-secondary` | base omits suffix |
| `accent.base` | `--color-accent` | base omits suffix |
| `surface.base` | `--color-surface` | base omits suffix |
| `surface.alt` | `--color-surface-alt` | |
| `text.primary` | `--color-text-primary` | text NEVER omits suffix |
| `text.secondary` | `--color-text-secondary` | |
| `text.disabled` | `--color-text-disabled` | |
| `text.inverse` | `--color-text-inverse` | |
| `border.base` | `--color-border` | base omits suffix |
| `border.focus` | `--color-border-focus` | |
| `semantic.error` | `--color-error` | semantic prefix omitted |
| `semantic.success` | `--color-success` | |
| `dark_mode.surface.base` | Inside `[data-theme="dark"]` block | dark mode overrides |

### Conversion Script

```bash
python3 -c "
import yaml
with open('palette.yml') as f:
    p = yaml.safe_load(f)['palette']['colors']

for role in ['primary', 'secondary', 'accent']:
    if role in p and p[role]:
        for k, v in p[role].items():
            suffix = '' if k == 'base' else f'-{k}'
            print(f'  --color-{role}{suffix}: {v};')

for role in ['surface', 'text', 'border']:
    if role in p and p[role]:
        for k, v in p[role].items():
            if k == 'base':
                print(f'  --color-{role}: {v};')
            else:
                print(f'  --color-{role}-{k}: {v};')

if 'semantic' in p and p[semantic]:
    for k, v in p['semantic'].items():
        print(f'  --color-{k}: {v};')
"
```

## Capabilities

### 1. Built-in Industry Palettes (12 schemes)

| Name | Industry | Style | Primary | Secondary |
|------|----------|-------|---------|-----------|
| SaaS Blue | saas | enterprise | #4F46E5 | #0EA5E9 |
| Finance Green | fintech | enterprise | #059669 | #10B981 |
| E-commerce Warm | ecommerce | playful | #F97316 | #F59E0B |
| Healthcare Calm | healthcare | soft | #0891B2 | #06B6D4 |
| Education Kid | education | playful | #7C3AED | #A78BFA |
| Media Editorial | media | editorial | #1E293B | #334155 |
| Creative Purple | creative | editorial | #7C3AED | #C084FC |
| Real Estate Luxury | realestate | luxury | #92400E | #B45309 |
| Food Warm | food | soft | #EA580C | #F97316 |
| Travel Mood | travel | soft | #0891B2 | #22D3EE |
| Tech Dark | saas | tech | #6366F1 | #818CF8 |
| Minimalist Slate | startup | minimalist | #334155 | #64748B |

Download from registry:

```bash
curl -s https://raw.githubusercontent.com/YaoApp/design-assets/main/palettes/2024/saas-blue.yml \
  -o $WORKDIR/design-works/.cache/assets/palettes/2024/saas-blue.yml
```

### 2. Traditional Chinese Colors (742 colors)

When user asks for traditional Chinese colors, read the colors database:

```bash
cat $WORKDIR/design-works/.cache/assets/palettes/traditional/colors.yml
```

Download from registry if not cached:

```bash
curl -s https://raw.githubusercontent.com/YaoApp/design-assets/main/palettes/traditional/colors.yml \
  -o $WORKDIR/design-works/.cache/assets/palettes/traditional/colors.yml
```

Search by color name, season, or dynasty. Generate palette YAML with `source: "traditional"`
and filled `tags.culture` and `tags.season` fields.

### 3. Extract from Reference URL

When user provides a URL:
1. `web_fetch` the page
2. Extract CSS colors (`color`, `background-color`, `--color-*` variables)
3. Classify by semantic role (largest background → surface, most-used text → text.primary, etc.)
4. Output palette YAML with `source: "extracted"` and `source_url` filled

### 4. Search Trending Colors

```bash
tai tool web_search '{"query": "2026 UI color trends popular palettes"}'
```

Synthesize results into palette YAML. Mark `source: "trending"`.

### 5. Standalone Color Consultation

When user needs colors from scratch, use AskUserQuestion:
- Industry? (saas / ecommerce / healthcare / ...)
- Style? (enterprise / playful / tech / ...)
- Temperature? (warm / cool / neutral)
- Mode? (light / dark)

Match closest scheme from built-in library, propose 2-3 candidates.

### 6. Adjust Existing Palette

Common adjustments:
- "Make it warmer" → shift primary hue +15°, regenerate derivations
- "Lower contrast" → move text.primary closer to surface.base
- "Add an accent color" → pick from complementary colors

## Boundary with design-spec

| Task | Handled By | Notes |
|------|-----------|-------|
| Extract colors from URL | **color-palette** | Outputs palette YAML only |
| Extract full design spec from URL | **design-spec** | Calls color-palette + extracts fonts/spacing/layout |
| Search color trends | **color-palette** | web_search → palette YAML |
| Search design trends | **design-spec** | web_search → full tokens |
| Generate palette | **color-palette** | Built-in / traditional / custom |
| Generate full CSS tokens | **design-spec** | Consumes palette YAML + adds typography/spacing/shadows |

## External Color Resources

| Resource | Type | Scale | Use |
|----------|------|-------|-----|
| [Traditional Chinese Colors](https://nevertoday.github.io/zhongguo-traditional-colors/) | Color cards | 742 + harmony data | Eastern aesthetics |
| [Coolors](https://coolors.co) | Generator | Unlimited | Quick exploration |
| [Adobe Color](https://color.adobe.com) | Color wheel | Unlimited | Color theory |
| [ColorHunt](https://colorhunt.co) | Curated palettes | Thousands | Inspiration |
| [UI Gradients](https://uigradients.com) | Gradients | 300+ | Gradient backgrounds |
| [Open Color](https://yeun.github.io/open-color/) | Design tokens | 13 colors × 10 steps | Design systems |

## Rules

- All palettes must output the standard YAML format
- `tags` must be fully filled for resource library searchability
- Traditional Chinese palettes: `source: "traditional"` with `culture` and `season` tags
- Extracted palettes: `source_url` is required
- YAML → CSS conversion is lossless; variable names follow fixed mapping
- Palette YAML stored at `.library/palettes/{year}/` or `.library/palettes/traditional/`
- `text.primary` → `--color-text-primary` (NEVER `--color-text`)
- `semantic.*` keys omit the "semantic" prefix in CSS: `semantic.error` → `--color-error`
- Only apply `dark_mode` when manifest `mode` is `"dark"`, not just because it exists
