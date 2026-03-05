# UI/UX Design Standards

Pure design discipline. No code conventions — these rules apply to every design tool, every platform.

## Visual Hierarchy

- Size, weight, contrast, color, and proximity are the only tools for establishing hierarchy. Use them deliberately.
- The most important element must be the most visually dominant. Never bury primary actions in visual noise.
- One primary action per screen or view. Everything else is secondary or tertiary. Competing primaries cancel each other out.
- The eye follows a path through the screen — design that path intentionally.

## Typography

- Use a modular type scale with a consistent ratio: 1.25× (Major Third) or 1.333× (Perfect Fourth). Do not pick type sizes arbitrarily.
- Body text: minimum 16px. Line-height 1.4–1.6. Maximum 65–75 characters per line (beyond this, reading becomes laborious).
- Limit to 2 typefaces per project: one for headings, one for body. Never 3 or more — the result is visual noise, not personality.
- Never use font size alone to convey meaning — always pair with weight, color, or another visual differentiator.
- Contrast minimums: 4.5:1 for normal text (under 18px regular or 14px bold), 3:1 for large text (18px+ or 14px+ bold).

## Color

- Use a semantic color system: name colors by role, not by hue.
  - `primary`, `secondary` — brand actions
  - `surface`, `on-surface` — backgrounds and text on them
  - `error`, `warning`, `success`, `info` — system feedback states
- 60-30-10 rule: 60% dominant neutral (backgrounds, surfaces), 30% secondary, 10% accent. Exceeding 10% accent dilutes its power.
- Never use color as the only differentiator for meaning (state, category, status). Always pair with an icon, pattern, label, or shape — this is an accessibility requirement, not a guideline.
- Dark mode: design purpose-built palettes for both light and dark from day one. Do not simply invert the light palette — inversion creates unpredictable contrast ratios.
- Test every color combination for WCAG AA contrast before finalising.

## Spacing & Layout

- Base all spacing on a 4px or 8px unit. Use multiples only: 4, 8, 12, 16, 24, 32, 48, 64, 96px.
- Never use arbitrary values (17px, 23px, 37px). They are impossible to maintain consistently and signal a design that wasn't thought through.
- Proximity: group related elements close together. Use whitespace to separate unrelated elements.
- Align elements to a grid. Visual alignment implies relationship; misalignment implies distinction.
- Generous whitespace is not wasted space — it improves readability and guides the eye.

## UX Patterns

- **Fitts's Law:** Touch targets minimum 44×44px on all interactive elements. Size targets proportionally to their importance — the primary CTA should be larger than secondary actions.
- **Progressive Disclosure:** Show only what is needed for the current task. Surface details on demand. A screen that shows everything is a screen that communicates nothing.
- **Feedback Timing:** UI must respond within 100ms for it to feel instantaneous. Show a loading indicator after 1 second. Show a completion state after 10 seconds (or use progress indicators for longer operations).
- **Error Prevention over Error Recovery:** Validate early, guide the user toward valid input, confirm destructive actions before they happen. It is better to prevent an error than to display a helpful error message.
- **Recognition over Recall:** Show options, don't make users remember syntax, IDs, or previous state. Menus, suggestions, and visible affordances reduce cognitive load.

## Forms

- Single column layout preferred for forms — easier to scan, better on mobile, fewer alignment errors.
- Labels above fields, not inside (placeholder text disappears on focus and cannot serve as a label).
- Validate on blur (when the user leaves a field), not on every keystroke — keystroke validation is disruptive before the user has finished typing.
- Show error messages inline, directly adjacent to the field that caused the error. Never at the top of the form only — users must scroll to find their mistakes.
- Primary CTA at the bottom-right. Secondary action (cancel, back) to its left.
- Never clear the form on error. Preserve every character the user typed — forcing re-entry is a significant friction point.
- Group related fields with visual proximity and optional labelled sections.

## States: Empty, Loading, Error

Every component must be explicitly designed for all three states — not just the happy path.

- **Empty states:** Explain why it is empty and offer a clear next action. "No projects yet" with a Create button is actionable. A blank screen is not. Empty states are also marketing — they set expectations.
- **Loading states:** Use skeleton screens for content-heavy layouts (preserves layout stability). Use spinners only for triggered actions (button clicks, form submissions). Avoid indefinite loading without feedback.
- **Error states:** Be specific. "Couldn't connect to the server — check your connection and try again" is useful. "An error occurred" is not. Give the user something to do.

## Motion & Animation

- Animation must serve a purpose: show a state change, guide attention, confirm an action, or orient the user after navigation. Decoration is not a purpose.
- Micro-interactions (hover, focus, toggle): ≤150ms. Transitions between states: ≤300ms. Page / screen transitions: ≤500ms. Beyond these durations, animation feels slow.
- No animation purely for aesthetic reasons. Every animated element must answer: what does this communicate?
- Always respect the `prefers-reduced-motion` media query. Provide static alternatives for all motion.
- Ease-out for elements entering the screen (they start fast, settle into place). Ease-in for elements leaving (they start slow, accelerate away). Ease-in-out for elements transitioning between positions.

## Accessibility as a Design Discipline

Accessibility is designed in from the start. It is a design constraint, not a post-launch remediation task.

- Color alone never conveys meaning. Shape, icon, label, or pattern must also differentiate.
- Tab order must follow the visual reading order. If it does not, the layout is wrong — not the tab order.
- Keyboard navigation is a first-class experience, not an edge case. Every interaction available with a mouse must be available from the keyboard.
- Focus indicators must always be visible. `outline: none` without a replacement is a WCAG failure and a real barrier for keyboard users.
- Touch targets: ≥44×44px on all interactive elements. Smaller targets cause mis-taps and frustration.
- Write meaningful labels for every interactive element. "Click here" and "Learn more" are not labels — they communicate nothing in isolation or when read by a screen reader.
- Test with a screen reader on at least one platform (VoiceOver on macOS/iOS, NVDA on Windows, TalkBack on Android) before shipping.
