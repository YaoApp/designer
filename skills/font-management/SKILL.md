---
name: font-management
trigger: When installing fonts, listing available fonts, extracting fonts from a reference site, or recommending fonts for a project type
description: Font management — list, install, remove, and recommend fonts from 11 seed typefaces + Google Fonts
---

# Font Management

Manage typography assets. 11 seed typefaces are hosted at GitHub
`YaoApp/design-assets` and downloaded on demand. Additional fonts can be
installed via Google Fonts.

## Seed Typefaces (11 total)

### English (7)

| Font | Category | Weights | Use |
|------|----------|---------|-----|
| Inter | sans-serif | 400-800 (variable) | Default body |
| Roboto | sans-serif | 400, 500, 700 | Material Design default |
| Open Sans | sans-serif | 400, 600, 700 | High readability body |
| Playfair Display | serif | 400, 700, 900 | Headings, posters, luxury |
| DM Sans | sans-serif | 400, 500, 700 | Modern geometric headings |
| Space Grotesk | sans-serif | 400, 500, 700 | Tech/creative headings |
| JetBrains Mono | monospace | 400, 500, 700 | Code, data tables |

### Chinese (3)

| Font | Category | Weights | Use |
|------|----------|---------|-----|
| Noto Sans SC | sans-serif | 400, 500, 700 | Default Chinese body |
| Noto Serif SC | serif | 400, 700 | Chinese serif headings |
| LXGW WenKai | handwritten | 400, 500 | Chinese handwriting style |

### Icon (1)

| Font | Category | Use |
|------|----------|-----|
| Material Symbols Rounded | icon | 2500+ vector icons, variable |

## Listing Available Fonts

Parse the font table from INDEX.md and check local cache:

```bash
cat $WORKDIR/design-works/.cache/assets/INDEX.md
```

For each font, check if cached:

```bash
ls $WORKDIR/design-works/.cache/assets/fonts/{family}/{file} 2>/dev/null \
  && echo "cached" || echo "not cached"
```

Display as a table with status: ✅ cached or ☁️ on-demand.

## Font Recommendations

| Project Type | Heading | Body | Chinese |
|-------------|---------|------|---------|
| Enterprise dashboard | Inter 600-700 | Inter 400 | Noto Sans SC |
| Brand site | Space Grotesk 700 | Inter 400 | Noto Sans SC |
| Blog / content | Playfair Display 700 | Open Sans 400 | Noto Serif SC |
| Tech dark mode | Space Grotesk 500 | Inter 400 | Noto Sans SC |
| E-commerce | DM Sans 700 | Inter 400 | Noto Sans SC |
| App (general) | Roboto 500 | Roboto 400 | Noto Sans SC |
| App (social) | DM Sans 500 | Inter 400 | Noto Sans SC |
| Poster (formal) | Playfair Display 900 | — | Noto Serif SC |
| Poster (creative) | Space Grotesk 700 | — | LXGW WenKai |

## Installing Fonts

### From GitHub Registry (seed fonts)

```bash
FAMILY="Inter"
FONT_FILE="fonts/inter/Inter-Variable.woff2"
RAW_BASE="https://raw.githubusercontent.com/YaoApp/design-assets/main"
CACHE="$WORKDIR/design-works/.cache/assets/$FONT_FILE"

if [ ! -f "$CACHE" ]; then
  echo "Downloading $FAMILY..."
  mkdir -p "$(dirname "$CACHE")"
  curl -# "$RAW_BASE/$FONT_FILE" -o "$CACHE"
  echo "$FAMILY downloaded"
fi

# Copy to fonts/ and register with preview server
TARGET_DIR="$WORKDIR/design-works/fonts/$(echo "$FAMILY" | tr 'A-Z ' 'a-z-')"
mkdir -p "$TARGET_DIR"
cp "$CACHE" "$TARGET_DIR/"
curl -s -X POST http://localhost:3000/api/fonts/install \
  -H "Content-Type: application/json" \
  -d '{"family": "Inter", "weights": [400, 500, 600, 700, 800]}'
```

### From Google Fonts (non-seed fonts)

```bash
curl -X POST http://localhost:3000/api/fonts/install \
  -H "Content-Type: application/json" \
  -d '{"family": "Montserrat", "weights": [400, 600, 700]}'
```

## Extracting Fonts from Reference

When user provides a reference URL:
1. `web_fetch` the page
2. Extract CSS `font-family` declarations
3. Match against INDEX.md seed fonts first (prefer managed fonts)
4. For unmatched fonts, recommend from Google Fonts
5. Present recommendation for user confirmation before installing

## Chinese/English Font Pairing

| Pairing | EN Heading | EN Body | ZH Heading | ZH Body | Use |
|---------|-----------|---------|------------|---------|-----|
| Classic Enterprise | Inter 700 | Inter 400 | Noto Sans SC 700 | Noto Sans SC 400 | SaaS, dashboard |
| Modern Brand | Space Grotesk 700 | Inter 400 | Noto Sans SC 700 | Noto Sans SC 400 | Brand site |
| Magazine | Playfair Display 900 | Open Sans 400 | Noto Serif SC 700 | Noto Sans SC 400 | Blog, content |
| Tech Dark | Space Grotesk 500 | Inter 400 | Noto Sans SC 500 | Noto Sans SC 400 | Dev tools |
| E-commerce | DM Sans 700 | Inter 400 | Noto Sans SC 700 | Noto Sans SC 400 | Promo landing |
| Warm Handcrafted | DM Sans 500 | Inter 400 | LXGW WenKai 500 | Noto Sans SC 400 | Food, crafts |
| Data Dashboard | Roboto 500 | Roboto 400 | Noto Sans SC 500 | Noto Sans SC 400 | Finance |
| App UI | Roboto 500 | Roboto 400 | Noto Sans SC 500 | Noto Sans SC 400 | Mobile |

## Rules

- Prefer seed fonts — 11 typefaces cover 95% of scenarios
- Download fonts on first use; show user visible download progress
- Only install additional fonts when user explicitly requests a special typeface
- Seed fonts are protected — deletion must check target is NOT one of the 11
- Chinese fonts are large (Noto Sans SC ~8MB per weight); warn before downloading
- Variable fonts (Inter, Material Symbols) preferred to reduce file count
- INDEX.md version changes auto-override cached font files
- User-installed non-seed fonts cached to `.cache/assets/fonts/` user subdirectory
