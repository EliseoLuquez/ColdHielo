# Cold Hielo Visual Modernization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Modernize all five Cold Hielo pages with a consistent industrial design system, mobile-first responsive CSS, clearer typography, and subtle accessible motion without changing content or behavior.

**Architecture:** Keep the existing Vite and Handlebars structure. Refine the five existing CSS layers by responsibility: tokens define the system, base defines document defaults, layout defines structural composition, components define reusable UI, and responsive contains only progressive enhancements. Extend the existing PowerShell checks before each visual change so the design contract remains testable.

**Tech Stack:** HTML5, Handlebars, modular CSS, vanilla JavaScript, Vite 5, Node tests, PowerShell assertions, GitHub Pages.

---

## File Map

- `src/styles/tokens.css`: color, spacing, typography, radii, shadows, and motion tokens.
- `src/styles/base.css`: mobile-first document typography, headings, links, focus, and global media defaults.
- `src/styles/layout.css`: header, navigation, section containers, grids, and footer structure.
- `src/styles/components.css`: buttons, hero, cards, equipment media, steps, carousel, and interaction states.
- `src/styles/responsive.css`: enhancements at 600, 768, and 1024 px plus reduced-motion behavior.
- `tests/build-accessibility-checks.ps1`: compiled CSS contract, touch-target, focus, motion, and breakpoint tests.
- `tests/static-site-checks.ps1`: generated-page regression checks for preserved content and functionality.

### Task 1: Establish The Design Tokens And Type Scale

**Files:**
- Modify: `tests/build-accessibility-checks.ps1`
- Modify: `src/styles/tokens.css`
- Modify: `src/styles/base.css`

- [ ] **Step 1: Write the failing design-token checks**

Add these entries to `$cssFeatures`:

```powershell
@{ Pattern = '--space-1\s*:\s*0\.25rem'; Label = 'four-pixel spacing scale' }
@{ Pattern = '--font-body\s*:'; Label = 'body font token' }
@{ Pattern = '--motion-fast\s*:\s*160ms'; Label = 'fast motion token' }
@{ Pattern = 'h1\s*\{[^}]*font-size\s*:\s*clamp\('; Label = 'fluid primary heading' }
@{ Pattern = 'body\s*\{[^}]*font-size\s*:\s*1rem[^}]*line-height\s*:\s*1\.6'; Label = 'readable body typography' }
```

- [ ] **Step 2: Run the focused test and verify it fails**

Run:

```powershell
npm run build
powershell -NoProfile -ExecutionPolicy Bypass -File tests/build-accessibility-checks.ps1
```

Expected: FAIL reporting the first missing token.

- [ ] **Step 3: Implement the token system**

Replace the token declarations with a complete system while retaining the existing brand colors:

```css
:root {
  --primary: #fcce3d;
  --primary-strong: #e6b900;
  --accent: #008ca3;
  --accent-dark: #075f70;
  --dark: #111820;
  --text: #26323c;
  --text-muted: #5b6872;
  --white: #fff;
  --site-background: #f4f7f8;
  --surface-muted: #eaf0f2;
  --hero-background: #edf4f6;
  --border: #d6e0e3;
  --font-body: "Segoe UI", Inter, system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
  --space-1: 0.25rem;
  --space-2: 0.5rem;
  --space-3: 0.75rem;
  --space-4: 1rem;
  --space-6: 1.5rem;
  --space-8: 2rem;
  --space-12: 3rem;
  --space-16: 4rem;
  --space-20: 5rem;
  --radius-sm: 4px;
  --radius-md: 8px;
  --shadow-soft: 0 8px 24px rgb(17 24 32 / 8%);
  --shadow-medium: 0 14px 36px rgb(17 24 32 / 16%);
  --motion-fast: 160ms;
  --motion-base: 220ms;
}
```

Update base typography with `font-family: var(--font-body)`, `font-size: 1rem`, `line-height: 1.6`, muted paragraph color, and fluid `h1`/`h2` sizes using `clamp()`.

- [ ] **Step 4: Run the focused test and verify it passes**

Run the commands from Step 2.

Expected: `Build accessibility checks passed.`

- [ ] **Step 5: Commit**

```powershell
git add src/styles/tokens.css src/styles/base.css tests/build-accessibility-checks.ps1
git commit -m "Refine visual design tokens"
```

### Task 2: Rebuild The Structural CSS Mobile First

**Files:**
- Modify: `tests/build-accessibility-checks.ps1`
- Modify: `src/styles/layout.css`
- Modify: `src/styles/responsive.css`

- [ ] **Step 1: Write failing mobile-first layout checks**

Add these CSS contract entries:

```powershell
@{ Pattern = '\.inner\s*\{[^}]*width\s*:\s*min\(100%'; Label = 'fluid content container' }
@{ Pattern = 'header\s*\{[^}]*min-height\s*:\s*72px'; Label = 'stable mobile header' }
@{ Pattern = '@media\s*\(min-width\s*:\s*600px\)'; Label = 'small tablet enhancement' }
@{ Pattern = '@media\s*\(min-width\s*:\s*768px\)'; Label = 'desktop navigation enhancement' }
@{ Pattern = '@media\s*\(min-width\s*:\s*1024px\)'; Label = 'wide layout enhancement' }
```

Remove the old assertion that treats `max-width: 768px` as the primary mobile breakpoint.

- [ ] **Step 2: Run the focused test and verify it fails**

Run:

```powershell
npm run build
powershell -NoProfile -ExecutionPolicy Bypass -File tests/build-accessibility-checks.ps1
```

Expected: FAIL for the missing fluid container or `min-width` breakpoint.

- [ ] **Step 3: Implement base mobile structure**

Make `.inner` fluid, set mobile section padding to `var(--space-12) var(--space-4)`, keep the menu toggle visible by default, stack footer regions, and use single-column grids by default. Move desktop navigation and multi-column layout declarations into `min-width` media queries.

Use this responsive skeleton:

```css
@media (min-width: 600px) {
  .inner { padding-inline: var(--space-6); }
  .eventos-galeria { grid-template-columns: repeat(2, minmax(0, 1fr)); }
}

@media (min-width: 768px) {
  .menu-toggle { display: none; }
  .main-nav ul { position: static; display: flex; }
  .footer-content-grid { flex-direction: row; }
}

@media (min-width: 1024px) {
  .inner { padding-block: var(--space-20); }
  .eventos-galeria { grid-template-columns: repeat(3, minmax(0, 1fr)); }
}
```

- [ ] **Step 4: Run the focused test and verify it passes**

Run the commands from Step 2.

Expected: `Build accessibility checks passed.`

- [ ] **Step 5: Commit**

```powershell
git add src/styles/layout.css src/styles/responsive.css tests/build-accessibility-checks.ps1
git commit -m "Make site layout mobile first"
```

### Task 3: Modernize Controls, Hero, And Repeated Cards

**Files:**
- Modify: `tests/build-accessibility-checks.ps1`
- Modify: `src/styles/components.css`

- [ ] **Step 1: Write failing component checks**

Add these entries:

```powershell
@{ Pattern = '\.btn\s*\{[^}]*min-height\s*:\s*44px'; Label = 'accessible button target' }
@{ Pattern = '\.btn\s*\{[^}]*transition\s*:[^}]*var\(--motion-fast\)'; Label = 'button microinteraction' }
@{ Pattern = '\.equipment-card\s*\{[^}]*border-radius\s*:\s*var\(--radius-md\)'; Label = 'consistent equipment radius' }
@{ Pattern = '\.equipment-card img\s*\{[^}]*aspect-ratio\s*:'; Label = 'stable equipment media' }
@{ Pattern = '\.banner-nosotros-texto\s*\{[^}]*max-width\s*:'; Label = 'readable hero measure' }
```

- [ ] **Step 2: Run the focused test and verify it fails**

Run:

```powershell
npm run build
powershell -NoProfile -ExecutionPolicy Bypass -File tests/build-accessibility-checks.ps1
```

Expected: FAIL for the first missing component contract.

- [ ] **Step 3: Implement the component system**

Unify buttons around a 44 px minimum target, 8 px maximum radius, strong text contrast, and small hover/focus movement. Give equipment images a shared aspect ratio and `object-fit: contain` so the full equipment remains inspectable. Use borders and restrained shadows rather than heavy floating cards. Constrain hero copy and preserve its existing image and CTA content.

Core interaction pattern:

```css
.btn {
  min-height: 44px;
  padding: var(--space-3) var(--space-6);
  border-radius: var(--radius-md);
  transition: transform var(--motion-fast) ease,
              box-shadow var(--motion-fast) ease,
              background-color var(--motion-fast) ease;
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-soft);
}

.equipment-card img {
  width: 100%;
  aspect-ratio: 4 / 3;
  object-fit: contain;
}
```

- [ ] **Step 4: Run the focused test and verify it passes**

Run the commands from Step 2.

Expected: `Build accessibility checks passed.`

- [ ] **Step 5: Commit**

```powershell
git add src/styles/components.css tests/build-accessibility-checks.ps1
git commit -m "Modernize shared interface components"
```

### Task 4: Preserve Motion Accessibility And Site Behavior

**Files:**
- Modify: `tests/build-accessibility-checks.ps1`
- Modify: `tests/static-site-checks.ps1`
- Modify: `src/styles/responsive.css`

- [ ] **Step 1: Add failing regression checks**

Add generated-page assertions for every page:

```powershell
foreach ($pageName in $pages) {
  $pageHtml = Read-Page $pageName
  Assert-Contains $pageHtml 'class="btn' "$pageName styled actions"
  Assert-NotMatches $pageHtml 'style\s*=' "$pageName inline style regression"
}
```

Add a compiled CSS check:

```powershell
@{ Pattern = '@media\s*\(prefers-reduced-motion\s*:\s*reduce\)[\s\S]*?transition-duration\s*:\s*0\.01ms'; Label = 'reduced transition motion' }
```

- [ ] **Step 2: Run the test suite and verify the new contract fails**

Run: `npm test`

Expected: FAIL for the reduced transition motion rule.

- [ ] **Step 3: Implement the reduced-motion override**

Use:

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    scroll-behavior: auto !important;
    transition-duration: 0.01ms !important;
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
  }

  .slide-track {
    animation: none;
    transform: none;
  }
}
```

- [ ] **Step 4: Run the full suite and verify it passes**

Run: `npm test`

Expected: build succeeds and all six check groups pass.

- [ ] **Step 5: Commit**

```powershell
git add src/styles/responsive.css tests/build-accessibility-checks.ps1 tests/static-site-checks.ps1
git commit -m "Protect responsive motion accessibility"
```

### Task 5: Browser QA And Final Visual Corrections

**Files:**
- Modify: `src/styles/tokens.css`
- Modify: `src/styles/base.css`
- Modify: `src/styles/layout.css`
- Modify: `src/styles/components.css`
- Modify: `src/styles/responsive.css`

- [ ] **Step 1: Start the feature branch locally**

Run:

```powershell
npm run dev -- --host 127.0.0.1 --port 5173
```

Expected: Vite serves `http://127.0.0.1:5173/`.

- [ ] **Step 2: Verify desktop rendering**

At 1440 by 900, verify page identity, meaningful content, no framework overlay, no console warnings/errors, no horizontal overflow, stable hero composition, consistent card alignment, and visible next-section content. Exercise the carousel pause control and confirm `aria-pressed` matches the animation state.

- [ ] **Step 3: Verify mobile rendering**

At 360 by 800, verify the logo and menu fit, primary CTA is visible, touch targets are at least 44 px, equipment cards stay within the viewport, images retain their ratio, and text does not overlap. Open and close the menu with click and Escape.

- [ ] **Step 4: Check all five routes**

Open `/`, `/servicios.html`, `/productos.html`, `/nosotros.html`, and `/contacto.html`. Confirm preserved titles, CTAs, navigation destinations, WhatsApp URLs, images, and footer content.

- [ ] **Step 5: Apply and verify any visual corrections**

For each discovered issue, add or adjust the smallest shared CSS rule, reload the same viewport, and repeat the failing interaction. Do not add page-specific overrides unless the page structure genuinely differs.

- [ ] **Step 6: Run final verification**

Run:

```powershell
npm test
git diff --check
git status --short
```

Expected: all tests pass, no whitespace errors, and only intentional source changes remain.

- [ ] **Step 7: Commit final QA corrections**

```powershell
git add src/styles tests
git commit -m "Polish responsive visual system"
```
