# Cold Hielo

Sitio web de Cold Hielo para promocionar el alquiler de freezers, heladeras, frigobares y tachos para hielo, junto con la venta de hielo en CABA y Gran Buenos Aires.

## Sitio publicado

[https://eliseoluquez.github.io/ColdHielo/](https://eliseoluquez.github.io/ColdHielo/)

## Tecnologias

- Vite 5
- Handlebars
- HTML5, CSS y JavaScript
- Bootstrap 5 CSS
- GitHub Pages

## Desarrollo local

Requiere Node.js 20 o una version compatible.

```bash
npm install
npm run dev
```

Vite mostrara en la terminal la URL local del sitio.

## Verificacion y produccion

```bash
npm test
npm run build
npm run preview
```

La version de produccion se genera en `dist/`. `npm test` compila el sitio y verifica contenido, plantillas compartidas, accesibilidad, imagenes y configuracion de despliegue.

## Publicacion

Cada push a `main` ejecuta `.github/workflows/deploy-pages.yml`, valida el sitio y publica `dist/`.

En GitHub, la fuente de Pages debe configurarse una sola vez en:

1. `Settings` > `Pages`.
2. En `Build and deployment`, seleccionar `GitHub Actions`.

Tambien se puede iniciar una publicacion manual desde la pestaña `Actions`, workflow `Deploy GitHub Pages`.

## Vista previa

<img src="public/img/hielo-cubo.webp" alt="Bolsa de hielo cilíndrico de Cold Hielo" width="300">

## Contacto

Cold Hielo

Prudan 119, Ramos Mejia

WhatsApp: [11 3300-2956](https://wa.me/541133002956)
