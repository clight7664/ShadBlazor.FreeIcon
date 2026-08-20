#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
./tools/commands/doctor.sh
node tools/quality/verify-repository.mjs
npm install --no-audit --no-fund --ignore-scripts
npm run icons:sync
npm run icons:verify
npm run css:build
dotnet restore ShadBlazor.FreeIcon.sln --force-evaluate
dotnet build ShadBlazor.FreeIcon.sln -c Debug --no-restore --nologo
dotnet run --project tools/ShadBlazor.FreeIcon.Verifier/ShadBlazor.FreeIcon.Verifier.csproj -c Debug --no-build
echo "Bootstrap succeeded. Run ./tools/commands/dev.sh"
