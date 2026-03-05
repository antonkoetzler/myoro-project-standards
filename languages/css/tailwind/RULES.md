# Tailwind CSS + shadcn/ui

## Utility-First

- Tailwind utilities for all layout, spacing, color, typography.
- No custom CSS for things expressible with utilities.
- Custom CSS only for things genuinely impossible with utilities.

## No Arbitrary Values

- `p-[17px]` is a red flag — add the value to `theme.extend` or CSS custom properties.
- Exception: truly one-off values that cannot be tokenized.

## Component Library

- **shadcn/ui** — copy-paste components you own. **Radix UI** for accessible primitives.
- Do not mix multiple component libraries in one project.

## Theming

- CSS custom properties in `globals.css` under `@layer base` (Tailwind v3) or `@theme` (v4).
- Never hardcode colors in utilities — use semantic tokens (`bg-background`, `text-foreground`).
- HSL values split as `H S% L%` (no `hsl()` wrapper) to support Tailwind opacity modifiers.

## Class Organization Order

Layout/position → box model → typography → visual → interactive → responsive → dark mode.

Use `prettier-plugin-tailwindcss` to enforce automatically.

## Rules

- No inline styles for things expressible with utilities.
- Dark mode: `class` strategy. Always define `dark:` variants. Test every component.
- No CSS-in-JS in new files. Use `cn()` / `clsx()` for conditional classes.
