#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
node tools/quality/verify-repository.mjs
[[ -f src/ShadBlazor.FreeIcon/Resources/lets-icons.json ]] || { echo "[ERROR] Full icon catalog is missing. Run ./tools/commands/bootstrap.sh first."; exit 2; }
[[ -f src/ShadBlazor.FreeIcon/Generated/FreeIcons.Generated.cs ]] || { echo "[ERROR] Strongly typed icon API is missing. Run ./tools/commands/bootstrap.sh first."; exit 2; }
[[ -d node_modules/@tailwindcss/cli ]] || npm install --no-audit --no-fund --ignore-scripts
npm run icons:verify
npm run css:build
dotnet restore ShadBlazor.FreeIcon.sln --force-evaluate
dotnet build ShadBlazor.FreeIcon.sln -c Release --no-restore --nologo
dotnet run --project tools/ShadBlazor.FreeIcon.Verifier/ShadBlazor.FreeIcon.Verifier.csproj -c Release --no-build
