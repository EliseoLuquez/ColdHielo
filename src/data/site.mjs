export const site = {
  name: "Cold Hielo",
  phoneDisplay: "11 3300-2956",
  phoneUrl: "https://wa.me/541133002956",
  rentalUrl: "https://wa.me/541133002956?text=Hola%2C%20quiero%20solicitar%20un%20presupuesto.%0A%0ANombre%20o%20empresa%3A%0AEquipo%20y%20cantidad%3A%0AFecha%20desde%2Fhasta%3A%0ADirecci%C3%B3n%20exacta%20y%20localidad%3A%0A%C2%BFNecesito%20hielo%3F%3A",
  iceUrl: "https://wa.me/541133002956?text=Hola%2C%20quiero%20consultar%20por%20compra%20de%20hielo.",
  instagramUrl: "https://www.instagram.com/coldhielo",
  facebookUrl: "https://www.facebook.com/coldfreezers",
  address: "Prudan 119, Ramos Mejía - Buenos Aires",
  administrationHours: "Lun a Sáb de 9 a 18 hs",
  deliveryHours: "Lunes a sábados",
  pickupHours: "8 a 14 y 17 a 22 hs (Lun a Sáb)"
};

export const navigation = [
  { id: "index", label: "Inicio", href: "index.html", mobileIcon: "home" },
  { id: "nosotros", label: "Nosotros", href: "nosotros.html", mobileIcon: "about" },
  { id: "productos", label: "Productos", href: "productos.html", mobileIcon: "products" },
  { id: "servicios", label: "Servicios", href: "servicios.html", mobileIcon: "services" },
  { id: "contacto", label: "Contacto", href: "contacto.html", mobileIcon: "contact" }
];

export const pages = {
  index: {
    id: "index",
    title: "Alquiler de Freezers y Heladeras | Cold Hielo",
    description: "Alquiler de freezers, heladeras, frigobares y tachos para hielo en CABA y Gran Buenos Aires. También venta de hielo cilíndrico, picado y barra.",
    whatsappUrl: site.rentalUrl
  },
  servicios: {
    id: "servicios",
    title: "Alquiler de Freezers y Heladeras | Cold Hielo",
    description: "Alquiler de freezers, heladeras, frigobares y tachos para hielo en CABA y Gran Buenos Aires. Equipos para eventos, comercios y necesidades temporales.",
    whatsappUrl: site.rentalUrl
  },
  productos: {
    id: "productos",
    title: "Venta de Hielo | Cold Hielo",
    description: "Venta de hielo cilíndrico, picado y en barra en Ramos Mejía. Por mayor y menor, con retiro en fábrica o reparto.",
    whatsappUrl: site.iceUrl
  },
  nosotros: {
    id: "nosotros",
    title: "Nosotros | Cold Hielo",
    description: "Conocé Cold Hielo, una empresa familiar de Ramos Mejía dedicada a la venta de hielo y alquiler de heladeras y freezers.",
    whatsappUrl: site.rentalUrl
  },
  contacto: {
    id: "contacto",
    title: "Contacto | Cold Hielo",
    description: "Contactate con Cold Hielo para pedidos de hielo o alquiler de heladeras y freezers en Ramos Mejía.",
    whatsappUrl: site.rentalUrl
  }
};

export const equipment = [
  {
    name: "Freezer horizontal 100 lts",
    description: "Opción compacta para reuniones, barras chicas y necesidades puntuales.",
    image: "img/catalogo-freezer-horizontal.jpg",
    width: 1000,
    height: 1000,
    alt: "Freezer horizontal compacto de 100 litros",
    category: "freezers",
    groupHeading: "Freezers y conservación de hielo"
  },
  {
    name: "Freezer horizontal 300 lts",
    description: "Capacidad intermedia para eventos, comercios y conservación de hielo.",
    image: "img/catalogo-freezer-horizontal.jpg",
    width: 1000,
    height: 1000,
    alt: "Freezer horizontal de 300 litros para eventos",
    category: "freezers"
  },
  {
    name: "Freezer horizontal 500 lts",
    description: "Mayor capacidad para hielo, bebidas y productos en volumen.",
    image: "img/catalogo-freezer-horizontal.jpg",
    width: 1000,
    height: 1000,
    alt: "Freezer horizontal de gran capacidad de 500 litros",
    category: "freezers"
  },
  {
    name: "Freezer vertical exhibidor 500 lts",
    description: "Frente vidriado y estantes internos para exhibir y conservar productos.",
    image: "img/catalogo-freezer-vertical-exhibidor-500.jpg",
    width: 1000,
    height: 1000,
    alt: "Freezer vertical exhibidor de 500 litros con puerta vidriada",
    category: "freezers"
  },
  {
    name: "Tachos para hielo 500 lts",
    description: "Contenedores para conservar hielo en eventos, barras, ferias y producciones.",
    image: "img/catalogo-tachos-hielo-500.jpg",
    width: 1147,
    height: 586,
    alt: "Tachos de 500 litros para conservar hielo",
    category: "accesorios"
  },
  {
    name: "Heladera común",
    description: "Ideal para bebidas, conservas y uso general en eventos o necesidades temporales.",
    image: "img/catalogo-heladera-comun.jpg",
    width: 1000,
    height: 1000,
    alt: "Heladera común para bebidas y conservas",
    category: "heladeras",
    groupHeading: "Heladeras"
  },
  {
    name: "Heladera exhibidora",
    description: "Con frente vidriado, ideal para exhibir bebidas o productos refrigerados.",
    image: "img/catalogo-heladera-exhibidora.jpg",
    width: 1000,
    height: 1000,
    alt: "Heladera exhibidora con frente vidriado",
    category: "heladeras"
  },
  {
    name: "Frigobar",
    description: "Compacto y práctico para espacios reducidos. Medidas orientativas: aprox. 50 x 50 x 85 cm.",
    image: "img/catalogo-frigobar.jpg",
    width: 1000,
    height: 1000,
    alt: "Frigobar compacto para espacios reducidos",
    category: "heladeras"
  }
];
