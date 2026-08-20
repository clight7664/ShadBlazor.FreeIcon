#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
if [[ $# -lt 1 ]]; then
  echo "Usage: ./tools/commands/sync-figma.sh export.json [--accept-count-change]"
  exit 2
fi
node tools/icons/sync-figma-export.mjs "$@"
node tools/icons/verify-icons.mjs
