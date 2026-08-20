import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
export const repoRoot = path.resolve(here, '../..');
export const sourceLockPath = path.join(repoRoot, 'SOURCE-LOCK.json');
export const resourcePath = path.join(repoRoot, 'src/ShadBlazor.FreeIcon/Resources/lets-icons.json');
export const generatedPath = path.join(repoRoot, 'src/ShadBlazor.FreeIcon/Generated/FreeIcons.Generated.cs');

export function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

export function writeText(file, value) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, value.replace(/\r\n/g, '\n'), 'utf8');
}

export function pascalIdentifier(name) {
  const normalized = String(name ?? '').normalize('NFKD').replace(/[\u0300-\u036f]/g, '');
  const tokens = normalized.split(/[^A-Za-z0-9]+/).filter(Boolean);
  let value = tokens.map(token => {
    if (/^\d+[a-zA-Z]$/.test(token)) {
      return token.slice(0, -1) + token.slice(-1).toUpperCase();
    }
    return token.charAt(0).toUpperCase() + token.slice(1);
  }).join('');

  if (!value) value = 'Icon';
  if (/^\d/.test(value)) value = `Icon${value}`;
  return value;
}

export function fnv1aHex(value) {
  let hash = 0x811c9dc5;
  for (let i = 0; i < value.length; i++) {
    hash ^= value.charCodeAt(i);
    hash = Math.imul(hash, 0x01000193) >>> 0;
  }
  return hash.toString(16).padStart(8, '0').slice(0, 6).toUpperCase();
}

export function generateProperties(names) {
  const used = new Set(['Count', 'FreeIcons']);
  return names.map(name => {
    const base = pascalIdentifier(name);
    let identifier = base;
    if (used.has(identifier)) {
      identifier = `${base}_${fnv1aHex(name)}`;
    }
    let ordinal = 2;
    while (used.has(identifier)) {
      identifier = `${base}_${fnv1aHex(name)}_${ordinal++}`;
    }
    used.add(identifier);
    return { name, identifier };
  });
}

export function escapeXml(value) {
  return String(value)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;');
}

export function csharpStringLiteral(value) {
  return String(value)
    .replaceAll('\\', '\\\\')
    .replaceAll('"', '\\"')
    .replaceAll('\r', '\\r')
    .replaceAll('\n', '\\n');
}
