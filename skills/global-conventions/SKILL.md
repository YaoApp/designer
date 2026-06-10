---
name: global-conventions
trigger: When setting global defaults (font, page width, naming), running first-time setup wizard, or modifying cross-project conventions
description: Manage global design conventions — .conventions.yml for fonts, viewport, CSS rules, HTML rules, images, and typography defaults
---

# Global Conventions

Manage cross-project design conventions. All new projects inherit these defaults.
Individual projects can override them in their own `project.yml`.

## Storage

Global conventions live at `$WORKDIR/design-works/.conventions.yml`:

```yaml
fonts:
  body: "Inter"
  heading: "Inter"
  mono: "JetBrains Mono"
  chinese: "Noto Sans SC"

viewport:
  default_width: 1200
  breakpoints:
    - width: 375
      label: "Phone"
    - width: 768
      label: "Tablet"
    - width: 1200
      label: "Desktop"

css:
  naming: "bem"
  variables_prefix: "--"
  color_format: "hex"
  layout: "css-grid"

html:
  doctype: "html5"
  charset: "utf-8"
  lang_default: "zh-CN"
  indent: "2-spaces"

images:
  format: "webp"
  max_width: 2000
  lazy_loading: true

color_variables:
  format: "{role}-{variant}"
  roles:
    - primary
    - secondary
    - accent
    - success
    - warning
    - error
    - surface
    - text
    - border

typography:
  scale: "major-third"
  base_size: 16
  line_height_body: 1.6
  line_height_heading: 1.2
  max_line_length: 72
```

## Viewing Conventions

```bash
cat $WORKDIR/design-works/.conventions.yml 2>/dev/null || echo "{}"
```

## Modifying Conventions

Directly edit the corresponding field in `.conventions.yml`. Common operations:

```bash
# Set global default font
# Edit fonts.body and fonts.heading fields

# Set global page width
# Edit viewport.default_width

# Switch to utility-first CSS naming
# Edit css.naming to "utility-first"
```

## First-Time Initialization Wizard

When `.conventions.yml` does not exist, guide the user:

1. **Font preference**: Default English and Chinese fonts?
2. **Target device**: Desktop-first / mobile-first / fully responsive?
3. **CSS style**: BEM naming or utility-first?
4. **Color format**: HEX or HSL?
5. **Indentation**: 2 spaces or 4 spaces?

Generate `.conventions.yml` from answers.

## Convention Inheritance

New projects inherit from global conventions:
- `project.yml` inherits `viewport` and `breakpoints`
- HTML templates inherit `css`, `html`, `color_variables` rules
- Font lists read from `fonts` field

Project-level settings override global defaults.

## Rules

- `.conventions.yml` is the global default; project config can override
- Modifying global conventions does NOT affect already-created projects
- First use MUST run the initialization wizard or provide defaults
- All keys use snake_case
- Must be valid YAML
- Missing fields fall back to built-in hardcoded defaults — never skip with empty `{}`
