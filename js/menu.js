const toggle = document.querySelector('.menu-toggle');
const menu = document.getElementById('mainMenu');

if (toggle && menu) {
  const setOpen = (open) => {
    menu.classList.toggle('active', open);
    toggle.setAttribute('aria-expanded', String(open));
    toggle.setAttribute('aria-label', open ? 'Cerrar menú' : 'Abrir menú');
  };
  toggle.addEventListener('click', () => setOpen(toggle.getAttribute('aria-expanded') !== 'true'));
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && toggle.getAttribute('aria-expanded') === 'true') {
      setOpen(false);
      toggle.focus();
    }
  });
  document.addEventListener('click', (event) => {
    if (!event.target.closest('header')) setOpen(false);
  });
  menu.addEventListener('click', (event) => {
    if (event.target.closest('a')) setOpen(false);
  });
  window.matchMedia('(min-width: 992px)').addEventListener('change', () => setOpen(false));
}

const pauseLogos = document.querySelector('.clientes-pausa');
const logos = document.querySelector('.slide-track');
if (pauseLogos && logos) {
  pauseLogos.hidden = false;
  pauseLogos.addEventListener('click', () => {
    const paused = pauseLogos.getAttribute('aria-pressed') !== 'true';
    logos.classList.toggle('is-paused', paused);
    pauseLogos.setAttribute('aria-pressed', String(paused));
    pauseLogos.textContent = paused ? 'Reanudar logos' : 'Pausar logos';
  });
}
