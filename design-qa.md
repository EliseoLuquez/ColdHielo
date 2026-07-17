# Design QA

- Reference: `C:/Users/lelis/Downloads/ChatGPT Image 17 jul 2026, 00_14_05.png`
- Primary viewport: 390 x 844
- Responsive widths checked: 320 px, 390 px and 428 px
- Desktop regression check: 1440 x 900

## Visual checks

- Mobile Home keeps the fixed yellow header and logo while using the bottom navigation instead of a duplicate hamburger menu.
- Interior pages retain the hamburger menu because they do not include the bottom navigation.
- Hero follows the requested mobile order: copy, touch-friendly actions, then the complete equipment artwork.
- Quick benefits use a centered 2 x 2 grid; compact sections use two columns where space permits.
- Ice types, equipment, process steps and testimonials use native horizontal scrolling with indicators.
- CTA, footer and fixed bottom navigation remain readable without covering content.
- Bottom navigation uses 32 px library icons, including a house for Home, with consistent circular backgrounds.
- Equipment photography is clipped by rounded media wrappers, so the visible image corners are consistently rounded.
- No horizontal overflow at any target width.
- Desktop composition and hidden mobile-only sections remain unchanged.

## Interaction checks

- Hamburger menu remains available on interior pages and opens and closes through `aria-expanded`.
- WhatsApp calls to action retain their production links.
- Scroll carousels update their active indicators.
- Bottom navigation is available only on mobile.

final result: passed
