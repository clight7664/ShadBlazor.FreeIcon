#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
command -v dotnet >/dev/null || { echo "[FAIL] dotnet not found"; exit 1; }
command -v node >/dev/null || { echo "[FAIL] node not found"; exit 1; }
command -v npm >/dev/null || { echo "[FAIL] npm not found"; exit 1; }
echo "[ OK ] dotnet $(dotnet --version)"
echo "[ OK ] node $(node --version)"
echo "[ OK ] npm $(npm --version)"
[[ "$(dotnet --version)" == 10.* ]] || { echo "[FAIL] Selected SDK must be .NET 10.x"; exit 1; }
