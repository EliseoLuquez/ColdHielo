import assert from "node:assert/strict";
import { access, readFile } from "node:fs/promises";
import { constants } from "node:fs";
import { extname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { equipment } from "../src/data/site.mjs";

const root = fileURLToPath(new URL("..", import.meta.url));
const pages = ["index", "servicios", "productos", "nosotros", "contacto"];
const heroPages = new Set(["index", "servicios", "productos", "nosotros"]);
const convertedImages = [
  "banner-index-2.webp",
  "hielo-cubo.webp",
  "hielo-picado.webp",
  "barra-hielo.webp"
];

function attributes(tag) {
  const values = new Map();
  for (const match of tag.matchAll(/\b([\w:-]+)(?:\s*=\s*(?:"([^"]*)"|'([^']*)'|([^\s>]+)))?/g)) {
    values.set(match[1].toLowerCase(), match[2] ?? match[3] ?? match[4] ?? "");
  }
  return values;
}

function imageTags(fragment) {
  return [...fragment.matchAll(/<img\b[^>]*>/gi)].map((match) => ({
    tag: match[0],
    attrs: attributes(match[0])
  }));
}

function elementContent(html, element) {
  const match = html.match(new RegExp(`<${element}\\b[^>]*>([\\s\\S]*?)<\\/${element}>`, "i"));
  assert.ok(match, `Built HTML must contain <${element}>`);
  return match[1];
}

function assertNumericDimensions(image, context) {
  assert.match(image.attrs.get("width") ?? "", /^\d+$/, `${context} must have numeric width: ${image.tag}`);
  assert.match(image.attrs.get("height") ?? "", /^\d+$/, `${context} must have numeric height: ${image.tag}`);
}

function assertLazyAsync(image, context) {
  assert.equal(image.attrs.get("loading"), "lazy", `${context} must be lazy: ${image.tag}`);
  assert.equal(image.attrs.get("decoding"), "async", `${context} must decode asynchronously: ${image.tag}`);
}

const builtPages = new Map();
for (const page of pages) {
  const html = await readFile(resolve(root, "dist", `${page}.html`), "utf8");
  builtPages.set(page, html);

  for (const image of imageTags(html)) {
    if (extname(image.attrs.get("src") ?? "").toLowerCase() !== ".svg") {
      assertNumericDimensions(image, `${page}.html image`);
    }
  }

  const mainImages = imageTags(elementContent(html, "main"));
  if (heroPages.has(page)) {
    assert.ok(mainImages.length > 0, `${page}.html must have a meaningful page image`);
    const hero = mainImages[0];
    assert.equal(hero.attrs.get("fetchpriority"), "high", `${page}.html hero must have high fetch priority`);
    assert.equal(hero.attrs.get("decoding"), "async", `${page}.html hero must decode asynchronously`);
    assert.notEqual(hero.attrs.get("loading"), "lazy", `${page}.html hero must not be lazy`);

    for (const image of mainImages.slice(1)) {
      assertLazyAsync(image, `${page}.html below-fold image`);
    }
  } else {
    assert.equal(mainImages.length, 8, "contacto.html must include the eight approved service icons");
    for (const image of mainImages) {
      assert.match(image.attrs.get("src") ?? "", /^img\/icons\//, "contacto.html icons must use the approved local icon folder");
      assertLazyAsync(image, "contacto.html service icon");
    }
  }

  const headerImage = imageTags(elementContent(html, "header"))[0];
  assert.ok(headerImage, `${page}.html must include the site logo`);
  assert.notEqual(headerImage.attrs.get("loading"), "lazy", `${page}.html logo must remain eager`);

  const footerHtml = elementContent(html, "footer");
  const footerImages = imageTags(footerHtml);
  assert.equal(footerImages.length, 0, `${page}.html social icons must be inline SVGs`);
  assert.match(footerHtml, /aria-label="Instagram de Cold Hielo"/, `${page}.html must include Instagram footer link`);
  assert.match(footerHtml, /aria-label="Facebook de Cold Hielo"/, `${page}.html must include Facebook footer link`);

  const whatsapp = imageTags(html).find(({ attrs }) => attrs.get("src")?.endsWith("icon-whatsapp.png"));
  assert.ok(whatsapp, `${page}.html must include the floating WhatsApp icon`);
  assert.notEqual(whatsapp.attrs.get("loading"), "lazy", `${page}.html WhatsApp icon must remain eager`);
}

const clientSlider = builtPages.get("index").match(/<div\s+class="slide-track">([\s\S]*?)<\/div>/i)?.[1];
assert.ok(clientSlider, "Home page must include the client-logo animation track");
const indexClientImages = imageTags(clientSlider);
assert.equal(indexClientImages.length, 16, "Home page must retain both complete client-logo animation sets");
assert.deepEqual(
  indexClientImages.slice(0, 8).map(({ attrs }) => attrs.get("alt")),
  [
    "Boca Juniors",
    "Creamfields",
    "Expoagro",
    "Lollapalooza Argentina",
    "Quilmes Rock",
    "Cafecito BA",
    "Lucullus, Asociación Gastronómica Francesa en Argentina",
    "Caminos y Sabores"
  ]
);
for (const image of indexClientImages.slice(8)) {
  assert.equal(image.attrs.get("alt"), "", `Duplicate client logo must be decorative: ${image.tag}`);
  assert.equal(image.attrs.get("aria-hidden"), "true", `Duplicate client logo must be hidden: ${image.tag}`);
}

for (const item of equipment) {
  assert.match(String(item.width ?? ""), /^\d+$/, `${item.name} must define numeric image width`);
  assert.match(String(item.height ?? ""), /^\d+$/, `${item.name} must define numeric image height`);
}

const sourceFiles = [
  ...pages.map((page) => `${page}.html`),
  "src/data/site.mjs",
  "src/partials/equipment-card.hbs",
  "src/partials/footer.hbs",
  "src/partials/header.hbs",
  "src/partials/whatsapp.hbs",
  "src/styles/base.css",
  "src/styles/components.css",
  "src/styles/layout.css",
  "src/styles/main.css",
  "src/styles/responsive.css",
  "src/styles/tokens.css",
  "src/scripts/main.js"
];
const referencedImages = new Set();
for (const file of sourceFiles) {
  const source = await readFile(resolve(root, file), "utf8");
  for (const match of source.matchAll(/(?:\.\/)?img\/[^\s"')}>]+\.(?:png|jpe?g|webp|gif|svg)/gi)) {
    referencedImages.add(match[0].replace(/^\.\//, ""));
  }
}

for (const imagePath of referencedImages) {
  await access(resolve(root, "public", imagePath), constants.R_OK);
  await access(resolve(root, "dist", imagePath), constants.R_OK);
}
for (const image of convertedImages) {
  assert.ok(referencedImages.has(`img/${image}`), `Source templates must reference img/${image}`);
  await access(resolve(root, "public", "img", image), constants.R_OK);
  await access(resolve(root, "dist", "img", image), constants.R_OK);
}

const readme = await readFile(resolve(root, "README.md"), "utf8");
const readmeImagePaths = [
  ...[...readme.matchAll(/!\[[^\]]*\]\(\s*(?:<([^>]+)>|([^\s)]+))/g)].map((match) => match[1] ?? match[2]),
  ...imageTags(readme).map(({ attrs }) => attrs.get("src"))
].filter((imagePath) => imagePath && !/^(?:[a-z][a-z\d+.-]*:|\/\/)/i.test(imagePath));

for (const imagePath of readmeImagePaths) {
  const localPath = imagePath.split(/[?#]/, 1)[0];
  await access(resolve(root, localPath), constants.R_OK);
}

await assert.rejects(access(resolve(root, "img"), constants.F_OK), "Legacy img directory must be removed");

console.log(`Image delivery checks passed for ${referencedImages.size} referenced assets.`);
