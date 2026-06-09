# Cold Hielo Alquileres Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorient the Cold Hielo website to generate more WhatsApp inquiries for freezer and refrigerator rentals while preserving ice sales as a secondary service.

**Architecture:** Keep the current static HTML/CSS structure compatible with GitHub Pages. Modify page content directly in the existing HTML files, centralize visual improvements in `css/style.css`, and verify behavior through static inspection plus browser checks.

**Tech Stack:** HTML5, CSS3, Bootstrap 5 CDN, plain JavaScript for the mobile menu, GitHub Pages.

---

## File Structure

- Modify `index.html`: make rentals the home page priority, add equipment highlights, process, ice complement, and rental-focused WhatsApp CTAs.
- Modify `servicios.html`: keep it as the dedicated rentals page, improve WhatsApp messages per equipment and align copy with the new home.
- Modify `productos.html`: keep it focused on ice sales and change WhatsApp links to an ice-specific message.
- Modify `contacto.html`: correct Instagram URL and make contact CTAs support rental inquiries.
- Modify `nosotros.html`: preserve trust content and align CTA text with rentals.
- Modify `css/style.css`: add polished shared section/card/button styles, compact header/mobile styles, equipment cards, and responsive fixes.
- No new runtime dependencies.

---

### Task 1: Add Conversion URLs and Rental-First Home Content

**Files:**
- Modify: `index.html`
- Verify: browser/DOM inspection of `index.html`

- [ ] **Step 1: Replace the home meta title and description**

Set:

```html
<title>Alquiler de Freezers y Heladeras | Cold Hielo Ramos Mejia</title>
<meta name="description"
  content="Alquiler de freezers y heladeras por dia, semana o mes en Ramos Mejia y Zona Oeste. Tambien venta de hielo en cubos, picado y barra.">
```

- [ ] **Step 2: Define rental-focused WhatsApp links inline where used**

Use encoded links like:

```html
https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20alquiler%20de%20freezer%20o%20heladera.
```

For ice links use:

```html
https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20compra%20de%20hielo.
```

- [ ] **Step 3: Rewrite the hero**

Use this hero message:

```html
<h1 class="display-5 fw-bold">Alquiler de Freezers y Heladeras en Ramos Mejia</h1>
<p class="lead mb-3">
  Equipos para eventos, comercios, ferias y necesidades temporales. Tambien venta de hielo en cubos, picado y barra.
</p>
```

Primary CTA text: `Consultar alquiler`.
Secondary CTA text: `Ver equipos`.

- [ ] **Step 4: Reorder home sections**

Home order must be:

1. Hero
2. Rental benefits
3. Featured rental equipment
4. Ideal-for use cases
5. How it works
6. Ice complement
7. Trust/events
8. Final CTA
9. Footer

- [ ] **Step 5: Run static checks**

Run:

```powershell
rg "Consultar alquiler|Equipos destacados|Como funciona|Venta de hielo" index.html
```

Expected: all phrases appear.

---

### Task 2: Improve Dedicated Service and Product CTAs

**Files:**
- Modify: `servicios.html`
- Modify: `productos.html`
- Verify: static link inspection

- [ ] **Step 1: Update rental CTAs in `servicios.html`**

Use equipment-specific WhatsApp messages:

```html
Freezer horizontal: https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20el%20alquiler%20de%20un%20freezer%20horizontal.
Freezer vertical: https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20el%20alquiler%20de%20un%20freezer%20vertical.
Heladera comun: https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20el%20alquiler%20de%20una%20heladera%20comun.
Heladera exhibidora: https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20el%20alquiler%20de%20una%20heladera%20exhibidora.
Frigobar: https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20el%20alquiler%20de%20un%20frigobar.
```

- [ ] **Step 2: Update generic rental CTAs**

Use:

```html
https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20alquiler%20de%20freezer%20o%20heladera.
```

- [ ] **Step 3: Update ice CTAs in `productos.html`**

Use:

```html
https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20compra%20de%20hielo.
```

- [ ] **Step 4: Run static checks**

Run:

```powershell
rg "text=Hola%2C%20quiero%20consultar" servicios.html productos.html
```

Expected: rental messages appear in `servicios.html`; ice messages appear in `productos.html`.

---

### Task 3: Fix Contact and Trust Details

**Files:**
- Modify: `contacto.html`
- Modify: `nosotros.html`
- Verify: static link inspection

- [ ] **Step 1: Correct Instagram URL in `contacto.html`**

Replace:

```html
https://www.instagram.com/colddhielo
```

With:

```html
https://www.instagram.com/coldhielo
```

- [ ] **Step 2: Update contact CTA links**

Use the generic rental inquiry URL for primary contact buttons:

```html
https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20alquiler%20de%20freezer%20o%20heladera.
```

- [ ] **Step 3: Align Nosotros CTA**

Change the final CTA copy to emphasize rental and ice support:

```html
Si necesitas alquilar un equipo de frio o comprar hielo para tu evento o comercio, escribinos y te orientamos con la mejor opcion.
```

- [ ] **Step 4: Run static checks**

Run:

```powershell
rg "colddhielo|coldhielo|alquiler%20de%20freezer" contacto.html nosotros.html
```

Expected: no `colddhielo`; `coldhielo` and rental query links are present.

---

### Task 4: Polish Shared Visual System

**Files:**
- Modify: `css/style.css`
- Verify: browser visual inspection

- [ ] **Step 1: Add shared section utilities**

Add CSS classes:

```css
.section-kicker {
  color: #087c8f;
  font-weight: 700;
  letter-spacing: 0;
  text-transform: uppercase;
  font-size: 0.86rem;
  margin-bottom: 0.35rem;
}

.section-intro {
  max-width: 820px;
  margin: 0 auto 2rem;
  text-align: center;
}
```

- [ ] **Step 2: Add professional card styles**

Add CSS classes:

```css
.feature-card,
.equipment-card,
.process-card,
.trust-card {
  background: #fff;
  border: 1px solid rgba(0, 188, 212, 0.14);
  border-radius: 12px;
  box-shadow: var(--shadow-soft);
  padding: 1.4rem;
  height: 100%;
}

.equipment-card img {
  width: 100%;
  height: 170px;
  object-fit: contain;
  margin-bottom: 1rem;
}
```

- [ ] **Step 3: Compact mobile header**

Adjust mobile rules so the logo is smaller and header does not consume excessive height:

```css
@media (max-width: 768px) {
  .logo-header img {
    max-width: 150px !important;
  }

  header .pt-4 {
    padding-top: 0 !important;
  }
}
```

- [ ] **Step 4: Run CSS static checks**

Run:

```powershell
rg "equipment-card|section-kicker|logo-header" css/style.css
```

Expected: all classes appear.

---

### Task 5: Browser QA

**Files:**
- Verify: `index.html`, `servicios.html`, `productos.html`, `contacto.html`, `nosotros.html`

- [ ] **Step 1: Open the local or published home page**

For local file inspection, open:

```text
file:///C:/Users/lelis/Documents/Cold-Hielo/ColdHielo/index.html
```

- [ ] **Step 2: Verify desktop**

Check:

- Hero reads as rental-first.
- Primary CTA is visible in the first viewport.
- Equipment cards are visible before the ice complement.
- Header is aligned.
- No horizontal overflow.

- [ ] **Step 3: Verify mobile**

Use viewport `390x844`.

Check:

- Logo/header is compact.
- Menu toggle is visible.
- Hero text and buttons fit.
- No horizontal overflow.
- Floating WhatsApp button does not cover important content.

- [ ] **Step 4: Verify links**

Run:

```powershell
rg "wa.me/541133002956\\?text=|instagram.com/coldhielo" *.html
```

Expected: encoded WhatsApp links and corrected Instagram links are present.

- [ ] **Step 5: Commit implementation**

Run:

```powershell
git add index.html servicios.html productos.html contacto.html nosotros.html css/style.css docs/superpowers/plans/2026-06-09-cold-hielo-alquileres-implementation.md
git commit -m "Refocus site on equipment rentals"
```
