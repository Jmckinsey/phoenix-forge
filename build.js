// Netlify runs this on every publish. It gathers the one-file-per-knife and
// one-file-per-post entries from the editor into the lists the website reads.
const fs = require("fs");
const path = require("path");

function readFolder(dir) {
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir).filter(f => f.endsWith(".json")).map(f => {
    try { return JSON.parse(fs.readFileSync(path.join(dir, f), "utf8")); }
    catch (e) { console.warn(`Skipping ${dir}/${f}: ${e.message}`); return null; }
  }).filter(Boolean);
}
const num = v => (v === "" || v == null || isNaN(+v)) ? Infinity : +v;
const day = v => String(v || "9999-99-99").slice(0, 10); // no date = brand new, show first

const knives = readFolder("content/knives").sort((a, b) =>
  num(a.order) - num(b.order) || day(b.date).localeCompare(day(a.date)) || String(a.name).localeCompare(String(b.name)));
const posts = readFolder("content/posts").sort((a, b) => day(b.date).localeCompare(day(a.date)));

fs.mkdirSync("data", { recursive: true });
fs.writeFileSync("data/knives.json", JSON.stringify({ knives }, null, 2));
fs.writeFileSync("data/posts.json", JSON.stringify({ posts }, null, 2));
console.log(`Built ${knives.length} knives and ${posts.length} posts.`);
