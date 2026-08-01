import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import Handlebars from "handlebars";
import config, { resolvePageId } from "../vite.config.mjs";

assert.equal(resolvePageId("/INDEX.HTML"), "index");
assert.equal(resolvePageId("/servicios.html?ref=menu"), "servicios");
assert.equal(resolvePageId("/"), "index");

const source = await readFile(new URL("../index.html", import.meta.url), "utf8");
const pagesPlugin = config.plugins.find(({ name }) => name === "cold-hielo-handlebars-pages");
assert.ok(pagesPlugin, "Handlebars pages plugin must be configured");

const rendered = pagesPlugin.transformIndexHtml.handler(source, { path: "/INDEX.HTML" });

assert.match(rendered, /<title>Alquiler de Freezers y Heladeras y Venta de Hielo \| Cold Hielo<\/title>/);

Handlebars.registerPartial("head", "<head><title>STALE PARTIAL</title></head>");
const refreshed = pagesPlugin.transformIndexHtml.handler(source, { path: "/index.html" });
assert.match(refreshed, /<title>Alquiler de Freezers y Heladeras y Venta de Hielo \| Cold Hielo<\/title>/);
console.log("Vite config checks passed.");
