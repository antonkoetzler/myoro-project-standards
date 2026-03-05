# Tailwind CSS + shadcn/ui

## Utility-First

- Use Tailwind utility classes for all layout, spacing, color, and typography.
- Do not create custom CSS files for things expressible with utilities.
- Custom CSS is permitted only for things genuinely impossible with utilities (complex animations, third-party library overrides).

## No Arbitrary Values

Arbitrary values (`p-[17px]`, `text-[#1a2b3c]`) are a red flag. They mean a design token is missing.

- Add the value to the Tailwind config (`theme.extend`) or CSS custom properties instead.
- Exception: truly one-off values that cannot be tokenized — but document why.

## Component Library

- **shadcn/ui** is the canonical component library: install components as source files you own and can modify.
- **Radix UI** primitives for accessible unstyled components (Dialog, Dropdown, Tooltip, etc.).
- Do not mix multiple component libraries in one project (e.g. shadcn + MUI + Chakra).
- Prefer composing from primitives over installing heavy opinionated libraries.

## Theming

- Define CSS custom properties in `globals.css` under `@layer base`:
  ```css
  @layer base {
    :root {
      --background: 0 0% 100%;
      --foreground: 222.2 84% 4.9%;
      --primary: 222.2 47.4% 11.2%;
      /* ... */
    }
    .dark {
      --background: 222.2 84% 4.9%;
      /* ... */
    }
  }
  ```
- For Tailwind v4, use `@theme` in CSS.
- Never hardcode color values in utility classes — always use semantic tokens (`bg-background`, `text-foreground`, `text-primary`).
- Color tokens must use HSL values split as `H S% L%` (without `hsl()` wrapper) to allow Tailwind opacity modifiers to work.

## Class Organization

Apply classes in this consistent order within each element:

1. **Layout & position** — `flex`, `grid`, `absolute`, `relative`, `z-10`
2. **Box model** — `w-`, `h-`, `p-`, `m-`, `border-`
3. **Typography** — `text-`, `font-`, `leading-`, `tracking-`
4. **Visual** — `bg-`, `shadow-`, `rounded-`, `opacity-`
5. **Interactive** — `cursor-`, `hover:`, `focus:`, `active:`
6. **Responsive** — `sm:`, `md:`, `lg:`, `xl:`
7. **Dark mode** — `dark:`

Use a Prettier plugin (`prettier-plugin-tailwindcss`) to enforce this automatically.

## No Inline Styles

- Do not use `style={{ }}` for values expressible with utility classes.
- Exception: genuinely dynamic values calculated at runtime (e.g. a chart bar width based on data) that cannot be expressed with utilities or CSS custom properties.

## Dark Mode

- Use the `class` strategy (not `media`) in `tailwind.config` to enable manual toggle support.
- Always define `dark:` variants alongside light variants when adding color, background, or border classes.
- Test dark mode on every new component.

## No CSS-in-JS

- Do not use styled-components, Emotion, or similar CSS-in-JS libraries in new files.
- Tailwind + shadcn covers all standard component styling needs.
- For dynamic styles, use CSS custom properties or `cn()` / `clsx()` for conditional class application.
