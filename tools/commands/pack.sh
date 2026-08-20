#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
./tools/commands/build.sh
mkdir -p release/packages
dotnet pack src/ShadBlazor.FreeIcon/ShadBlazor.FreeIcon.csproj -c Release --no-build -o release/packages "$@"
