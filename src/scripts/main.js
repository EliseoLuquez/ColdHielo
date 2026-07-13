const toggle = document.querySelector(".menu-toggle");
const menu = document.querySelector("#main-menu ul");

if (toggle && menu) {
  let isOpen = false;

  const setOpen = (open) => {
    isOpen = open;
    menu.classList.toggle("active", isOpen);
    toggle.setAttribute("aria-expanded", String(isOpen));
    toggle.setAttribute("aria-label", isOpen ? "Cerrar menú" : "Abrir menú");
  };

  toggle.addEventListener("click", () => {
    setOpen(!isOpen);
  });

  for (const link of menu.querySelectorAll("a")) {
    link.addEventListener("click", () => setOpen(false));
  }

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && isOpen) {
      setOpen(false);
      toggle.focus();
    }
  });

  const desktop = window.matchMedia("(min-width: 769px)");
  desktop.addEventListener("change", (event) => {
    if (event.matches) setOpen(false);
  });
}

const catalogTabs = typeof document.querySelectorAll === "function"
  ? Array.from(document.querySelectorAll("[data-catalog-filter]"))
  : [];
const catalogItems = typeof document.querySelectorAll === "function"
  ? Array.from(document.querySelectorAll("[data-catalog-item]"))
  : [];

if (catalogTabs.length && catalogItems.length) {
  const setCatalogFilter = (activeFilter) => {
    for (const tab of catalogTabs) {
      const isActive = tab.dataset.catalogFilter === activeFilter;
      tab.classList.toggle("is-active", isActive);
      tab.setAttribute("aria-pressed", String(isActive));
    }

    for (const item of catalogItems) {
      const isVisible = item.dataset.catalogItem === activeFilter;
      item.hidden = !isVisible;
      item.classList.toggle("is-hidden", !isVisible);
    }
  };

  for (const tab of catalogTabs) {
    tab.addEventListener("click", () => {
      setCatalogFilter(tab.dataset.catalogFilter);
    });
  }

  const initialFilter = catalogTabs.find((tab) => tab.classList.contains("is-active"))?.dataset.catalogFilter;
  if (initialFilter) setCatalogFilter(initialFilter);
}
