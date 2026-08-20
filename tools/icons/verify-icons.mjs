import fs from 'node:fs';
import {
  readJson,
  sourceLockPath,
  resourcePath,
  generatedPath,
  generateProperties
} from './lib.mjs';

const lock = readJson(sourceLockPath);
if (!fs.existsSync(resourcePath) || !fs.existsSync(generatedPath)) {
  console.error('Generated icon artifacts are missing. Run tools\\commands\\bootstrap.cmd or ./tools/commands/bootstrap.sh.');
  process.exit(2);
}

const catalog = readJson(resourcePath);
const names = Object.keys(catalog.icons ?? {}).sort((a, b) => a.localeCompare(b));
const sourceMode = catalog.source?.mode ?? 'canonical';
const expectedCount = sourceMode === 'figma-raw'
  ? lock.figmaObservedComponentCount
  : lock.expectedCanonicalIconCount;
if (Number.isInteger(expectedCount) && names.length !== expectedCount) {
  throw new Error(`Expected ${expectedCount} icons for ${sourceMode}, found ${names.length}.`);
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
for (const [name, icon] of Object.entries(catalog.icons)) {
  const body = icon.body ?? '';
  for (const pattern of unsafePatterns) {
    if (pattern.test(body)) throw new Error(`Unsafe SVG pattern ${pattern} found in ${name}.`);
  }
}

const properties = generateProperties(names);
const uniqueIdentifiers = new Set(properties.map(x => x.identifier));
if (uniqueIdentifiers.size !== names.length) {
  throw new Error('Generated C# identifiers are not unique.');
}

const generated = fs.readFileSync(generatedPath, 'utf8');
const countMatch = generated.match(/public const int Count = (\d+);/);
if (!countMatch || Number(countMatch[1]) !== names.length) {
  throw new Error('Generated C# Count does not match the JSON catalog.');
}

console.log(`Verified ${names.length} icons (${sourceMode}).`);
console.log(`Categories: ${Object.keys(catalog.categories ?? {}).length}`);
console.log('SVG safety checks: passed');
console.log('Generated identifier uniqueness: passed');
