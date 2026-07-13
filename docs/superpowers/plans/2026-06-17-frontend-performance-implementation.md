# Cold Hielo Frontend Performance Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convertir Cold Hielo en un sitio estatico multipagina generado con Vite y Handlebars, con menos duplicacion, imagenes mas livianas, HTML accesible y una experiencia movil estable.

**Architecture:** Vite compila cinco plantillas HTML ubicadas en la raiz. Un plugin local basado en Handlebars registra parciales desde `src/partials` y combina datos compartidos con metadatos por pagina. El resultado sigue siendo HTML estatico y se publica desde `dist/` mediante GitHub Actions.

**Tech Stack:** Vite 5, Handlebars, HTML5, CSS, JavaScript ES modules, PowerShell static checks, Python/Pillow para optimizacion unica de imagenes, GitHub Actions y GitHub Pages.

---

## File map

- `package.json`: scripts y dependencias del build.
- `vite.config.mjs`: entradas multipagina y transformacion Handlebars.
- `src/data/site.mjs`: navegacion, contacto, enlaces y catalogo compartido.
- `src/partials/layout.hbs`: documento HTML comun y bloque de contenido.
- `src/partials/head.hbs`: metadatos, CSS y preloads.
- `src/partials/header.hbs`: logo, boton de menu y navegacion.
- `src/partials/footer.hbs`: contacto, redes y copyright.
- `src/partials/whatsapp.hbs`: acceso flotante accesible.
- `src/partials/equipment-card.hbs`: tarjeta reutilizable de equipo.
- `src/scripts/main.js`: menu movil y comportamiento comun.
- `src/styles/main.css`: entrada de estilos.
- `src/styles/tokens.css`: variables visuales.
- `src/styles/base.css`: reset, tipografia, foco y elementos globales.
- `src/styles/layout.css`: contenedores, header, footer y grillas.
- `src/styles/components.css`: heroes, tarjetas, CTA, galeria y WhatsApp.
- `src/styles/responsive.css`: adaptaciones para tablet y movil.
- `index.html`, `servicios.html`, `productos.html`, `nosotros.html`, `contacto.html`: contenido especifico de cada pagina dentro del layout.
- `public/img/`: imagenes originales y variantes WebP usadas por las plantillas.
- `tests/static-site-checks.ps1`: validacion del contenido compilado.
- `tests/build-accessibility-checks.ps1`: landmarks, imagenes, enlaces externos y menu.
- `.github/workflows/deploy-pages.yml`: build y publicacion de `dist/`.

### Task 1: Establish the Vite build baseline

**Files:**
- Create: `package.json`
- Create: `vite.config.mjs`
- Modify: `.gitignore`
- Modify: `tests/static-site-checks.ps1`

- [ ] **Step 1: Write a failing build-output check**

Change the page reader in `tests/static-site-checks.ps1` so it accepts a root and fails while `dist/` does not exist:

```powershell
$siteRoot = if ($env:SITE_ROOT) { $env:SITE_ROOT } else { "dist" }

function Read-Page($path) {
  $fullPath = Join-Path $siteRoot $path
  if (-not (Test-Path $fullPath)) {
    throw "Missing built page: $fullPath"
  }
  Get-Content -Raw -Encoding UTF8 $fullPath
}
```

Run: `Remove-Item Env:SITE_ROOT -ErrorAction SilentlyContinue; powershell -ExecutionPolicy Bypass -File tests/static-site-checks.ps1`

Expected: FAIL with `Missing built page: dist\index.html`.

- [ ] **Step 2: Add the package manifest**

Create `package.json`:

```json
{
  "name": "cold-hielo",
  "private": true,
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "test": "npm run build && powershell -ExecutionPolicy Bypass -File tests/static-site-checks.ps1 && powershell -ExecutionPolicy Bypass -File tests/build-accessibility-checks.ps1"
  },
  "devDependencies": {
    "handlebars": "^4.7.8",
    "vite": "^5.4.0"
  }
}
```

Run: `npm install`

Expected: `package-lock.json` is created and installation exits with code 0.

- [ ] **Step 3: Add the initial multipage configuration**

Create `vite.config.mjs` with the five existing pages as build inputs and relative production paths:

```js
import { resolve } from 'node:path';
import { defineConfig } from 'vite';

const pages = ['index', 'servicios', 'productos', 'nosotros', 'contacto'];

export default defineConfig({
  base: './',
  build: {
    rollupOptions: {
      input: Object.fromEntries(
        pages.map((page) => [page, resolve(process.cwd(), `${page}.html`)])
      )
    }
  }
});
```

Add to `.gitignore`:

```text
node_modules/
dist/
```

- [ ] **Step 4: Build and verify the baseline passes**

Run: `npm run build`

Expected: Vite creates five HTML files in `dist/`.

Run: `powershell -ExecutionPolicy Bypass -File tests/static-site-checks.ps1`

Expected: PASS against `dist/`.

- [ ] **Step 5: Commit the build baseline**

```bash
git add package.json package-lock.json vite.config.mjs .gitignore tests/static-site-checks.ps1
git commit -m "Add Vite multipage build"
```

### Task 2: Add shared Handlebars data and document partials

**Files:**
- Create: `src/data/site.mjs`
- Create: `src/partials/layout.hbs`
- Create: `src/partials/head.hbs`
- Create: `src/partials/header.hbs`
- Create: `src/partials/footer.hbs`
- Create: `src/partials/whatsapp.hbs`
- Modify: `vite.config.mjs`
- Create: `tests/build-accessibility-checks.ps1`

- [ ] **Step 1: Write failing checks for shared accessible markup**

Create `tests/build-accessibility-checks.ps1`:

```powershell
$ErrorActionPreference = "Stop"
$siteRoot = if ($env:SITE_ROOT) { $env:SITE_ROOT } else { "dist" }
$pages = @("index.html", "servicios.html", "productos.html", "nosotros.html", "contacto.html")

foreach ($page in $pages) {
  $path = Join-Path $siteRoot $page
  $html = Get-Content -Raw -Encoding UTF8 $path
  if (($html | Select-String -Pattern '<h1(?:\s|>)' -AllMatches).Matches.Count -ne 1) {
    throw "$page must contain exactly one h1"
  }
  foreach ($needle in @('<header', '<nav', '<main', '<footer', 'class="menu-toggle"', 'aria-expanded="false"', 'aria-controls="main-menu"')) {
    if ($html -notlike "*$needle*") { throw "$page is missing $needle" }
  }
  if ($html -match 'target="_blank"(?![^>]*rel="noopener noreferrer")') {
    throw "$page contains an unsafe external target"
  }
}

Write-Host "Build accessibility checks passed."
```

Run: `powershell -ExecutionPolicy Bypass -File tests/build-accessibility-checks.ps1`

Expected: FAIL because the current pages have no `<main>` and the menu control lacks ARIA state.

- [ ] **Step 2: Centralize shared site data**

Create `src/data/site.mjs` exporting `site`, `navigation`, `pages` and `equipment`. Preserve the current phone, social links, hours, titles, descriptions and the two distinct WhatsApp messages. The rental URL must equal the encoded value currently asserted by `tests/static-site-checks.ps1`; the ice URL must remain the purchase query.

Use this public interface:

```js
export const site = {
  name: 'Cold Hielo',
  phoneDisplay: '11 3300-2956',
  phoneUrl: 'https://wa.me/541133002956',
  rentalUrl: 'https://wa.me/541133002956?text=Hola%2C%20quiero%20solicitar%20un%20presupuesto.%0A%0ANombre%20o%20empresa%3A%0AEquipo%20y%20cantidad%3A%0AFecha%20desde%2Fhasta%3A%0ADireccion%20exacta%20y%20localidad%3A%0A%C2%BFNecesito%20hielo%3F%3A',
  iceUrl: 'https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20compra%20de%20hielo.',
  instagramUrl: 'https://www.instagram.com/coldhielo',
  facebookUrl: 'https://www.facebook.com/coldfreezers',
  address: 'Prudan 119, Ramos Mejia - Buenos Aires',
  administrationHours: 'Lun a Sab de 9 a 18 hs',
  deliveryHours: 'Lunes a sabados',
  pickupHours: '8 a 14 y 17 a 22 hs (Lun a Sab)'
};

export const navigation = [
  { id: 'index', label: 'Inicio', href: 'index.html' },
  { id: 'nosotros', label: 'Nosotros', href: 'nosotros.html' },
  { id: 'productos', label: 'Productos', href: 'productos.html' },
  { id: 'servicios', label: 'Servicios', href: 'servicios.html' },
  { id: 'contacto', label: 'Contacto', href: 'contacto.html' }
];
```

- [ ] **Step 3: Create semantic shared partials**

Use a partial-block layout so every page supplies only its `<main>` content:

```hbs
<!doctype html>
<html lang="es">
  {{> head}}
  <body>
    <a class="skip-link" href="#main-content">Saltar al contenido</a>
    {{> header}}
    {{> @partial-block}}
    {{> whatsapp}}
    {{> footer}}
    <script type="module" src="./src/scripts/main.js"></script>
  </body>
</html>
```

The header must use a real button:

```hbs
<button class="menu-toggle" type="button" aria-label="Abrir menu" aria-controls="main-menu" aria-expanded="false">
  <span aria-hidden="true"></span>
  <span aria-hidden="true"></span>
  <span aria-hidden="true"></span>
</button>
```

Render each navigation item with `aria-current="page"` only when its id matches `page.id`. Add `rel="noopener noreferrer"` to every social, WhatsApp or other external link with `target="_blank"`.

- [ ] **Step 4: Compile Handlebars in Vite**

Replace `vite.config.mjs` with this plugin-backed configuration:

```js
import { readFileSync, readdirSync } from 'node:fs';
import { basename, extname, resolve } from 'node:path';
import Handlebars from 'handlebars';
import { defineConfig } from 'vite';
import { equipment, navigation, pages, site } from './src/data/site.mjs';

const pageIds = ['index', 'servicios', 'productos', 'nosotros', 'contacto'];
const partialsDirectory = resolve(process.cwd(), 'src/partials');

function registerPartials() {
  for (const file of readdirSync(partialsDirectory)) {
    if (extname(file) !== '.hbs') continue;
    const name = basename(file, '.hbs');
    const source = readFileSync(resolve(partialsDirectory, file), 'utf8');
    Handlebars.registerPartial(name, source);
  }
}

function handlebarsPages() {
  registerPartials();
  Handlebars.registerHelper('isCurrent', (itemId, pageId) => itemId === pageId);

  return {
    name: 'cold-hielo-handlebars-pages',
    enforce: 'pre',
    transformIndexHtml: {
      order: 'pre',
      handler(html, context) {
        const requestedFile = basename(context.path || 'index.html');
        const pageId = basename(requestedFile || 'index.html', '.html') || 'index';
        const page = pages[pageId];
        if (!page) throw new Error(`Missing page data for ${pageId}`);
        return Handlebars.compile(html)({ site, navigation, equipment, page });
      }
    }
  };
}

export default defineConfig({
  base: './',
  plugins: [handlebarsPages()],
  build: {
    rollupOptions: {
      input: Object.fromEntries(
        pageIds.map((pageId) => [pageId, resolve(process.cwd(), `${pageId}.html`)])
      )
    }
  }
});
```

- [ ] **Step 5: Convert `index.html` to the shared layout and verify RED becomes GREEN**

Wrap the current Inicio content with `{{#> layout}}`, `<main id="main-content">`, `</main>` and `{{/layout}}`. Keep these complete section blocks in this exact order: banner, `beneficios-alquiler`, `equipos-destacados`, `ideal-para`, `como-funciona-home`, `hielo-complemento`, `confianza`, `cta-principal` and `clientes`. Remove only the duplicated document shell, header, footer, floating WhatsApp link, Bootstrap JavaScript and inline menu script. The resulting source must retain every current heading, paragraph, image and CTA from those nine sections.

Replace shared rental URLs with `{{site.rentalUrl}}`, the ice URL with `{{site.iceUrl}}`, and the navigation state with `page.id` data.

Run: `npm run build; powershell -ExecutionPolicy Bypass -File tests/build-accessibility-checks.ps1`

Expected: the check still fails for the four unconverted pages but passes the assertions for `dist/index.html` when inspected independently.

- [ ] **Step 6: Commit shared templating**

```bash
git add vite.config.mjs src index.html tests/build-accessibility-checks.ps1
git commit -m "Add shared accessible page templates"
```

### Task 3: Migrate all page content and reusable catalog cards

**Files:**
- Create: `src/partials/equipment-card.hbs`
- Modify: `src/data/site.mjs`
- Modify: `servicios.html`
- Modify: `productos.html`
- Modify: `nosotros.html`
- Modify: `contacto.html`
- Modify: `tests/static-site-checks.ps1`

- [ ] **Step 1: Add failing checks for deduplicated output**

Add assertions that every compiled page has one `<header>`, one `<footer>`, one module script and no inline `style=` attributes. Add service assertions for all eight equipment names and the shared rental URL.

Run: `npm run build; powershell -ExecutionPolicy Bypass -File tests/static-site-checks.ps1`

Expected: FAIL because four pages still contain duplicated structure and inline styles.

- [ ] **Step 2: Add complete equipment data**

Populate `equipment` with the current eight service cards: horizontal freezers of 100, 300 and 500 lts; vertical display freezer 500 lts; ice barrel 500 lts; standard refrigerator; display refrigerator; and frigobar. Each record contains `name`, `description`, `image`, `alt` and `rentalUrl: site.rentalUrl`.

- [ ] **Step 3: Render service cards through one partial**

Create `src/partials/equipment-card.hbs`:

```hbs
<article class="equipment-card">
  <img src="{{image}}" alt="{{alt}}" width="640" height="640" loading="lazy" decoding="async">
  <h3>{{name}}</h3>
  <p>{{description}}</p>
  <a class="button button--outline" href="{{../site.rentalUrl}}" target="_blank" rel="noopener noreferrer">Consultar disponibilidad</a>
</article>
```

Render it in `servicios.html` with `{{#each equipment}}{{> equipment-card}}{{/each}}`.

- [ ] **Step 4: Migrate the remaining four pages**

For each page, keep the existing business content inside `<main id="main-content">`, remove duplicated header/footer/WhatsApp/scripts, replace inline maximum widths with `.measure` or `.measure--narrow`, and use the shared URLs. Correct the literal `` `r`n `` present after the Servicios header while migrating.

Use one `h1` per page and preserve the current section order and CTA labels. Give the Contacto iframe `title="Mapa de ubicacion de Cold Hielo"`, `loading="lazy"` and `referrerpolicy="no-referrer-when-downgrade"`.

- [ ] **Step 5: Build and run content plus accessibility checks**

Run: `npm test`

Expected: both PowerShell suites pass for all five generated pages.

- [ ] **Step 6: Commit the complete page migration**

```bash
git add index.html servicios.html productos.html nosotros.html contacto.html src tests
git commit -m "Migrate pages to shared templates"
```

### Task 4: Replace repeated inline scripts with an accessible menu module

**Files:**
- Create: `src/scripts/main.js`
- Delete: `js/menu.js`
- Modify: `tests/build-accessibility-checks.ps1`

- [ ] **Step 1: Add a failing static menu check**

Assert that generated pages contain exactly one `type="module"` script and no `onclick=` or inline `DOMContentLoaded` block.

Run: `npm test`

Expected: FAIL until inline scripts are removed from every source page.

- [ ] **Step 2: Implement the menu module**

Create `src/scripts/main.js` with these behaviors:

```js
const toggle = document.querySelector('.menu-toggle');
const menu = document.querySelector('#main-menu');

if (toggle && menu) {
  const setOpen = (open) => {
    toggle.setAttribute('aria-expanded', String(open));
    toggle.setAttribute('aria-label', open ? 'Cerrar menu' : 'Abrir menu');
    menu.classList.toggle('is-open', open);
  };

  toggle.addEventListener('click', () => {
    setOpen(toggle.getAttribute('aria-expanded') !== 'true');
  });

  menu.addEventListener('click', (event) => {
    if (event.target.closest('a')) setOpen(false);
  });

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && toggle.getAttribute('aria-expanded') === 'true') {
      setOpen(false);
      toggle.focus();
    }
  });

  window.addEventListener('resize', () => {
    if (window.matchMedia('(min-width: 769px)').matches) setOpen(false);
  });
}
```

- [ ] **Step 3: Verify and commit the menu behavior**

Run: `npm test`

Expected: PASS.

```bash
git add src/scripts/main.js tests/build-accessibility-checks.ps1
git rm js/menu.js
git commit -m "Add accessible mobile navigation"
```

### Task 5: Refactor CSS without changing visual identity

**Files:**
- Create: `src/styles/main.css`
- Create: `src/styles/tokens.css`
- Create: `src/styles/base.css`
- Create: `src/styles/layout.css`
- Create: `src/styles/components.css`
- Create: `src/styles/responsive.css`
- Delete: `css/style.css`
- Modify: `tests/static-site-checks.ps1`

- [ ] **Step 1: Add failing checks for production CSS hygiene**

Assert that compiled HTML references a Vite-generated CSS asset, contains no `style=` attributes and does not load Bootstrap JavaScript. Keep Bootstrap CSS temporarily while visual parity is checked.

Run: `npm test`

Expected: FAIL while the old stylesheet and inline styles remain.

- [ ] **Step 2: Split CSS by responsibility**

Move the current variables to `tokens.css`, global element rules and focus styles to `base.css`, structural rules to `layout.css`, component rules to `components.css` and media queries to `responsive.css`. Import them from `main.css` in that order.

Use `--radius-sm: 6px`, `--radius-md: 8px`, existing yellow/cyan/black brand colors, and the current shadows. Remove unused carousel and legacy selectors only after confirming they appear in neither source HTML nor JavaScript.

- [ ] **Step 3: Add accessible and stable base rules**

Include:

```css
*, *::before, *::after { box-sizing: border-box; }
html { scroll-behavior: smooth; }
body { margin: 0; min-width: 320px; overflow-x: clip; }
img { display: block; max-width: 100%; height: auto; }
:focus-visible { outline: 3px solid #087c8f; outline-offset: 3px; }
.skip-link { position: fixed; top: 0.5rem; left: 0.5rem; z-index: 1100; transform: translateY(-150%); }
.skip-link:focus { transform: translateY(0); }
.measure { max-width: 53rem; margin-inline: auto; }
.measure--narrow { max-width: 47.5rem; margin-inline: auto; }
```

- [ ] **Step 4: Stabilize responsive layout**

At widths up to 768 px, keep the menu button at least 44x44 px, make the navigation an anchored panel, stack hero actions, limit hero height with a fixed aspect-ratio/min-height combination, and reserve bottom spacing around the WhatsApp control. At desktop widths, use CSS Grid for equipment and feature lists with explicit minimum tracks.

- [ ] **Step 5: Build, verify and commit CSS**

Run: `npm test`

Expected: PASS with no old `css/style.css` reference in `dist/*.html`.

```bash
git add src/styles tests index.html servicios.html productos.html nosotros.html contacto.html
git rm css/style.css
git commit -m "Refactor responsive site styles"
```

### Task 6: Optimize image delivery and layout stability

**Files:**
- Create: `public/img/banner-index-2.webp`
- Create: `public/img/hielo-cubo.webp`
- Create: `public/img/hielo-picado.webp`
- Create: `public/img/barra-hielo.webp`
- Create: `public/img/bolsa-barra-hielo.webp`
- Modify: all five HTML templates
- Modify: `tests/build-accessibility-checks.ps1`

- [ ] **Step 1: Add failing image checks**

For each generated page, inspect every non-SVG `<img>` tag and fail when `width` or `height` is missing. Fail when a non-hero image after the first content section lacks `loading="lazy"`. Assert that the Inicio hero uses `fetchpriority="high"` and is not lazy loaded.

Run: `npm test`

Expected: FAIL against current image markup.

- [ ] **Step 2: Generate WebP variants**

Use Pillow once, preserving aspect ratio and metadata-free output:

```powershell
@'
from pathlib import Path
from PIL import Image

for name in ["banner-index-2", "hielo-cubo", "hielo-picado", "barra-hielo", "bolsa-barra-hielo"]:
    source = Path("img") / f"{name}.png"
    target = Path("public/img") / f"{name}.webp"
    target.parent.mkdir(parents=True, exist_ok=True)
    with Image.open(source) as image:
        image.save(target, "WEBP", quality=82, method=6)
'@ | python -
```

Expected: each WebP is smaller than its PNG source. If an individual output is not smaller, keep the original reference for that asset and do not add the ineffective WebP.

- [ ] **Step 3: Move retained public assets and add image metadata**

Move all referenced `img/` files into `public/img/` without renaming existing paths. Use WebP sources for the five converted photographs/graphics. Add intrinsic dimensions from the actual files to every image. The first visual image on each page gets `fetchpriority="high"`; later content images get `loading="lazy" decoding="async"`.

Use empty `alt=""` for duplicated client logos in the animated second set and meaningful organization names for the first set. Keep the floating WhatsApp image decorative because the parent link already has an accessible name.

- [ ] **Step 4: Verify weight, markup and build**

Run: `npm test`

Expected: PASS.

Compare total referenced image bytes before and after with PowerShell. Expected: the new WebP set is materially smaller than the five replaced PNG files.

- [ ] **Step 5: Commit optimized assets**

```bash
git add public/img index.html servicios.html productos.html nosotros.html contacto.html tests
git rm -r img
git commit -m "Optimize responsive image delivery"
```

### Task 7: Add automated GitHub Pages deployment

**Files:**
- Create: `.github/workflows/deploy-pages.yml`
- Modify: `README.md`

- [ ] **Step 1: Create the deployment workflow**

Use `actions/checkout@v4`, `actions/setup-node@v4` with Node 20, `npm ci`, `npm test`, `actions/configure-pages@v5`, `actions/upload-pages-artifact@v3` with `dist`, and `actions/deploy-pages@v4`. Trigger on pushes to `main` and allow manual dispatch. Set `pages: write` and `id-token: write` permissions, with one deployment concurrency group.

- [ ] **Step 2: Document local and production commands**

Update README with:

```text
npm install
npm run dev
npm test
npm run build
npm run preview
```

Document that GitHub Pages must use `GitHub Actions` as its source under repository Settings > Pages.

- [ ] **Step 3: Validate YAML scope and commit**

Run: `npm test`

Expected: PASS before deployment files are committed.

```bash
git add .github/workflows/deploy-pages.yml README.md
git commit -m "Deploy Vite site with GitHub Pages"
```

### Task 8: Rendered QA and performance comparison

**Files:**
- Modify only files implicated by verified QA findings.

- [ ] **Step 1: Start the production preview**

Run: `npm run build` and then `npm run preview -- --host 127.0.0.1 --port 4173`.

Expected: preview serves all five pages at `http://127.0.0.1:4173/`.

- [ ] **Step 2: Verify desktop and mobile rendering**

Use the Browser plugin. Check 1440x900, 768x1024 and 360x800. For each page verify title, meaningful DOM, no framework overlay, no horizontal overflow and no console errors. Capture Inicio and Servicios at desktop and 360 px mobile.

- [ ] **Step 3: Exercise interactions**

At 360 px: open the menu, confirm `aria-expanded="true"`, navigate to Servicios, reopen and close with Escape, then confirm focus returns to the toggle. Open one WhatsApp CTA and verify its URL contains the encoded short inquiry template.

- [ ] **Step 4: Run Lighthouse before/after metrics consistently**

Run Lighthouse against the production preview with mobile emulation, recording performance, accessibility, LCP, CLS and transferred bytes. Compare against the currently published site using the same Lighthouse version and throttling profile. Treat score changes as evidence, not as fixed acceptance thresholds.

- [ ] **Step 5: Fix only reproducible regressions and rerun all checks**

For each defect, add or extend a failing automated check when possible, apply the smallest CSS/HTML/JS correction, reload the same viewport and rerun `npm test`.

- [ ] **Step 6: Final verification and commit**

Run: `npm test`

Expected: build and both static suites pass.

Run: `git diff --check`

Expected: no whitespace errors.

```bash
git add -A
git commit -m "Complete frontend performance audit"
```

## Delivery report

After implementation, report critical findings by source area: five page templates, shared partials/data, styles, JavaScript, images, tests and deployment. Link to the production-ready files rather than pasting entire generated files, and include compact corrected-code excerpts for the reusable layout, menu and responsive image pattern. Include actual before/after image bytes and Lighthouse observations when the environment permits measurement.
