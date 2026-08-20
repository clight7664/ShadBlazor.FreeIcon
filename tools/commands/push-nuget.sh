#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
release_version="${1:-1.0.0}"
push_api_key="${2:-${NUGET_API_KEY:-}}"
push_source="${3:-https://api.nuget.org/v3/index.json}"

if [[ -z "$push_api_key" ]]; then
  echo '[ERROR] NuGet API key is missing. Set NUGET_API_KEY or pass it as the second argument.' >&2
  exit 2
fi

package_path="release/packages/ShadBlazor.FreeIcon.${release_version}.nupkg"
symbol_path="release/packages/ShadBlazor.FreeIcon.${release_version}.snupkg"
[[ -f "$package_path" ]] || { echo "[ERROR] $package_path does not exist." >&2; exit 2; }
[[ -f "$symbol_path" ]] || { echo "[ERROR] $symbol_path does not exist." >&2; exit 2; }
dotnet nuget push "$package_path" --api-key "$push_api_key" --source "$push_source" --skip-duplicate
