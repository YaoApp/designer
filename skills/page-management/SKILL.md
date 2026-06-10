---
name: page-management
trigger: When creating, modifying, or listing HTML pages in a design project
description: Create and manage HTML pages from design templates — web, app, and poster mediums
---

# Page Management

Create HTML pages from templates pulled from the GitHub asset registry.
Pages go under `$WORKDIR/design-works/{project-name}/pages/`.

## Available Templates

Download the template index to discover available templates:

```bash
cat $WORKDIR/design-works/.cache/assets/INDEX.md
```

### Web Templates (6)
| Template | File | Use Case |
|----------|------|----------|
| blank | `templates/web/blank.html` | Empty page with container + header |
| hero | `templates/web/hero.html` | Hero banner + content sections |
| grid | `templates/web/grid.html` | Grid container + card placeholders |
| form | `templates/web/form.html` | Centered form card |
| list | `templates/web/list.html` | Header + table/filter area |
| detail | `templates/web/detail.html` | Breadcrumb + info sections |

### App Templates (5)
| Template | File | Use Case |
|----------|------|----------|
| blank | `templates/app/blank.html` | Mobile blank page (375px, 44px touch-target) |
| grid | `templates/app/grid.html` | Mobile card grid |
| form | `templates/app/form.html` | Mobile form page |
| list | `templates/app/list.html` | Mobile list page |
| detail | `templates/app/detail.html` | Mobile detail page |

### Poster Templates (3)
| Template | File | Use Case |
|----------|------|----------|
| blank | `templates/poster/blank.html` | Poster blank (800px, vw units) |
| hero | `templates/poster/hero.html` | Poster hero section |
| grid | `templates/poster/grid.html` | Poster grid layout |

## Creating a Page

### Step 1 — Download the template (if not cached)

```bash
MEDIUM="web"
TEMPLATE="hero"
CACHE="$WORKDIR/design-works/.cache/assets/templates/$MEDIUM/$TEMPLATE.html"

if [ ! -f "$CACHE" ]; then
  echo "Downloading $MEDIUM/$TEMPLATE template..."
  mkdir -p $(dirname "$CACHE")
  curl -s https://raw.githubusercontent.com/YaoApp/design-assets/main/templates/$MEDIUM/$TEMPLATE.html \
    -o "$CACHE"
fi
```

### Step 2 — Copy template to project

```bash
PROJECT="my-saas-dashboard"
cp $CACHE $WORKDIR/design-works/$PROJECT/pages/index.html
```

### Step 3 — Customize the page

After copying, customize the page:

1. **Link design-spec.css**: Add `<link rel="stylesheet" href="../design-spec.css">` in `<head>`
2. **Update title**: Set the `<title>` to match the page purpose
3. **Replace placeholder content**: Swap lorem ipsum with real content
4. **Link navigation**: Ensure nav links point to the right pages
5. **Use CSS custom properties**: Use `var(--color-primary)`, `var(--font-body)`, etc.

## Listing Pages

```bash
ls -la $WORKDIR/design-works/{project-name}/pages/
```

## Removing a Page

```bash
rm $WORKDIR/design-works/{project-name}/pages/{name}.html
```

## Medium-Specific Rules

### Web
- Default page width: `--page-width: 1440px` (from design-spec.css)
- Header height: `--header-height: 56px`
- Use `px` units for spacing and sizing

### App
- Default page width: `--page-width: 375px`
- Header height: `--header-height: 44px`
- Touch target: `--touch-target: 44px`
- Include `<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">`

### Poster
- Default page width: `--page-width: 800px`
- All text and spacing use `vw` units for scaling
- Include `print-color-adjust: exact` in CSS

## Rules

- Every page links to the project's `design-spec.css` for design tokens
- Every page links to `/api/fonts.css` for fonts (served by preview-server)
- Navigation links between pages use relative paths
- Page filenames are kebab-case
- The "index.html" page is the default entry point
- Don't modify cached templates — customize the copy in the project
