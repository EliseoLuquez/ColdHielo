import { readFileSync, readdirSync } from "node:fs";
import { basename, extname, resolve } from "node:path";
import Handlebars from "handlebars";
import { minify } from "html-minifier-terser";
import { defineConfig } from "vite";
import { equipment, navigation, pages, site } from "./src/data/site.mjs";

const rootDir = resolve(process.cwd());
const pageIds = ["index", "servicios", "productos", "nosotros", "contacto"];
const partialsDirectory = resolve(rootDir, "src/partials");

function registerPartials() {
  for (const file of readdirSync(partialsDirectory)) {
    if (extname(file).toLowerCase() !== ".hbs") continue;
    Handlebars.registerPartial(
      basename(file, ".hbs"),
      readFileSync(resolve(partialsDirectory, file), "utf8")
    );
  }
}

export function resolvePageId(path = "/index.html") {
  const cleanPath = path.split(/[?#]/, 1)[0].replaceAll("\\", "/").replace(/\/+$/, "");
  const requestedFile = (cleanPath.split("/").pop() || "index.html").toLowerCase();
  return requestedFile.endsWith(".html")
    ? requestedFile.slice(0, -5) || "index"
    : requestedFile || "index";
}

function handlebarsPages() {
  Handlebars.registerHelper("isCurrent", (itemId, pageId) => itemId === pageId);

  return {
    name: "cold-hielo-handlebars-pages",
    enforce: "pre",
    transformIndexHtml: {
      order: "pre",
      handler(html, context) {
        registerPartials();
        const pageId = resolvePageId(context.path);
        const page = pages[pageId];
        if (!page) throw new Error(`Missing page data for ${pageId}`);
        return Handlebars.compile(html)({ site, navigation, equipment, page });
      }
    }
  };
}

function minifyHtml() {
  return {
    name: "cold-hielo-minify-html",
    apply: "build",
    enforce: "post",
    async generateBundle(_options, bundle) {
      for (const output of Object.values(bundle)) {
        if (output.type !== "asset" || !output.fileName.endsWith(".html")) continue;
        output.source = await minify(String(output.source), {
          collapseWhitespace: true,
          minifyCSS: true,
          minifyJS: true,
          removeComments: true,
          removeRedundantAttributes: true,
          removeScriptTypeAttributes: true,
          removeStyleLinkTypeAttributes: true,
          useShortDoctype: true
        });
      }
    }
  };
}

export default defineConfig({
  base: "./",
  plugins: [handlebarsPages(), minifyHtml()],
  resolve: {
    preserveSymlinks: true
  },
  build: {
    rollupOptions: {
      input: Object.fromEntries(
        pageIds.map((pageId) => [pageId, resolve(rootDir, `${pageId}.html`)])
      )
    }
  }
});
