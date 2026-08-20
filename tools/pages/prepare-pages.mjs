import fs from 'node:fs';
import path from 'node:path';

const publishRoot = process.argv[2];
if (!publishRoot) {
  console.error('Usage: node tools/pages/prepare-pages.mjs <published-wwwroot> [base-path]');
  process.exit(2);
}

const repository = process.env.GITHUB_REPOSITORY ?? '';
const repoName = repository.includes('/') ? repository.split('/')[1] : '';
const basePath = process.argv[3] ?? (repoName ? `/${repoName}/` : '/');
const indexPath = path.join(publishRoot, 'index.html');
if (!fs.existsSync(indexPath)) throw new Error(`index.html not found: ${indexPath}`);

let html = fs.readFileSync(indexPath, 'utf8');
html = html.replace(/<base href="[^"]*"\s*\/>/, `<base href="${basePath}" />`);
fs.writeFileSync(indexPath, html, 'utf8');
fs.writeFileSync(path.join(publishRoot, '404.html'), html, 'utf8');
fs.writeFileSync(path.join(publishRoot, '.nojekyll'), '', 'utf8');
console.log(`Prepared GitHub Pages output with base path ${basePath}`);
