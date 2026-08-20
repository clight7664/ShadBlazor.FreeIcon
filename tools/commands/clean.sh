#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
node tools/quality/clean-dotnet.mjs
rm -rf artifacts preview/ShadBlazor.FreeIcon.Preview/wwwroot/css/app.css
