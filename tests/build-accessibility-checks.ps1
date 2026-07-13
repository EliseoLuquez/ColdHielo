$ErrorActionPreference = "Stop"
$siteRoot = if ($env:SITE_ROOT) { $env:SITE_ROOT } else { "dist" }
$sourceRoot = Split-Path -Parent $PSScriptRoot
$pages = @("index.html", "servicios.html", "productos.html", "nosotros.html", "contacto.html")
$sourceHead = Get-Content -Raw -Encoding UTF8 (Join-Path $sourceRoot "src/partials/head.hbs")
$sourceTokens = Get-Content -Raw -Encoding UTF8 (Join-Path $sourceRoot "src/styles/tokens.css")

$tokenFeatures = @(
  @{ Pattern = '--space-1\s*:\s*0\.25rem'; Label = 'four-pixel spacing scale' }
  @{ Pattern = '--font-body\s*:'; Label = 'body font token' }
  @{ Pattern = '--motion-fast\s*:\s*160ms'; Label = 'fast motion token' }
  @{ Pattern = '--ease-premium\s*:\s*cubic-bezier\(0\.4,\s*0,\s*0\.2,\s*1\)'; Label = 'premium easing token' }
  @{ Pattern = '--motion-entry\s*:\s*360ms'; Label = 'scroll entry duration token' }
  @{ Pattern = '--radius-image\s*:\s*16px'; Label = 'visible image radius token' }
)

foreach ($feature in $tokenFeatures) {
  if ($sourceTokens -notmatch $feature.Pattern) {
    throw "Source tokens are missing $($feature.Label)"
  }
}

if ($sourceHead -notmatch '(?i)href\s*=\s*(["''])\./src/styles/main\.css\1') {
  throw "Shared head must load the Vite CSS entry ./src/styles/main.css"
}

$bootstrapPosition = $sourceHead.IndexOf('bootstrap@5.3.3', [System.StringComparison]::OrdinalIgnoreCase)
$siteCssPosition = $sourceHead.IndexOf('./src/styles/main.css', [System.StringComparison]::OrdinalIgnoreCase)
if ($bootstrapPosition -lt 0 -or $bootstrapPosition -gt $siteCssPosition) {
  throw 'Bootstrap must load before the site CSS so brand components can override framework defaults'
}

if ($sourceHead -match '(?i)css/style\.css') {
  throw "Shared head must not reference legacy css/style.css"
}

foreach ($page in $pages) {
  $path = Join-Path $siteRoot $page
  if (-not (Test-Path -LiteralPath $path)) {
    throw "Missing built page: $path"
  }

  $html = Get-Content -Raw -Encoding UTF8 $path

  if ($html -match '(?i)css/style\.css') {
    throw "$page must not reference legacy css/style.css"
  }

  $localStylesheets = [regex]::Matches(
    $html,
    '<link\b(?=[^>]*\brel\s*=\s*(["''])stylesheet\1)[^>]*\bhref\s*=\s*(["''])(?<value>\./assets/[^"'']+-[A-Za-z0-9_-]+\.css)\2[^>]*>',
    'IgnoreCase'
  )
  if ($localStylesheets.Count -ne 1) {
    throw "$page must reference exactly one Vite-generated local CSS asset"
  }

  $cssAsset = $localStylesheets[0].Groups['value'].Value -replace '^\./', ''
  if (-not (Test-Path -LiteralPath (Join-Path $siteRoot $cssAsset))) {
    throw "$page references missing CSS asset: $cssAsset"
  }
  $h1Count = ([regex]::Matches($html, '<h1(?:\s|>)', 'IgnoreCase')).Count
  if ($h1Count -ne 1) {
    throw "$page must contain exactly one h1"
  }

  foreach ($needle in @('<header', '<nav', '<main', '<footer', 'class="menu-toggle"', 'aria-expanded="false"', 'aria-controls="main-menu"')) {
    if ($html.IndexOf($needle, [System.StringComparison]::OrdinalIgnoreCase) -lt 0) {
      throw "$page is missing $needle"
    }
  }

  foreach ($element in @('header', 'main', 'footer')) {
    $elementCount = ([regex]::Matches($html, "<$element(?:\s|>)", 'IgnoreCase')).Count
    if ($elementCount -ne 1) {
      throw "$page must contain exactly one $element"
    }
  }

  $scriptTags = [regex]::Matches($html, '<script\b[^>]*>', 'IgnoreCase')
  if ($scriptTags.Count -ne 1) {
    throw "$page must contain exactly one script tag"
  }

  $scriptTag = $scriptTags[0].Value
  $typeMatch = [regex]::Match($scriptTag, '\btype\s*=\s*(["''])(?<value>[^"'']*)\1', 'IgnoreCase')
  if (-not $typeMatch.Success -or $typeMatch.Groups['value'].Value -ine 'module') {
    throw "$page script must have type=module"
  }

  $srcMatch = [regex]::Match($scriptTag, '\bsrc\s*=\s*(["''])(?<value>[^"'']*)\1', 'IgnoreCase')
  if (-not $srcMatch.Success -or [string]::IsNullOrWhiteSpace($srcMatch.Groups['value'].Value)) {
    throw "$page script must have a non-empty src"
  }

  if ($html -match '(?i)<script\b(?![^>]*\bsrc\s*=)[^>]*>') {
    throw "$page must not contain inline scripts"
  }

  if ($html -match '(?i)\son[a-z]+\s*=') {
    throw "$page must not contain inline event handlers"
  }

  if ($html -match '(?i)\sstyle\s*=') {
    throw "$page must not contain inline style attributes"
  }

  if ($html -match '(?i)bootstrap(?:\.bundle)?(?:\.min)?\.js|DOMContentLoaded') {
    throw "$page must not contain duplicated legacy scripts"
  }

  foreach ($linkMatch in [regex]::Matches($html, '<a\b[^>]*>', 'IgnoreCase')) {
    $link = $linkMatch.Value
    if ($link -notmatch '(?i)\btarget\s*=\s*(["''])_blank\1') {
      continue
    }

    $relMatch = [regex]::Match($link, '(?i)\brel\s*=\s*(["''])(?<value>[^"'']*)\1')
    $relTokens = if ($relMatch.Success) { $relMatch.Groups['value'].Value -split '\s+' } else { @() }
    if ($relTokens -notcontains 'noopener' -or $relTokens -notcontains 'noreferrer') {
      throw "$page contains an unsafe external target: $link"
    }
  }
}

$indexHtml = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $siteRoot "index.html")
$cssHrefMatch = [regex]::Match($indexHtml, 'href="(?<path>\.?/?assets/[^"?]+-[A-Za-z0-9_-]+\.css)"', 'IgnoreCase')
if (-not $cssHrefMatch.Success) {
  throw "Missing hashed Vite CSS reference in index.html"
}
$compiledCssPath = Join-Path $siteRoot ($cssHrefMatch.Groups['path'].Value -replace '^\./', '')
if (-not (Test-Path -LiteralPath $compiledCssPath)) {
  throw "Missing compiled Vite CSS asset: $compiledCssPath"
}

$compiledCss = Get-Content -Raw -Encoding UTF8 $compiledCssPath
$cssFeatures = @(
  @{ Pattern = 'h1\s*\{[^}]*font-size\s*:\s*clamp\('; Label = 'fluid primary heading' }
  @{ Pattern = 'h1\s*,\s*h2\s*\{[^}]*text-transform\s*:\s*uppercase'; Label = 'uppercase page and section headings' }
  @{ Pattern = 'body\s*\{[^}]*font-size\s*:\s*1rem[^}]*line-height\s*:\s*1\.6'; Label = 'readable body typography' }
  @{ Pattern = '\*\s*,\s*\*:{1,2}before\s*,\s*\*:{1,2}after\s*\{[^}]*box-sizing\s*:\s*border-box'; Label = 'universal box sizing' },
  @{ Pattern = 'body\s*\{[^}]*min-width\s*:\s*320px'; Label = 'minimum body width' },
  @{ Pattern = 'body\s*\{[^}]*overflow-x\s*:\s*clip'; Label = 'horizontal overflow protection' },
  @{ Pattern = 'img\s*\{[^}]*display\s*:\s*block[^}]*max-width\s*:\s*100%[^}]*height\s*:\s*auto'; Label = 'responsive image defaults' },
  @{ Pattern = '\.inner\s*\{[^}]*width\s*:\s*min\(100%'; Label = 'fluid content container' },
  @{ Pattern = 'header\s*\{[^}]*min-height\s*:\s*72px'; Label = 'stable mobile header' },
  @{ Pattern = '\.logo-header img\s*\{[^}]*width\s*:\s*140px[^}]*height\s*:\s*auto'; Label = 'compact desktop logo size' },
  @{ Pattern = 'header\s*>\s*\.d-flex\s*\{[^}]*flex-wrap\s*:\s*nowrap'; Label = 'single-row header content' },
  @{ Pattern = ':focus-visible\s*\{[^}]*outline\s*:'; Label = 'visible keyboard focus' },
  @{ Pattern = '\.skip-link\s*\{[^}]*position\s*:\s*fixed'; Label = 'functional skip link' },
  @{ Pattern = '@media\s*\(min-width\s*:\s*600px\)'; Label = 'small tablet enhancement' },
  @{ Pattern = '@media\s*\(min-width\s*:\s*768px\)'; Label = 'desktop navigation enhancement' },
  @{ Pattern = '@media\s*\(min-width\s*:\s*1024px\)'; Label = 'wide layout enhancement' },
  @{ Pattern = '\.btn\s*\{[^}]*min-height\s*:\s*44px'; Label = 'accessible button target' },
  @{ Pattern = '\.btn\s*\{[^}]*transition\s*:[^}]*var\(--motion-fast\)'; Label = 'button microinteraction' },
  @{ Pattern = '\.btn\s*\{[^}]*var\(--ease-premium\)'; Label = 'premium button easing' },
  @{ Pattern = '@media\s*\(hover\s*:\s*hover\)\s*and\s*\(pointer\s*:\s*fine\)'; Label = 'hover-capable interaction query' },
  @{ Pattern = '@media\s*\(hover\s*:\s*hover\)[\s\S]*?translateY\(-2px\)'; Label = 'two-pixel premium lift' },
  @{ Pattern = '@supports\s*\(animation-timeline\s*:\s*view\(\)\)'; Label = 'guarded view timeline support' },
  @{ Pattern = 'animation-timeline\s*:\s*view\(\)'; Label = 'view timeline animation' },
  @{ Pattern = 'animation-range\s*:\s*entry\s+10%\s+cover\s+28%'; Label = 'restrained entry range' },
  @{ Pattern = 'animation-fill-mode\s*:\s*none'; Label = 'anchor-safe scroll fill mode' },
  @{ Pattern = '@keyframes\s+section-entry[\s\S]*?translateY\(18px\)'; Label = 'restrained entry distance' },
  @{ Pattern = '\.equipment-card\s*\{[^}]*border-radius\s*:\s*var\(--radius-md\)'; Label = 'consistent equipment radius' },
  @{ Pattern = '\.equipment-card img\s*\{[^}]*width\s*:\s*100%[^}]*height\s*:\s*auto'; Label = 'natural-ratio equipment media' },
  @{ Pattern = '\.equipment-card img\s*\{[^}]*border-radius\s*:\s*var\(--radius-image\)'; Label = 'rounded equipment imagery' },
  @{ Pattern = '\.equipo-item img\s*\{[^}]*border-radius\s*:\s*var\(--radius-image\)'; Label = 'rounded service equipment imagery' },
  @{ Pattern = '\.equipo-item img\s*\{[^}]*width\s*:\s*100%[^}]*max-width\s*:\s*280px[^}]*height\s*:\s*auto'; Label = 'natural-ratio service equipment imagery' },
  @{ Pattern = '\.equipment-card img\s*\{[^}]*clip-path\s*:\s*inset\(0 round var\(--radius-image\)\)'; Label = 'clipped rounded equipment imagery' },
  @{ Pattern = '\.equipo-item img\s*\{[^}]*clip-path\s*:\s*inset\(0 round var\(--radius-image\)\)'; Label = 'clipped rounded service equipment imagery' },
  @{ Pattern = '\.servicio-item img\s*\{[^}]*border-radius\s*:\s*var\(--radius-md\)'; Label = 'rounded service imagery' },
  @{ Pattern = '\.evento-foto img\s*\{[^}]*border-radius\s*:\s*var\(--radius-md\)'; Label = 'rounded event imagery' },
  @{ Pattern = '\.banner-nosotros-texto(?:\s*,[^{}]+)*\s*\{[^}]*max-width\s*:'; Label = 'readable hero measure' },
  @{ Pattern = '@media\s*\(prefers-reduced-motion\s*:\s*reduce\)[\s\S]*?\*\s*,\s*\*:{1,2}before\s*,\s*\*:{1,2}after\s*\{[^}]*scroll-behavior\s*:\s*auto'; Label = 'reduced-motion scroll override' }
  @{ Pattern = '@media\s*\(prefers-reduced-motion\s*:\s*reduce\)[\s\S]*?transition-duration\s*:\s*(?:0)?\.01ms'; Label = 'reduced transition motion' }
  @{ Pattern = '@media\s*\(prefers-reduced-motion\s*:\s*reduce\)[\s\S]*?\.slide-track\s*\{[^}]*animation\s*:\s*none'; Label = 'reduced-motion carousel override' }
)

foreach ($feature in $cssFeatures) {
  if ($compiledCss -notmatch $feature.Pattern) {
    throw "Compiled CSS is missing $($feature.Label)"
  }
}

if ($compiledCss -match '\.equipment-card img\s*\{[^}]*aspect-ratio\s*:') {
  throw 'Equipment images must preserve their natural aspect ratio so rounded corners remain visible'
}

if ($compiledCss -match '\.equipo-item img\s*\{[^}]*max-height\s*:') {
  throw 'Service equipment images must not be letterboxed by a fixed maximum height'
}

if ($compiledCss -match '#clientes:(?:hover|focus-within)[^{]*\.slide-track\{[^}]*animation-play-state\s*:\s*paused') {
  throw 'Carousel pause state must be controlled explicitly, not by hover or focus'
}

if ($compiledCss -notmatch '\.slide-track\{[^}]*animation\s*:\s*scroll\s+30s\s+linear\s+infinite') {
  throw 'Client logo carousel must keep its automatic scroll animation'
}

foreach ($selector in @('#cta-principal', '#cta-servicios-final', '#cta-productos-final', '#cta-contacto-final', '#cta-nosotros-final')) {
  $escapedSelector = [regex]::Escape($selector)
  if ($compiledCss -notmatch "$escapedSelector(?:\s*,[^{}]+)*\s*\{[^}]*padding\s*:\s*2rem\s+1rem") {
    throw "Compiled base CSS is missing compact padding for $selector"
  }
}

Write-Host "Build accessibility checks passed."
