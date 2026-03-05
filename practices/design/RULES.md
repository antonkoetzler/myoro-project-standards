# UI/UX Design Standards

Pure design discipline — no code. Applies to every design tool and platform.

## Visual Hierarchy

- Size, weight, contrast, color, proximity are the hierarchy tools. Use deliberately.
- One primary action per screen. Never bury primary actions. The eye needs a clear path.

## Typography

- Modular type scale: 1.25× or 1.333× ratio. No arbitrary sizes.
- Body: min 16px, line-height 1.4–1.6, max 65–75 characters per line.
- Max 2 typefaces per project. Never font size alone to convey meaning.
- Contrast: 4.5:1 for normal text, 3:1 for large text (18px+ or 14px+ bold).

## Color

- Semantic names: `primary`, `surface`, `error`, `warning`, `success`, `info`.
- 60-30-10 rule: 60% neutral, 30% secondary, 10% accent.
- Never color as the only differentiator — always pair with icon, label, or shape.
- Dark mode: purpose-built palettes from day one. Never invert the light palette.
- Test all combinations for WCAG AA contrast.

## Spacing & Layout

- 4px or 8px base unit. Multiples only: 4, 8, 12, 16, 24, 32, 48, 64, 96px.
- No arbitrary spacing values. Align to a grid. Proximity groups; whitespace separates.

## UX Patterns

- Touch targets: min 44×44px.
- Progressive disclosure: show what's needed now; details on demand.
- Feedback: respond in 100ms; loading indicator after 1s; done state after 10s.
- Error prevention over error recovery. Confirm destructive actions.
- Recognition over recall: show options, don't make users remember.

## Forms

- Single column preferred. Labels above fields, not inside.
- Validate on blur, not on every keystroke.
- Error messages inline, next to the offending field.
- Primary CTA bottom-right. Secondary to its left. Never clear form on error.

## States

- Design Empty, Loading, and Error states for every component — not just the happy path.
- Empty: explain why + provide a clear action.
- Loading: skeleton screens for content; spinners for actions.
- Error: be specific and actionable ("Couldn't connect to server") not generic.

## Motion

- Animation must have a purpose. No animation for decoration.
- Timings: micro-interactions ≤150ms, transitions ≤300ms, page transitions ≤500ms.
- Always respect `prefers-reduced-motion`. Ease-out entering, ease-in leaving.

## Accessibility

- Accessibility is designed in from the start — not added after launch.
- Color alone never conveys meaning. Pair with icon, label, or shape.
- Tab order follows visual reading order.
- Focus indicators always visible. Never `outline: none` without a replacement.
- Touch targets ≥44×44px. Meaningful labels on all interactive elements.
- Test with a screen reader before shipping.
