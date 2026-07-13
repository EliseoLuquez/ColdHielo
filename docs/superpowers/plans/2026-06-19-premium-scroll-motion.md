# Premium CSS And Scroll Motion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add restrained premium hover polish and progressive CSS scroll-entry motion without changing HTML, JavaScript, content, or responsive structure.

**Architecture:** Extend the existing token, component, and responsive CSS layers. Every new animation is guarded by capability or input-mode media queries, and the existing reduced-motion block remains the final authority. PowerShell tests validate the compiled production CSS.

**Tech Stack:** Modular CSS, Vite 5, PowerShell CSS contract tests, Chrome headless visual QA.

---

### Task 1: Add Shared Premium Motion Tokens

**Files:**
- Modify: `tests/build-accessibility-checks.ps1`
- Modify: `src/styles/tokens.css`

- [ ] **Step 1: Write failing token tests**

Add to `$tokenFeatures`:

```powershell
@{ Pattern = '--ease-premium\s*:\s*cubic-bezier\(0\.4,\s*0,\s*0\.2,\s*1\)'; Label = 'premium easing token' }
@{ Pattern = '--motion-entry\s*:\s*360ms'; Label = 'scroll entry duration token' }
```

- [ ] **Step 2: Run the focused test and verify failure**

Run:

```powershell
npm run build
powershell -NoProfile -ExecutionPolicy Bypass -File tests/build-accessibility-checks.ps1
```

Expected: FAIL with `Source tokens are missing premium easing token`.

- [ ] **Step 3: Implement the tokens**

Add to `:root`:

```css
--ease-premium: cubic-bezier(0.4, 0, 0.2, 1);
--motion-entry: 360ms;
```

- [ ] **Step 4: Run the focused test and verify success**

Run the commands from Step 2.

Expected: `Build accessibility checks passed.`

- [ ] **Step 5: Commit**

```powershell
git add src/styles/tokens.css tests/build-accessibility-checks.ps1
git commit -m "Add premium motion tokens"
```

### Task 2: Refine Hover-Capable Interactions

**Files:**
- Modify: `tests/build-accessibility-checks.ps1`
- Modify: `src/styles/components.css`
- Modify: `src/styles/responsive.css`

- [ ] **Step 1: Write failing hover contract tests**

Add to `$cssFeatures`:

```powershell
@{ Pattern = '@media\s*\(hover\s*:\s*hover\)\s*and\s*\(pointer\s*:\s*fine\)'; Label = 'hover-capable interaction query' }
@{ Pattern = '@media\s*\(hover\s*:\s*hover\)[\s\S]*?translateY\(-2px\)'; Label = 'two-pixel premium lift' }
@{ Pattern = '\.btn\s*\{[^}]*var\(--ease-premium\)'; Label = 'premium button easing' }
```

- [ ] **Step 2: Run the focused test and verify failure**

Run the two commands from Task 1 Step 2.

Expected: FAIL for the missing hover-capable query.

- [ ] **Step 3: Implement shared interaction motion**

Update component transitions to use `var(--ease-premium)` and move hover transforms out of unguarded rules. Add to `responsive.css`:

```css
@media (hover: hover) and (pointer: fine) {
  .btn:hover,
  .feature-card:hover,
  .equipment-card:hover,
  .process-card:hover,
  .servicio-beneficio-card:hover,
  .producto-beneficio-card:hover,
  .tipo-card:hover,
  .equipo-item:hover,
  .servicio-item:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-medium);
  }

  .equipment-card:hover img,
  .servicio-item:hover img {
    transform: scale(1.015);
  }
}
```

Give card images a `transform var(--motion-base) var(--ease-premium)` transition. Keep borders at 1 px and radii at 8 px.

- [ ] **Step 4: Run the focused test and verify success**

Run the two commands from Task 1 Step 2.

Expected: `Build accessibility checks passed.`

- [ ] **Step 5: Commit**

```powershell
git add src/styles/components.css src/styles/responsive.css tests/build-accessibility-checks.ps1
git commit -m "Refine premium hover interactions"
```

### Task 3: Add Progressive Scroll Entry Motion

**Files:**
- Modify: `tests/build-accessibility-checks.ps1`
- Modify: `src/styles/responsive.css`

- [ ] **Step 1: Write failing scroll-motion tests**

Add to `$cssFeatures`:

```powershell
@{ Pattern = '@supports\s*\(animation-timeline\s*:\s*view\(\)\)'; Label = 'guarded view timeline support' }
@{ Pattern = 'animation-timeline\s*:\s*view\(\)'; Label = 'view timeline animation' }
@{ Pattern = 'animation-range\s*:\s*entry\s+10%\s+cover\s+28%'; Label = 'restrained entry range' }
@{ Pattern = '@keyframes\s+section-entry[\s\S]*?translateY\(18px\)'; Label = 'restrained entry distance' }
```

- [ ] **Step 2: Run the focused test and verify failure**

Run the two commands from Task 1 Step 2.

Expected: FAIL for guarded view timeline support.

- [ ] **Step 3: Implement guarded scroll motion**

Add before the reduced-motion block:

```css
@supports (animation-timeline: view()) {
  .section-kicker,
  .section-intro,
  .feature-card,
  .equipment-card,
  .process-card,
  .trust-card,
  .servicio-beneficio-card,
  .producto-beneficio-card,
  .tipo-card,
  #cta-principal,
  #cta-servicios-final,
  #cta-productos-final,
  #cta-contacto-final,
  #cta-nosotros-final {
    animation-name: section-entry;
    animation-duration: var(--motion-entry);
    animation-timing-function: var(--ease-premium);
    animation-fill-mode: both;
    animation-timeline: view();
    animation-range: entry 10% cover 28%;
  }
}

@keyframes section-entry {
  from {
    opacity: 0;
    transform: translateY(18px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

Do not include header, hero text, hero buttons, WhatsApp control, or carousel logos.

- [ ] **Step 4: Run full verification**

Run:

```powershell
npm test
git diff --check
```

Expected: all test groups pass and no whitespace errors are reported.

- [ ] **Step 5: Perform visual QA**

Capture `http://127.0.0.1:5173/` at 1440 by 900 and the reliable 500 by 800 Chrome headless viewport. Confirm first-viewport content is immediately visible, cards remain readable, no overflow occurs, and reduced-motion rules remain present in compiled CSS.

- [ ] **Step 6: Commit**

```powershell
git add src/styles/responsive.css tests/build-accessibility-checks.ps1
git commit -m "Add progressive scroll entry motion"
```
