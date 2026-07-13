# JavaScript Interaction Performance Design

## Objective

Reduce interaction overhead in the Cold Hielo navigation script without adding abstractions that do not serve the current event model. Preserve all menu, keyboard, focus, responsive, and carousel behavior.

## Findings

The production module is approximately 1.55 kB and contains no scroll, resize, pointer-move, input, or other high-frequency event. Its click and keydown handlers perform constant-time class and attribute updates. Debouncing or throttling these handlers would delay visible feedback and could worsen INP.

The only avoidable repeated work is attaching one click listener to every navigation link. The JavaScript breakpoint also uses 769 px while the CSS desktop enhancement begins at 768 px.

## Design

- Replace per-link click listeners with one delegated click listener on the menu list.
- Detect navigation clicks with `event.target.closest("a")`.
- Keep the menu state setter synchronous so class and ARIA state update within the same interaction frame.
- Change the media query to `(min-width: 768px)` so JavaScript and CSS use one breakpoint.
- Keep the document Escape listener because it is global keyboard behavior.
- Keep the carousel listener unchanged because it is one constant-time click handler.
- Do not add debounce, throttle, async work, timers, requestAnimationFrame, dynamic imports, or new dependencies.

## Performance Rationale

Event delegation reduces listener count and removes the link iteration while preserving immediate response. Avoiding timers keeps INP predictable. The module remains small enough that splitting or lazy-loading it would add request and orchestration overhead without a meaningful LCP benefit.

LCP remains primarily controlled by the existing hero image delivery, `fetchpriority="high"`, image dimensions, CSS, and server response. This JavaScript change must not claim a measurable LCP improvement by itself.

## Validation

- Add a regression test proving only one delegated menu listener is registered.
- Verify a nested click target inside a link still closes the menu through `closest("a")`.
- Verify non-link menu clicks do not close it.
- Preserve click toggle, link close, Escape close and focus return, desktop breakpoint close, carousel pause, and ARIA labels.
- Run the complete `npm test` suite and confirm the production JavaScript bundle does not grow materially.

## Acceptance Criteria

- No `querySelectorAll("a")` iteration remains in production JavaScript.
- Menu links are handled through one delegated listener.
- The responsive media query is exactly `(min-width: 768px)`.
- No debounce or throttle helper is introduced without a high-frequency event consumer.
- Existing interaction and accessibility tests pass.
