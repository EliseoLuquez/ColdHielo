# Premium Ice Barrel Image Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the outdoor barrel photograph with a premium 4:3 studio asset and apply consistent 8 px rounding to content imagery.

**Architecture:** Generate one project-bound raster asset using the existing barrel and logo images as visual references, inspect it, then replace the current catalog file without changing consumers. Extend component CSS through explicit content-image selectors and validate the compiled contract before visual QA.

**Tech Stack:** Built-in Image Gen, JPEG asset, modular CSS, Vite 5, Node and PowerShell tests, Chrome headless QA.

---

### Task 1: Generate And Integrate The Premium Barrel Asset

**Files:**
- Replace: `public/img/catalogo-tachos-hielo-500.jpg`

- [ ] **Step 1: Generate the product photograph**

Use built-in Image Gen with both files as references:

- `public/img/catalogo-tachos-hielo-500.jpg`: subject and product-count reference.
- `public/img/logo-coldhielo-optimizado.png`: branding and label-color reference.

Prompt:

```text
Use case: product-mockup
Asset type: 4:3 equipment catalog photograph for the Cold Hielo rental website
Primary request: Create a premium realistic product photograph of four clean blue industrial 500-liter ice barrels, fully visible and grouped with balanced spacing.
Scene/backdrop: clean light cool-gray warehouse studio, neutral concrete floor, no visible walls clutter or props.
Style/medium: high-end commercial product photography, realistic polyethylene texture and proportions.
Composition/framing: horizontal 4:3, eye-level three-quarter view, all four barrels centered with generous edge padding.
Lighting/mood: soft diffused studio lighting, subtle grounded shadows, crisp but natural.
Color palette: deep blue barrels, cool gray background, restrained yellow/cyan/black Cold Hielo labels.
Branding: place one small consistent circular Cold Hielo label on the front of each barrel, using the supplied logo only as identity reference.
Constraints: four barrels exactly; intact clean barrels; consistent openings and lids; no people; no text overlays; no watermark.
Avoid: trees, gravel, brick, dirt, scratches, damaged barrels, oversized logos, gradients, dramatic reflections, extra containers, ice bags.
```

- [ ] **Step 2: Inspect the generated output**

Open the output at original resolution. Reject it if the count is not four, silhouettes are malformed, branding dominates, lighting is inconsistent, or the environment is cluttered.

- [ ] **Step 3: Save the selected image into the project**

Copy the selected built-in output from `$CODEX_HOME/generated_images/...` to `public/img/catalogo-tachos-hielo-500.jpg`. Resize and crop to 1200 by 900 px only if the generated output is not already 4:3. Preserve natural proportions and do not stretch.

- [ ] **Step 4: Run image delivery checks**

Run:

```powershell
npm run build
node tests/image-delivery-checks.mjs
```

Expected: `Image delivery checks passed for 28 referenced assets.`

- [ ] **Step 5: Commit**

```powershell
git add public/img/catalogo-tachos-hielo-500.jpg
git commit -m "Replace barrel catalog photograph"
```

### Task 2: Round Content Images Consistently

**Files:**
- Modify: `tests/build-accessibility-checks.ps1`
- Modify: `src/styles/components.css`

- [ ] **Step 1: Write failing image-radius tests**

Add to `$cssFeatures`:

```powershell
@{ Pattern = '\.equipment-card img\s*\{[^}]*border-radius\s*:\s*var\(--radius-md\)'; Label = 'rounded equipment imagery' }
@{ Pattern = '\.servicio-item img\s*\{[^}]*border-radius\s*:\s*var\(--radius-md\)'; Label = 'rounded service imagery' }
@{ Pattern = '\.evento-foto img\s*\{[^}]*border-radius\s*:\s*var\(--radius-md\)'; Label = 'rounded event imagery' }
```

- [ ] **Step 2: Run the focused test and verify failure**

Run:

```powershell
npm run build
powershell -NoProfile -ExecutionPolicy Bypass -File tests/build-accessibility-checks.ps1
```

Expected: FAIL for rounded equipment imagery.

- [ ] **Step 3: Implement the image radii**

Add `border-radius: var(--radius-md)` to `.equipment-card img` and `.evento-foto img`; preserve the existing service and ice-type radii. Keep hero, logo, client, social, and floating WhatsApp images unchanged.

- [ ] **Step 4: Run full verification**

Run:

```powershell
npm test
git diff --check
```

Expected: all test groups pass and no whitespace errors are reported.

- [ ] **Step 5: Perform visual QA**

Capture the home page at 1440 by 900 and the reliable 500 by 800 viewport. Scroll to the barrel card and confirm the complete 4:3 image is visible with no stretching or clipping. Confirm rounded content images remain aligned during hover scaling.

- [ ] **Step 6: Commit**

```powershell
git add src/styles/components.css tests/build-accessibility-checks.ps1
git commit -m "Round content imagery consistently"
```
