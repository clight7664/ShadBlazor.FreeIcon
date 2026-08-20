import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, '../..');
const read = relative => fs.readFileSync(path.join(root, relative), 'utf8');
const fail = message => { throw new Error(message); };

const libraryProject = read('src/ShadBlazor.FreeIcon/ShadBlazor.FreeIcon.csproj');
if (!libraryProject.includes('Sdk="Microsoft.NET.Sdk.Razor"')) fail('Library must use Microsoft.NET.Sdk.Razor.');
if (!libraryProject.includes('<SupportedPlatform Include="browser"')) fail('RCL must declare browser SupportedPlatform.');
if (!libraryProject.includes('PackageReference Include="Microsoft.AspNetCore.Components.Web"')) fail('RCL must reference Microsoft.AspNetCore.Components.Web.');
if (/FrameworkReference\s+Include="Microsoft\.AspNetCore\.App"/.test(libraryProject)) {
  fail('RCL must not reference Microsoft.AspNetCore.App; it breaks browser-wasm with NETSDK1082.');
}

const previewProject = read('preview/ShadBlazor.FreeIcon.Preview/ShadBlazor.FreeIcon.Preview.csproj');
if (!previewProject.includes('Sdk="Microsoft.NET.Sdk.BlazorWebAssembly"')) fail('Preview must use Microsoft.NET.Sdk.BlazorWebAssembly.');
if (!previewProject.includes('<TargetFramework>net10.0</TargetFramework>')) fail('Preview must target net10.0.');

const catalogSource = read('src/ShadBlazor.FreeIcon/Internal/FreeIconCatalog.cs');
if (catalogSource.includes('out var categories)') && catalogSource.includes('var categories =')) {
  fail('FreeIconCatalog contains the categories local-variable shadowing pattern.');
}

const packageJson = JSON.parse(read('package.json'));
if (packageJson.devDependencies?.['@iconify-json/lets-icons'] !== '1.2.2') fail('Lets Icons dependency must remain pinned to 1.2.2 unless SOURCE-LOCK is updated.');
if (packageJson.devDependencies?.tailwindcss !== '4.3.3') fail('Tailwind CSS must remain pinned to 4.3.3 until deliberately upgraded.');

console.log('Repository project-model checks passed.');
