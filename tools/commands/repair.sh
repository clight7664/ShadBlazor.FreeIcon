#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
node tools/quality/clean-dotnet.mjs
node tools/quality/verify-repository.mjs
if [[ ! -f src/ShadBlazor.FreeIcon/Resources/lets-icons.json || ! -f src/ShadBlazor.FreeIcon/Generated/FreeIcons.Generated.cs ]]; then
  [[ -f node_modules/@iconify-json/lets-icons/icons.json ]] || npm install --no-audit --no-fund --ignore-scripts
  npm run icons:sync
fi
npm run icons:verify
[[ -d node_modules/@tailwindcss/cli ]] || npm install --no-audit --no-fund --ignore-scripts
npm run css:build
dotnet restore ShadBlazor.FreeIcon.sln --force-evaluate
dotnet build ShadBlazor.FreeIcon.sln -c Debug --no-restore --nologo
dotnet run --project tools/ShadBlazor.FreeIcon.Verifier/ShadBlazor.FreeIcon.Verifier.csproj -c Debug --no-build
echo "Repair succeeded."
