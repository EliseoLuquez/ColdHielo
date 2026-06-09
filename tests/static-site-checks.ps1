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

Assert-Contains $index "Alquiler de Freezers y Heladeras | Cold Hielo Ramos Mejia" "home title"
Assert-Contains $index "Consultar alquiler" "home primary CTA"
Assert-Contains $index "Equipos destacados" "home equipment section"
Assert-Contains $index "Como funciona" "home process section"
Assert-Contains $index "Hielo para acompanar" "home ice complement section"
Assert-Contains $index $rentalQuery "home rental WhatsApp query"

Assert-Contains $servicios "freezer%20horizontal" "service freezer horizontal query"
Assert-Contains $servicios "freezer%20vertical" "service freezer vertical query"
Assert-Contains $servicios "heladera%20exhibidora" "service exhibitor fridge query"
Assert-Contains $servicios "heladera%20comun" "service standard fridge query"
Assert-Contains $servicios "frigobar" "service frigobar query"

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

Write-Host "Static site checks passed."
