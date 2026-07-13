# Premium CSS And Scroll Motion Design

## Objective

Polish the existing Cold Hielo landing page into a modern, premium, minimal interface using only the current modular CSS system. Preserve HTML structure, semantics, content, navigation, WhatsApp links, JavaScript behavior, and page routes.

## Visual System

- Keep the current yellow, cyan, near-black, white, and cool-gray brand palette.
- Use white and cool-gray open sections instead of decorative containers around every block.
- Keep repeated cards at an 8 px radius, a 1 px neutral border, and restrained elevation.
- Use the existing 4 px spacing scale and fluid typography tokens.
- Keep body text contrast at WCAG AA and interactive graphics at least 3:1.
- Avoid gradients, thick borders, oversized shadows, decorative blobs, nested cards, and generic glass effects.

## Interaction Motion

Buttons, cards, and linked media use a shared `220ms cubic-bezier(0.4, 0, 0.2, 1)` transition. Hover-capable pointers receive a maximum `translateY(-2px)` lift and a controlled shadow change. Focus-visible states remain distinct and must not depend on hover.

## Scroll Entry Motion

Use CSS view timelines only when supported:

```css
@supports (animation-timeline: view()) {
  /* selected content groups animate from opacity and translateY */
}
```

Apply entry motion to section headings, introductions, repeated cards, process items, trust content, and CTA blocks. Do not animate the header, first hero headline, primary hero CTA, floating WhatsApp control, or elements whose movement could delay first-viewport comprehension.

The entry animation lasts 360 ms with `cubic-bezier(0.4, 0, 0.2, 1)`, moves no more than 18 px, and uses `animation-range: entry 10% cover 28%`. Unsupported browsers render the final state immediately.

## Accessibility

Under `prefers-reduced-motion: reduce`, all transition and animation durations remain effectively disabled and the carousel stays static. Content must never start hidden outside a guarded `@supports` block. Keyboard focus must remain visible throughout animation states.

## Responsive Behavior

Base styles remain mobile-first from 320 px. Hover motion is wrapped in `@media (hover: hover) and (pointer: fine)` so touch devices do not receive sticky hover states. Existing progressive breakpoints at 600, 768, and 1024 px remain unchanged.

## Technical Scope

Primary changes belong in:

- `src/styles/tokens.css`: shared easing and motion-duration tokens.
- `src/styles/components.css`: refined surfaces and pointer-hover interactions.
- `src/styles/responsive.css`: scroll-linked animation support, reduced-motion behavior, and hover capability query.
- `tests/build-accessibility-checks.ps1`: compiled CSS contracts for easing, guarded view timelines, motion range, hover capability, and reduced motion.

No HTML, data, JavaScript, backend, or dependency changes are required.

## Validation

- Verify the new CSS contracts fail before implementation and pass afterward.
- Run `npm test` and `git diff --check`.
- Capture desktop and mobile-width screenshots from the local server.
- Confirm no horizontal overflow, clipped text, delayed first hero content, or hidden content in unsupported browsers.
- Confirm reduced-motion users receive no scroll-entry movement.

## Acceptance Criteria

- Premium polish is achieved without gradients, heavy shadows, thick borders, or excessive card framing.
- Hover lift never exceeds 2 px and only runs on hover-capable fine pointers.
- Scroll entry motion uses guarded `animation-timeline: view()` with a 360 ms custom easing.
- First-viewport conversion content remains immediately visible.
- Existing functionality, semantics, and responsive structure remain unchanged.
- Automated tests and visual QA pass.
