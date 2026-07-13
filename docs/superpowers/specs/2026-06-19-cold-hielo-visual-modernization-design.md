# Cold Hielo Visual Modernization

## Objective

Modernize the existing Cold Hielo website with an industrial, professional visual language that improves rental conversion, readability, responsive behavior, and perceived reliability. Preserve the current content, routes, WhatsApp links, navigation behavior, accessibility features, and static Vite architecture.

## Visual Direction

The interface will retain the recognizable Cold Hielo palette while assigning each color a clearer role:

- Yellow: brand surfaces and primary emphasis.
- Cyan: links, section accents, and selected states.
- Near-black: headings, controls, and strong contrast.
- White and cool gray: page backgrounds and content separation.

The result should feel like a dependable refrigeration and event-supply business, not a generic marketing template. Sections will use open layouts and full-width bands instead of placing every block inside a card.

## Design System

### Spacing

Use a proportional spacing scale based on 4 px: 4, 8, 12, 16, 24, 32, 48, 64, and 80 px. Mobile sections begin at 48 px vertical spacing and expand progressively at wider breakpoints. Repeated components share the same internal padding and grid gaps.

### Typography

Use a modern system sans-serif stack with deliberate weights and line heights. Body copy remains at least 16 px. Headings use a fluid scale through `clamp()` without tying font size directly to viewport width. Paragraph width is constrained for comfortable reading. Letter spacing remains zero.

### Components

- Buttons share height, padding, weight, radius, focus treatment, and motion.
- Navigation uses a compact mobile header and a calm desktop layout.
- Equipment cards preserve the existing data and imagery with consistent media ratios and content alignment.
- Icon-supported steps and use cases keep a consistent icon size and optical weight.
- Cards use a maximum 8 px radius and are reserved for repeated equipment or service items.

### Motion

Use subtle 160-220 ms transitions for color, border, shadow, and small transforms. Hover movement is limited to a few pixels. Keyboard focus remains clearly visible. All nonessential animation is disabled under `prefers-reduced-motion`.

## Responsive Model

CSS will be mobile-first. Base styles target a 320 px minimum viewport with a single-column reading order, stable media ratios, 44 px touch targets, and no horizontal overflow. Layouts progressively enhance at 600, 768, and 1024 px using flexible grids rather than fixed widths.

The first mobile viewport must show the brand, primary rental message, and consultation action without crowding. Desktop layouts may introduce columns, larger imagery, and broader spacing while preserving the same content order.

## Page Structure

### Header

Keep the logo, current navigation destinations, and accessible menu behavior. Reduce visual bulk, align navigation spacing, and give the primary contact path clearer emphasis without adding new functionality.

### Hero

Preserve the rental-focused headline, supporting copy, and calls to action. Improve contrast, line length, responsive spacing, and image treatment. The hero remains the first-viewport conversion surface and leaves a visible hint of the following section.

### Rental Benefits And Equipment

Use stronger hierarchy and quieter supporting text. Equipment media receives consistent aspect ratios and cropping. Capacity, availability, and CTA information remain intact and easier to scan.

### Use Cases, Process, And Trust

Use open bands, restrained icon treatment, and consistent alignment. Avoid nested cards and excessive decoration. Preserve the existing business proof and service-area explanation.

### Client Logos And Footer

Keep the accessible carousel pause control and current logos. Improve spacing and visual balance without increasing motion. Simplify footer hierarchy while retaining all contact and social information.

## Accessibility

- Preserve semantic landmarks, heading order, skip link, alt text, and accessible menu state.
- Maintain WCAG AA text contrast and at least 3:1 contrast for interactive graphics.
- Keep touch targets at least 44 by 44 px.
- Ensure hover states also have keyboard focus equivalents where applicable.
- Avoid conveying meaning through color alone.

## Technical Scope

Primary changes belong in `src/styles/tokens.css`, `base.css`, `layout.css`, `components.css`, and `responsive.css`. HTML or JavaScript changes are allowed only where needed for semantic styling hooks or accessible interaction states. No backend, routing, content-data, WhatsApp-query, or deployment behavior will change.

## Validation

- Run the complete `npm test` suite.
- Verify the home page and shared navigation in the local browser.
- Check desktop and mobile viewports for overflow, overlap, image cropping, readable type, and stable controls.
- Exercise the mobile menu and carousel pause control.
- Inspect browser console warnings and errors.
- Compare the new render against the current page for preserved copy, routes, CTAs, section order, and functionality.

## Acceptance Criteria

- The visual system is consistent across all five pages.
- The mobile layout is the base implementation, not a desktop layout compressed by overrides.
- Existing functionality and conversion links behave exactly as before.
- No horizontal overflow or incoherent overlap appears at tested widths.
- Typography, spacing, controls, media treatment, and motion feel coherent and production-ready.
- Automated tests and browser validation pass.
