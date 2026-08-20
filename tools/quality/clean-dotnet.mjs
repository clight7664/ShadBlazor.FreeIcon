import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, '../..');
const skip = new Set(['.git', 'node_modules', 'artifacts']);
let removed = 0;

function walk(directory) {
  for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const full = path.join(directory, entry.name);
    if (entry.name === 'bin' || entry.name === 'obj') {
      fs.rmSync(full, { recursive: true, force: true });
      removed++;
      continue;
    }
    if (!skip.has(entry.name)) walk(full);
  }
}

walk(root);
console.log(`Removed ${removed} bin/obj directories.`);
