import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";

const header = await readFile(new URL("../src/partials/header.hbs", import.meta.url), "utf8");

const logo = header.match(/<img\b[^>]*\bsrc="img\/logo-coldhielo-optimizado\.png"[^>]*>/i)?.[0];
assert.ok(logo, "Header must include the Cold Hielo logo");
for (const [attribute, value] of [
  ["alt", "Cold Hielo Logo"],
  ["width", "1024"],
  ["height", "1024"],
  ["decoding", "async"]
]) {
  assert.match(logo, new RegExp(`\\b${attribute}="${value}"`), `Logo must define ${attribute}="${value}"`);
}

function eventTarget() {
  const listeners = new Map();

  return {
    addEventListener(type, handler) {
      const handlers = listeners.get(type) ?? [];
      handlers.push(handler);
      listeners.set(type, handlers);
    },
    dispatch(type, event = {}) {
      for (const handler of listeners.get(type) ?? []) {
        handler(event);
      }
    }
  };
}

const attributes = new Map([
  ["aria-expanded", "false"],
  ["aria-label", "Abrir menú"]
]);
const toggle = {
  ...eventTarget(),
  focusCalls: 0,
  getAttribute(name) {
    return attributes.get(name);
  },
  setAttribute(name, value) {
    attributes.set(name, value);
  },
  focus() {
    this.focusCalls += 1;
  }
};
const links = [eventTarget(), eventTarget()];
const menu = {
  classList: {
    active: false,
    toggle(name, force) {
      assert.equal(name, "active");
      this.active = force === undefined ? !this.active : Boolean(force);
      return this.active;
    }
  },
  querySelectorAll(selector) {
    assert.equal(selector, "a");
    return links;
  }
};
const documentEvents = eventTarget();
const mediaQuery = {
  ...eventTarget(),
  matches: false
};
const requestedSelectors = [];

globalThis.document = {
  ...documentEvents,
  querySelector(selector) {
    requestedSelectors.push(selector);
    if (selector === ".menu-toggle") return toggle;
    if (selector === "#main-menu ul") return menu;
    throw new Error(`Unexpected production selector: ${selector}`);
  }
};
globalThis.window = {
  matchMedia(query) {
    assert.equal(query, "(min-width: 769px)");
    return mediaQuery;
  }
};

await import("../src/scripts/main.js");
assert.deepEqual(requestedSelectors, [".menu-toggle", "#main-menu ul"]);

toggle.dispatch("click");
assert.equal(menu.classList.active, true);
assert.equal(toggle.getAttribute("aria-expanded"), "true");
assert.equal(toggle.getAttribute("aria-label"), "Cerrar menú");

toggle.dispatch("click");
assert.equal(menu.classList.active, false);
assert.equal(toggle.getAttribute("aria-expanded"), "false");
assert.equal(toggle.getAttribute("aria-label"), "Abrir menú");

toggle.dispatch("click");
links[0].dispatch("click");
assert.equal(menu.classList.active, false);
assert.equal(toggle.getAttribute("aria-expanded"), "false");
assert.equal(toggle.getAttribute("aria-label"), "Abrir menú");

toggle.dispatch("click");
documentEvents.dispatch("keydown", { key: "Escape" });
assert.equal(menu.classList.active, false);
assert.equal(toggle.getAttribute("aria-expanded"), "false");
assert.equal(toggle.getAttribute("aria-label"), "Abrir menú");
assert.equal(toggle.focusCalls, 1);

documentEvents.dispatch("keydown", { key: "Escape" });
assert.equal(toggle.focusCalls, 1);

toggle.dispatch("click");
mediaQuery.matches = true;
mediaQuery.dispatch("change", { matches: true });
assert.equal(menu.classList.active, false);
assert.equal(toggle.getAttribute("aria-expanded"), "false");
assert.equal(toggle.getAttribute("aria-label"), "Abrir menú");

console.log("Shared template checks passed.");
