# Cold Hielo - Diseno de optimizacion frontend

## Objetivo

Reestructurar el sitio estatico de Cold Hielo para mejorar rendimiento, mantenimiento, accesibilidad y comportamiento responsive sin cambiar su identidad visual ni su contenido comercial principal.

## Estado actual

El sitio contiene cinco paginas HTML, una hoja CSS de mas de mil lineas y JavaScript minimo. Header, navegacion, WhatsApp, footer y parte de los scripts se repiten en cada pagina. Varias imagenes PNG usadas en contenido pesan entre 1 MB y 3 MB, no tienen dimensiones explicitas y se cargan sin una estrategia consistente. Tambien hay estilos inline, semantica incompleta, controles del menu movil sin comportamiento accesible y selectores CSS redundantes.

## Arquitectura aprobada

- Usar Vite como herramienta de desarrollo y compilacion.
- Mantener un sitio multipagina compuesto por Inicio, Servicios, Productos, Nosotros y Contacto.
- Usar Handlebars para generar HTML estatico mediante layouts, parciales y datos compartidos.
- No incorporar React ni renderizado del lado del cliente para contenido estructural.
- Generar la version publicable en `dist/`.
- Publicar `dist/` en GitHub Pages mediante GitHub Actions.

## Organizacion propuesta

- `src/pages/`: contenido especifico de cada pagina.
- `src/partials/`: head, header, navegacion, WhatsApp flotante y footer.
- `src/data/`: navegacion, informacion de contacto, enlaces de WhatsApp y catalogo reutilizable.
- `src/styles/`: tokens, base, layout, componentes y responsive.
- `src/scripts/`: comportamiento accesible del menu y otras interacciones estrictamente necesarias.
- `public/img/`: recursos visuales optimizados y conservados por Vite.
- `tests/`: verificaciones sobre el HTML compilado y sus recursos.

Los nombres finales pueden ajustarse a las convenciones del plugin de Handlebars elegido, pero se conservaran estas responsabilidades.

## Rendimiento

- Convertir imagenes fotograficas pesadas a WebP y, cuando resulte util, AVIF.
- Mantener PNG solo cuando la transparencia o la calidad visual lo justifiquen.
- Definir `width` y `height` o `aspect-ratio` para evitar layout shift.
- Cargar con prioridad la imagen principal de cada pagina.
- Aplicar `loading="lazy"` y `decoding="async"` a imagenes fuera del primer viewport.
- Eliminar recursos sin uso solamente despues de verificar que no tengan referencias en HTML, CSS o JavaScript.
- Minificar HTML, CSS y JavaScript durante el build de produccion.
- Reducir CSS duplicado y limitar Bootstrap a lo que el proyecto realmente necesita cuando el beneficio supere el costo de migracion.
- Evitar scripts bloqueantes y diferir el JavaScript propio.

## Limpieza y DRY

- Generar una sola fuente para header, navegacion, footer, datos comerciales y enlaces frecuentes.
- Centralizar el mensaje prearmado de WhatsApp para alquileres y conservar separado el mensaje de compra de hielo.
- Sustituir estilos inline por clases con nombres orientados a su funcion.
- Eliminar reglas CSS muertas, duplicadas o anuladas por cascada.
- Reemplazar scripts inline repetidos por un unico modulo.
- Mantener el catalogo de equipos basado en datos cuando dos o mas paginas reutilicen la misma informacion.

## Accesibilidad

- Incorporar `<main>` y landmarks coherentes en todas las paginas.
- Mantener un unico `h1` por pagina y una jerarquia de encabezados predecible.
- Implementar el menu movil con `<button>`, nombre accesible, `aria-controls` y `aria-expanded` sincronizado.
- Permitir uso por teclado, cierre con Escape y devolucion del foco cuando corresponda.
- Agregar estilos `:focus-visible` perceptibles.
- Revisar contraste de texto, botones, enlaces y overlays contra WCAG AA basico.
- Usar textos alternativos descriptivos; marcar como decorativas las imagenes que no aporten contenido.
- Agregar `rel="noopener noreferrer"` a enlaces externos que abran otra pestana.
- Dar nombres accesibles especificos a enlaces de redes y WhatsApp.

## Responsividad

- Verificar 360 px, 768 px y escritorio amplio como minimo.
- Evitar desbordes horizontales, superposiciones y texto recortado.
- Reservar dimensiones estables para banners, catalogo, logos y controles.
- Mantener areas tactiles de al menos 44 por 44 px en controles principales.
- Asegurar que el boton flotante de WhatsApp no oculte CTA, texto ni controles.
- Ajustar tablas, grillas, galerias y encabezados mediante limites responsivos estables, sin escalar tipografia directamente con el ancho del viewport.

## Alcance por pagina

### Inicio

Optimizar el hero y su LCP, catalogo destacado, logos de clientes, CTA y estructura semantica. Las imagenes repetidas del carrusel visual no duplicaran contenido accesible.

### Servicios

Generar las tarjetas de equipos desde datos compartidos, mantener capacidades y disponibilidad, y corregir semantica y carga de imagenes.

### Productos

Optimizar las imagenes de hielo, separar contenido informativo de CTA y conservar el mensaje especifico de compra por WhatsApp.

### Nosotros

Optimizar la galeria de eventos, mejorar textos alternativos y cargar las fotografias fuera del primer viewport de forma diferida.

### Contacto

Mejorar landmarks, enlaces, mapa embebido, titulo del iframe y carga diferida. Mantener visibles los medios de contacto y horarios.

## Pruebas y verificacion

- Build de produccion de Vite sin errores.
- Verificaciones automaticas de paginas generadas, enlaces internos, recursos existentes y mensajes de WhatsApp.
- Comprobaciones basicas de landmarks, `h1`, atributos de imagenes y controles del menu.
- Revision de consola sin errores relevantes.
- Prueba del menu y CTA principal.
- Capturas de escritorio y movil para cada plantilla representativa.
- Auditoria Lighthouse antes y despues, usando el mismo entorno y viewport, con especial atencion a LCP, CLS, accesibilidad y peso transferido.

## Criterios de aceptacion

- Las cinco rutas conservan contenido, identidad y navegacion funcional.
- Header y footer provienen de parciales compartidos.
- El sitio se compila a HTML estatico y puede publicarse en GitHub Pages.
- No quedan imagenes de contenido pesadas sin evaluacion ni dimensiones reservadas.
- No hay desborde horizontal en los viewports definidos.
- Menu movil y enlaces principales funcionan con teclado y tacto.
- Las pruebas existentes, adaptadas al build, y las nuevas verificaciones pasan.
- El rendimiento mejora de forma medible sin una regresion visual importante.

## Fuera de alcance

- Redisenar la marca o cambiar la estrategia comercial.
- Incorporar un CMS, backend, pagos o base de datos.
- Reemplazar fotografias por una nueva produccion profesional.
- Garantizar una puntuacion Lighthouse fija, porque depende del entorno de medicion y de servicios externos.
