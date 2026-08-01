$ErrorActionPreference = "Stop"

$siteRoot = if ($env:SITE_ROOT) { $env:SITE_ROOT } else { "dist" }
$sourceRoot = Split-Path -Parent $PSScriptRoot
$pages = @("index.html", "servicios.html", "productos.html", "nosotros.html", "contacto.html")

function Site-Path($path) {
  Join-Path $siteRoot $path
}

function Read-Page($path) {
  $builtPath = Site-Path $path

  if (-not (Test-Path -LiteralPath $builtPath)) {
    throw "Missing built page: $builtPath"
  }

  Get-Content -Raw -Encoding UTF8 -LiteralPath $builtPath
}

function Assert-Contains($content, $needle, $label) {
  if ($content -notlike "*$needle*") {
    throw "Missing expected content for ${label}: $needle"
  }
}

function Assert-NotContains($content, $needle, $label) {
  if ($content -like "*$needle*") {
    throw "Unexpected content for ${label}: $needle"
  }
}

function Assert-Matches($content, $pattern, $label) {
  if ($content -notmatch $pattern) {
    throw "Missing expected pattern for ${label}: $pattern"
  }
}

function Assert-NotMatches($content, $pattern, $label) {
  if ($content -match $pattern) {
    throw "Unexpected pattern for ${label}: $pattern"
  }
}

$index = Read-Page "index.html"
$servicios = Read-Page "servicios.html"
$productos = Read-Page "productos.html"
$contacto = Read-Page "contacto.html"
$nosotros = Read-Page "nosotros.html"
$cssHrefMatch = [regex]::Match($index, 'href="(?<path>\.?/?assets/[^"?]+-[A-Za-z0-9_-]+\.css)"', 'IgnoreCase')
if (-not $cssHrefMatch.Success) {
  throw "Home page is missing a hashed Vite stylesheet"
}
$css = Read-Page ($cssHrefMatch.Groups['path'].Value -replace '^\./', '')
$sourceIndex = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $sourceRoot "index.html")
$sourceData = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $sourceRoot "src/data/site.mjs")
$sourceEquipmentCard = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $sourceRoot "src/partials/equipment-card.hbs")

$rentalQuery = "https://wa.me/541133002956?text=Hola%2C%20quiero%20solicitar%20un%20presupuesto.%0A%0ANombre%20o%20empresa%3A%0AEquipo%20y%20cantidad%3A%0AFecha%20desde%2Fhasta%3A%0ADirecci%C3%B3n%20exacta%20y%20localidad%3A%0A%C2%BFNecesito%20hielo%3F%3A"
$oldRentalQuery = "Hola%2C%20quiero%20consultar%20por%20alquiler%20de%20freezer%20o%20heladera."
$iceQuery = "https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20compra%20de%20hielo."
$acuteA = [char]0x00E1
$acuteE = [char]0x00E9
$acuteI = [char]0x00ED
$acuteO = [char]0x00F3
$cylindricalIce = "hielo cil${acuteI}ndrico"

Assert-Contains $index "Alquiler de Freezers y Heladeras y Venta de Hielo | Cold Hielo" "home title"
Assert-Contains $index "Alquiler de <span>freezers y heladeras</span></h1>" "home heading"
Assert-NotContains $index "Alquiler de Freezers, Heladeras y Tachos" "old home title"
Assert-Contains $index "Del fr${acuteI}o nos encargamos nosotros" "home hero heading"
Assert-Contains $index "C${acuteO}mo funciona el alquiler" "home accented process heading"
Assert-Contains $index "Solicit${acuteA} tu presupuesto" "shared quote CTA heading"
Assert-NotContains $index "Empresa familiar con atenci${acuteO}n directa" "removed home trust heading"
Assert-NotContains $index "css/main.css" "unhashed legacy stylesheet"
foreach ($pageName in $pages) {
  $pageHtml = Read-Page $pageName
  Assert-NotMatches $pageHtml '>\s*\r?\n\s*<' "$pageName unminified HTML between tags"
  Assert-Contains $pageHtml 'class="btn' "$pageName styled actions"
  Assert-NotMatches $pageHtml 'style\s*=' "$pageName inline style regression"
  Assert-NotMatches $pageHtml '(?i)hielo en cubos' "$pageName old ice terminology"
}
Assert-Contains $index $cylindricalIce "home cylindrical ice terminology"
Assert-Contains $productos $cylindricalIce "products cylindrical ice terminology"
Assert-Contains $nosotros $cylindricalIce "about cylindrical ice terminology"
Assert-Contains $sourceData $cylindricalIce "metadata cylindrical ice terminology"
Assert-NotContains $index 'class="carousel-toggle"' "home carousel control removed"
Assert-Contains $index 'class="slide-track"' "home automatic client logo track"
Assert-Contains $index "Consultar disponibilidad" "home primary CTA"
Assert-Contains $index "CABA y Gran Buenos Aires" "home service area"
Assert-NotContains $index "Alquiler de Freezers y Heladeras en Ramos Mejia" "old Ramos Mejia title"
Assert-Contains $index "Equipos destacados" "home equipment section"
Assert-Contains $index "img/catalogo-freezer-horizontal.jpg" "home catalog horizontal freezer image"
Assert-Contains $index "100, 300 y 500 lts" "home horizontal freezer capacities"
Assert-Contains $index "img/catalogo-heladera-exhibidora.jpg" "home emitted vertical display freezer image"
Assert-Contains $index "Freezer vertical exhibidor" "home vertical display freezer copy"
Assert-Contains $index "img/catalogo-heladera-exhibidora.jpg" "home catalog display fridge image"
Assert-Contains $index "img/catalogo-heladera-comun.jpg" "home catalog standard fridge image"
Assert-Contains $index "img/catalogo-frigobar.jpg" "home catalog mini fridge image"
Assert-Contains $index "img/catalogo-tachos-hielo-500.jpg" "home catalog ice barrel image"
Assert-Contains $index "Tachos para hielo 500 lts" "home ice barrel copy"
Assert-Contains $index "ice-service-icon" "home ice service icons"
Assert-Contains $index "uso-icon" "home ideal-for icons"
Assert-Contains $index "C${acuteO}mo funciona" "home process section"
Assert-Contains $index "Venta de hielo para eventos y comercios" "home ice complement section"
Assert-Contains $index $rentalQuery "home rental WhatsApp query"
Assert-NotContains $index $oldRentalQuery "old home rental WhatsApp query"

Assert-Contains $servicios $rentalQuery "service rental WhatsApp query"
Assert-Contains $servicios "Alquiler de Freezers y Heladeras | Cold Hielo" "service title"
Assert-Contains $servicios "Alquiler de Freezers y Heladeras</h1>" "service heading"
Assert-NotContains $servicios "Alquiler de Freezers, Heladeras y Tachos" "old service title"
Assert-Contains $servicios "img/catalogo-freezer-horizontal.jpg" "service catalog horizontal freezer image"
Assert-Contains $servicios "Freezer horizontal 100 lts" "service horizontal 100 lts"
Assert-Contains $servicios "Freezer horizontal 300 lts" "service horizontal 300 lts"
Assert-Contains $servicios "Freezer horizontal 500 lts" "service horizontal 500 lts"
Assert-Contains $servicios "img/catalogo-heladera-exhibidora.jpg" "service emitted vertical display freezer image"
Assert-Contains $servicios "Freezer vertical exhibidor 500 lts" "service vertical display freezer copy"
Assert-Contains $servicios "img/catalogo-heladera-exhibidora.jpg" "service catalog display fridge image"
Assert-Contains $servicios "img/catalogo-heladera-comun.jpg" "service catalog standard fridge image"
Assert-Contains $servicios "img/catalogo-frigobar.jpg" "service catalog mini fridge image"
Assert-Contains $servicios "Medidas orientativas: aprox. 50 x 50 x 85 cm" "service mini fridge generic dimensions"
Assert-Contains $servicios "img/catalogo-tachos-hielo-500.jpg" "service ice barrel image"
Assert-Contains $servicios "Tachos para hielo 500 lts" "service ice barrel copy"

Assert-Contains $productos $iceQuery "product ice WhatsApp query"
Assert-Contains $productos $rentalQuery "product shared quote CTA WhatsApp query"

Assert-Contains $nosotros "equipos de fr${acuteI}o" "about accented cold-equipment copy"
Assert-Contains $nosotros "costo de env${acuteI}o" "about delivery-availability copy"
Assert-Contains $contacto "title=`"Mapa de ubicaci${acuteO}n de Cold Hielo`"" "contact map accessible title"
Assert-Contains $sourceData "venta de hielo en CABA y Gran Buenos Aires" "metadata description"
Assert-Contains $sourceData "Opci${acuteO}n compacta" "accented equipment option"
Assert-Contains $sourceData "conservaci${acuteO}n de hielo" "accented equipment conservation"
Assert-Contains $sourceData "Compacto y pr${acuteA}ctico" "accented mini-fridge description"

$commonFridgeName = "Heladera com$([char]0x00FA)n"
$equipmentNames = @(
  "Freezer horizontal 100 lts",
  "Freezer horizontal 300 lts",
  "Freezer horizontal 500 lts",
  "Freezer vertical exhibidor 500 lts",
  "Tachos para hielo 500 lts",
  $commonFridgeName,
  "Heladera exhibidora",
  "Frigobar"
)

foreach ($equipmentName in $equipmentNames) {
  Assert-Contains $servicios $equipmentName "service equipment catalog"
  Assert-Contains $sourceData $equipmentName "source equipment data"
  Assert-Matches $servicios ("<h4>" + [regex]::Escape($equipmentName) + "</h4>") "service equipment heading hierarchy"
}

$equipmentCardCount = ([regex]::Matches($servicios, '<article\b[^>]*\bclass="[^"]*\bequipo-item\b[^"]*"', 'IgnoreCase')).Count
if ($equipmentCardCount -ne $equipmentNames.Count) {
  throw "Service equipment catalog must render exactly $($equipmentNames.Count) cards"
}

$serviceImages = [regex]::Matches($servicios, '<img\b(?=[^>]*\bloading="lazy")(?=[^>]*\bdecoding="async")[^>]*>', 'IgnoreCase')
if ($serviceImages.Count -lt $equipmentNames.Count) {
  throw "Service equipment images must use lazy loading and async decoding"
}

Assert-Contains $sourceEquipmentCard 'href="{{@root.site.rentalUrl}}"' "escaped equipment rental URL"
Assert-NotContains $sourceEquipmentCard 'href="{{{@root.site.rentalUrl}}}"' "unescaped equipment rental URL"
Assert-Contains $servicios "alt=`"$commonFridgeName para bebidas y conservas`"" "accented service equipment alt"

Assert-NotContains $contacto "colddhielo" "contact Instagram typo"
Assert-Contains $contacto "https://www.instagram.com/coldhielo" "contact Instagram URL"
Assert-Contains $contacto $rentalQuery "contact rental WhatsApp query"
Assert-Contains $nosotros $rentalQuery "about rental WhatsApp query"
Assert-NotContains $servicios $oldRentalQuery "old services rental WhatsApp query"
Assert-NotContains $contacto $oldRentalQuery "old contact rental WhatsApp query"
Assert-NotContains $nosotros $oldRentalQuery "old about rental WhatsApp query"

Assert-NotContains $index 'class="section-kicker' "home section kicker labels"
Assert-NotContains $css ".section-kicker" "unused section kicker styles"
Assert-Contains $css ".equipment-card" "equipment card styles"
Assert-Contains $css ".feature-card" "feature card styles"
Assert-Contains $css ".process-card" "process card styles"
Assert-Contains $css ".logo-header img" "mobile logo styles"
Assert-Contains $css ".uso-icon" "ideal-for icon styles"
Assert-Matches $css '\.hero\s*\{' "site wrapper styles"
Assert-Matches $css '--site-background\s*:\s*#f4f7f8(?:\s*;|\s*})' "clean site background"
Assert-NotMatches $css '\.hero\s*\{[^}]*background\s*:\s*url\(["'']?\.\./img/background-pattern\.png' "global patterned background"

$verticalExhibitorImage = "img/catalogo-freezer-vertical-exhibidor-500.jpg"
Assert-Contains $sourceIndex $verticalExhibitorImage "source home vertical display freezer image"
Assert-Contains $sourceData $verticalExhibitorImage "source service vertical display freezer image"

$sourceVerticalExhibitorImage = Join-Path (Join-Path $sourceRoot "public") $verticalExhibitorImage
if (-not (Test-Path -LiteralPath $sourceVerticalExhibitorImage)) {
  throw "Missing source catalog image file: $verticalExhibitorImage"
}

$catalogImages = @(
  "img/catalogo-freezer-horizontal.jpg",
  "img/catalogo-heladera-exhibidora.jpg",
  "img/catalogo-heladera-comun.jpg",
  "img/catalogo-frigobar.jpg",
  "img/catalogo-tachos-hielo-500.jpg"
)

foreach ($imagePath in $catalogImages) {
  if (-not (Test-Path (Site-Path $imagePath))) {
    throw "Missing catalog image file: $imagePath"
  }
}

Write-Host "Static site checks passed."
