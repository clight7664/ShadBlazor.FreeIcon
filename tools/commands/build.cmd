@echo off
setlocal EnableExtensions
cd /d "%~dp0\..\.."

node tools\quality\verify-repository.mjs || exit /b 1

if not exist "src\ShadBlazor.FreeIcon\Resources\lets-icons.json" (
  echo [ERROR] Full icon catalog is missing. Run tools\commands\bootstrap.cmd first.
  exit /b 2
)
if not exist "src\ShadBlazor.FreeIcon\Generated\FreeIcons.Generated.cs" (
  echo [ERROR] Strongly typed icon API is missing. Run tools\commands\bootstrap.cmd first.
  exit /b 2
)
if not exist "node_modules\@tailwindcss\cli" (
  echo [INFO] npm dependencies are missing; installing pinned dependencies...
  call npm install --no-audit --no-fund --ignore-scripts || exit /b 1
)

call npm run icons:verify || exit /b 1
call npm run css:build || exit /b 1
dotnet restore ShadBlazor.FreeIcon.sln --force-evaluate || exit /b 1
dotnet build ShadBlazor.FreeIcon.sln -c Release --no-restore --nologo || exit /b 1
dotnet run --project tools\ShadBlazor.FreeIcon.Verifier\ShadBlazor.FreeIcon.Verifier.csproj -c Release --no-build || exit /b 1
exit /b 0
