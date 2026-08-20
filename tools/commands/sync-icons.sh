#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
[[ -f node_modules/@iconify-json/lets-icons/icons.json ]] || npm install --no-audit --no-fund --ignore-scripts
npm run icons:sync
npm run icons:verify
