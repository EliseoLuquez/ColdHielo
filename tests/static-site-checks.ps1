$ErrorActionPreference = "Stop"

function Read-Page($path) {
  Get-Content -Raw -Encoding UTF8 $path
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

$index = Read-Page "index.html"
$servicios = Read-Page "servicios.html"
$productos = Read-Page "productos.html"
$contacto = Read-Page "contacto.html"
$nosotros = Read-Page "nosotros.html"
$css = Read-Page "css/style.css"

$rentalQuery = "https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20alquiler%20de%20freezer%20o%20heladera."
$iceQuery = "https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20compra%20de%20hielo."

Assert-Contains $index "Alquiler de Freezers, Heladeras y Tachos | Cold Hielo" "home title"
Assert-Contains $index "css/style.css?v=20260617-1" "home cache-busted stylesheet"
Assert-Contains $index "Consultar disponibilidad" "home primary CTA"
Assert-Contains $index "CABA y Gran Buenos Aires" "home service area"
Assert-NotContains $index "Alquiler de Freezers y Heladeras en Ramos Mejia" "old Ramos Mejia title"
Assert-Contains $index "Equipos destacados" "home equipment section"
Assert-Contains $index "img/catalogo-freezer-horizontal.jpg" "home catalog horizontal freezer image"
Assert-Contains $index "100, 300 y 500 lts" "home horizontal freezer capacities"
Assert-Contains $index "img/catalogo-freezer-vertical-exhibidor-500.jpg" "home vertical display freezer image"
Assert-Contains $index "Freezer vertical exhibidor" "home vertical display freezer copy"
Assert-Contains $index "img/catalogo-heladera-exhibidora.jpg" "home catalog display fridge image"
Assert-Contains $index "img/catalogo-heladera-comun.jpg" "home catalog standard fridge image"
Assert-Contains $index "img/catalogo-frigobar.jpg" "home catalog mini fridge image"
Assert-Contains $index "img/catalogo-tachos-hielo-500.jpg" "home catalog ice barrel image"
Assert-Contains $index "Tachos para hielo 500 lts" "home ice barrel copy"
Assert-Contains $index "img/entrega-retiro-coldhielo.jpg" "home delivery image"
Assert-Contains $index "uso-icon" "home ideal-for icons"
Assert-Contains $index "Como funciona" "home process section"
Assert-Contains $index "Hielo para acompanar" "home ice complement section"
Assert-Contains $index $rentalQuery "home rental WhatsApp query"

Assert-Contains $servicios "freezer%20horizontal" "service freezer horizontal query"
Assert-Contains $servicios "freezer%20vertical%20exhibidor%20500%20lts" "service vertical display freezer query"
Assert-Contains $servicios "heladera%20exhibidora" "service exhibitor fridge query"
Assert-Contains $servicios "heladera%20comun" "service standard fridge query"
Assert-Contains $servicios "frigobar" "service frigobar query"
Assert-Contains $servicios "img/catalogo-freezer-horizontal.jpg" "service catalog horizontal freezer image"
Assert-Contains $servicios "Freezer horizontal 100 lts" "service horizontal 100 lts"
Assert-Contains $servicios "Freezer horizontal 300 lts" "service horizontal 300 lts"
Assert-Contains $servicios "Freezer horizontal 500 lts" "service horizontal 500 lts"
Assert-Contains $servicios "img/catalogo-freezer-vertical-exhibidor-500.jpg" "service vertical display freezer image"
Assert-Contains $servicios "Freezer vertical exhibidor 500 lts" "service vertical display freezer copy"
Assert-Contains $servicios "img/catalogo-heladera-exhibidora.jpg" "service catalog display fridge image"
Assert-Contains $servicios "img/catalogo-heladera-comun.jpg" "service catalog standard fridge image"
Assert-Contains $servicios "img/catalogo-frigobar.jpg" "service catalog mini fridge image"
Assert-Contains $servicios "Medidas orientativas: aprox. 50 x 50 x 85 cm" "service mini fridge generic dimensions"
Assert-Contains $servicios "img/catalogo-tachos-hielo-500.jpg" "service ice barrel image"
Assert-Contains $servicios "Tachos para hielo 500 lts" "service ice barrel copy"

Assert-Contains $productos $iceQuery "product ice WhatsApp query"

Assert-NotContains $contacto "colddhielo" "contact Instagram typo"
Assert-Contains $contacto "https://www.instagram.com/coldhielo" "contact Instagram URL"
Assert-Contains $contacto $rentalQuery "contact rental WhatsApp query"
Assert-Contains $nosotros $rentalQuery "about rental WhatsApp query"

Assert-Contains $css ".section-kicker" "shared section kicker styles"
Assert-Contains $css ".equipment-card" "equipment card styles"
Assert-Contains $css ".feature-card" "feature card styles"
Assert-Contains $css ".process-card" "process card styles"
Assert-Contains $css ".logo-header img" "mobile logo styles"
Assert-Contains $css ".uso-icon" "ideal-for icon styles"
Assert-Contains $css ".hero {" "site wrapper styles"
Assert-Contains $css "background: #f5f9fb;" "clean site background"
Assert-NotContains $css ".hero {`r`n  background: url('../img/background-pattern.png')" "global patterned background"

$catalogImages = @(
  "img/catalogo-freezer-horizontal.jpg",
  "img/catalogo-freezer-vertical-exhibidor-500.jpg",
  "img/catalogo-heladera-exhibidora.jpg",
  "img/catalogo-heladera-comun.jpg",
  "img/catalogo-frigobar.jpg",
  "img/catalogo-tachos-hielo-500.jpg",
  "img/entrega-retiro-coldhielo.jpg"
)

foreach ($imagePath in $catalogImages) {
  if (-not (Test-Path $imagePath)) {
    throw "Missing catalog image file: $imagePath"
  }
}

Write-Host "Static site checks passed."
