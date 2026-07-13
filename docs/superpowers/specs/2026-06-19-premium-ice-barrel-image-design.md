# Premium Ice Barrel Image Design

## Objective

Replace the current outdoor ice-barrel catalog photograph with a clean premium studio image and apply consistent subtle rounding to site imagery. Preserve all equipment copy, card structure, links, semantics, and responsive behavior.

## Image Direction

Create a realistic commercial product photograph in a 4:3 horizontal composition:

- Four clean blue industrial ice barrels with approximately 500-liter proportions.
- Barrels grouped with balanced spacing and fully visible silhouettes.
- Light cool-gray industrial studio or clean warehouse background.
- Neutral concrete floor, soft grounded shadows, and diffused professional lighting.
- Small, consistent Cold Hielo circular labels on the front of the barrels.
- Yellow, cyan, black, blue, white, and cool-gray palette aligned with the website.
- No people, text overlays, ice bags, decorative graphics, gradients, dramatic reflections, or clutter.
- No visible damage, dirt, trees, gravel, brick walls, improvised cuts, or mismatched barrel openings.

The supplied barrel photograph establishes the product type and count. The current Cold Hielo logo asset establishes label colors and identity. The reference site informs the clean commercial product treatment but must not be copied.

## Asset Integration

Replace `public/img/catalogo-tachos-hielo-500.jpg` so existing HTML and data references remain unchanged. Export as a 1200 by 900 px JPEG with the product centered for `object-fit: contain` inside the existing 4:3 equipment frame.

## Image Rounding

Use `border-radius: var(--radius-md)` for catalog, service, event, and editorial content images. Do not round the full-width hero image, logo, social icons, WhatsApp icon, or client logos. Parent containers must use `overflow: hidden` only when required to preserve the image edge during hover scaling.

## Validation

- Inspect the generated image at original resolution before integration.
- Confirm four recognizable barrels, clean edges, coherent lighting, and consistent branding.
- Run the existing image-delivery and full test suites.
- Capture desktop and mobile-width local screenshots.
- Confirm the image is not distorted, cropped, blurry, or oversized in the equipment card.
- Confirm rounded images retain focus, hover, and responsive behavior.

## Acceptance Criteria

- The new barrel image reads as a professional catalog photograph at first glance.
- All four products remain visible in the 4:3 card frame.
- Cold Hielo branding is restrained and consistent.
- Relevant content images use an 8 px radius without rounding excluded brand or hero assets.
- No HTML structure or functionality changes.
- Automated tests and visual QA pass.
