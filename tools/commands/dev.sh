#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
[[ -f src/ShadBlazor.FreeIcon/Resources/lets-icons.json ]] || { echo "Run ./tools/commands/bootstrap.sh first"; exit 2; }
npm run dev
