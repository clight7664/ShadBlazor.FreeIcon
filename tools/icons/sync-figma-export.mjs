import fs from 'node:fs';
import path from 'node:path';
import {
  repoRoot,
  readJson,
  writeText,
  sourceLockPath,
  resourcePath,
  generatedPath,
  generateProperties,
  fnv1aHex
} from './lib.mjs';

const inputArg = process.argv[2];
if (!inputArg) {
  console.error('Usage: node tools/icons/sync-figma-export.mjs <figma-export.json> [--accept-count-change]');
  process.exit(2);
}

const inputPath = path.resolve(process.cwd(), inputArg);
if (!fs.existsSync(inputPath)) {
  throw new Error(`Figma export not found: ${inputPath}`);
}

const lock = readJson(sourceLockPath);
const payload = readJson(inputPath);
if (payload.schema !== 'shadblazor-freeicon-figma-export-v1' || !Array.isArray(payload.icons)) {
  throw new Error('Unsupported Figma export schema. Re-export with tools/FigmaRawExporter.');
}

const expected = lock.figmaObservedComponentCount;
const acceptCountChange = process.argv.includes('--accept-count-change');
if (Number.isInteger(expected) && payload.icons.length !== expected && !acceptCountChange) {
  throw new Error(
    `Figma component count changed. Expected ${expected}, found ${payload.icons.length}. ` +
    'Review the upstream file, then rerun with --accept-count-change if deliberate.'
  );
}

function kebab(value) {
  const ascii = String(value ?? '')
    .normalize('NFKD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^A-Za-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .replace(/-{2,}/g, '-')
    .toLowerCase();
  return ascii || 'icon';
}

function parseSvg(svg, fallbackWidth = 24, fallbackHeight = 24) {
  if (typeof svg !== 'string' || !/^\s*<svg\b/i.test(svg)) {
    throw new Error('Figma export contains a non-SVG icon.');
  }
  const unsafePatterns = [
    /<script\b/i,
    /<foreignObject\b/i,
    /<(?:iframe|object|embed|image|audio|video|style|a)\b/i,
    /\son[a-z]+\s*=/i,
    /javascript:/i,
    /@import\b/i,
    /\b(?:href|xlink:href)\s*=\s*["'](?!#)[^"']+/i,
    /url\(\s*["']?(?!#)/i
  ];
  if (unsafePatterns.some(pattern => pattern.test(svg))) {
    throw new Error('Unsafe or externally-referencing SVG content detected in Figma export.');
  }

  const open = svg.match(/^\s*<svg\b([^>]*)>/i);
  const closeIndex = svg.toLowerCase().lastIndexOf('</svg>');
  if (!open || closeIndex < 0) throw new Error('Malformed SVG in Figma export.');

  const attrs = open[1] ?? '';
  const bodyStart = open.index + open[0].length;
  const body = svg.slice(bodyStart, closeIndex).trim();
  const viewBoxMatch = attrs.match(/\bviewBox\s*=\s*["']([^"']+)["']/i);
  let left = 0, top = 0, width = Number(fallbackWidth) || 24, height = Number(fallbackHeight) || 24;
  if (viewBoxMatch) {
    const parts = viewBoxMatch[1].trim().split(/[ ,]+/).map(Number);
    if (parts.length === 4 && parts.every(Number.isFinite)) {
      [left, top, width, height] = parts;
    }
  }
  return { body, left, top, width, height };
}

// Stable names: original normalized name; for collisions add section; if still duplicated add Figma node id hash.
const baseCounts = new Map();
for (const item of payload.icons) {
  const base = kebab(item.name);
  baseCounts.set(base, (baseCounts.get(base) ?? 0) + 1);
}

const tentative = payload.icons.map(item => {
  const base = kebab(item.name);
  let name = base;
  if ((baseCounts.get(base) ?? 0) > 1) {
    name = `${base}--${kebab(item.section ?? 'uncategorized')}`;
  }
  return { item, base, tentativeName: name };
});

const tentativeCounts = new Map();
for (const x of tentative) {
  tentativeCounts.set(x.tentativeName, (tentativeCounts.get(x.tentativeName) ?? 0) + 1);
}

const icons = {};
const categories = {};
const nameMap = [];
for (const { item, tentativeName } of tentative) {
  let name = tentativeName;
  if ((tentativeCounts.get(tentativeName) ?? 0) > 1 || icons[name]) {
    name = `${tentativeName}--${fnv1aHex(String(item.id)) .toLowerCase()}`;
  }
  while (icons[name]) {
    name = `${name}-${fnv1aHex(name + item.id).toLowerCase()}`;
  }

  const parsed = parseSvg(item.svg, item.width, item.height);
  icons[name] = {
    body: parsed.body,
    width: parsed.width,
    height: parsed.height,
    left: parsed.left,
    top: parsed.top,
    figmaComponentId: String(item.id ?? ''),
    figmaName: String(item.name ?? '')
  };

  const category = String(item.section ?? 'Uncategorized').trim() || 'Uncategorized';
  (categories[category] ??= []).push(name);
  nameMap.push({
    name,
    figmaComponentId: String(item.id ?? ''),
    figmaName: String(item.name ?? ''),
    section: category
  });
}

for (const names of Object.values(categories)) names.sort((a, b) => a.localeCompare(b));
const sortedNames = Object.keys(icons).sort((a, b) => a.localeCompare(b));
const properties = generateProperties(sortedNames);
const propertyByName = Object.fromEntries(properties.map(x => [x.name, x.identifier]));
const sortedIcons = Object.fromEntries(sortedNames.map(name => [
  name,
  { ...icons[name], csharpProperty: propertyByName[name] }
]));

const combined = {
  prefix: 'shadblazor-freeicon-figma',
  info: {
    name: 'Lets Icons — raw Figma export',
    total: sortedNames.length,
    author: { name: 'Leonid Tsvetkov' },
    license: { title: 'Creative Commons Attribution 4.0', spdx: 'CC-BY-4.0' }
  },
  source: {
    mode: 'figma-raw',
    fileKey: payload.fileKey ?? null,
    page: payload.page ?? null,
    exportedAtUtc: payload.exportedAtUtc ?? null,
    figmaCommunityFile: lock.figmaCommunityFile,
    license: lock.license
  },
  icons: sortedIcons,
  categories,
  width: 24,
  height: 24
};
writeText(resourcePath, JSON.stringify(combined, null, 2) + '\n');

const lines = [
  '// <auto-generated />',
  '// Generated by tools/icons/sync-figma-export.mjs. Do not edit by hand.',
  'namespace ShadBlazor.FreeIcon;',
  '',
  'public static partial class FreeIcons',
  '{',
  `    public const int Count = ${sortedNames.length};`,
  ''
];
for (const { name, identifier } of properties) {
  const safeSummary = name.replace(/[<&]/g, ch => ch === '<' ? '&lt;' : '&amp;');
  lines.push(`    /// <summary>Lets Icons (Figma): ${safeSummary}</summary>`);
  lines.push(`    public static FreeIconData ${identifier} => FreeIconRegistry.Get("${name}");`);
  lines.push('');
}
lines.push('}', '');
writeText(generatedPath, lines.join('\n'));

const mapPath = path.join(repoRoot, 'docs/icon-name-map.figma.json');
writeText(mapPath, JSON.stringify({ count: nameMap.length, icons: nameMap }, null, 2) + '\n');

console.log(`Imported ${sortedNames.length} Figma components.`);
console.log(`  Resource : ${path.relative(repoRoot, resourcePath)}`);
console.log(`  C# API   : ${path.relative(repoRoot, generatedPath)}`);
console.log(`  Name map : ${path.relative(repoRoot, mapPath)}`);
