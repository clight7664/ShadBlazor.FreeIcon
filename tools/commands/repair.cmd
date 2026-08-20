@echo off
setlocal EnableExtensions
cd /d "%~dp0\..\.."

echo [1/7] Removing bin/obj directories...
node tools\quality\clean-dotnet.mjs || exit /b 1

echo [2/7] Verifying project model...
node tools\quality\verify-repository.mjs || exit /b 1

if not exist "src\ShadBlazor.FreeIcon\Resources\lets-icons.json" goto :regenerate
if not exist "src\ShadBlazor.FreeIcon\Generated\FreeIcons.Generated.cs" goto :regenerate
goto :generated_ok

:regenerate
echo [3/7] Generated icon artifacts are missing; restoring them...
if not exist "node_modules\@iconify-json\lets-icons\icons.json" (
  call npm install --no-audit --no-fund --ignore-scripts || exit /b 1
)
call npm run icons:sync || exit /b 1
call npm run icons:verify || exit /b 1
goto :after_generate

:generated_ok
echo [3/7] Generated icon artifacts already exist.
call npm run icons:verify || exit /b 1

:after_generate
echo [4/7] Building Tailwind CSS...
if not exist "node_modules\@tailwindcss\cli" (
  call npm install --no-audit --no-fund --ignore-scripts || exit /b 1
)
call npm run css:build || exit /b 1

echo [5/7] Restoring...
dotnet restore ShadBlazor.FreeIcon.sln --force-evaluate || exit /b 1

echo [6/7] Building library, preview, and verifier...
dotnet build ShadBlazor.FreeIcon.sln -c Debug --no-restore --nologo || exit /b 1

echo [7/7] Running compiled catalog verifier...
dotnet run --project tools\ShadBlazor.FreeIcon.Verifier\ShadBlazor.FreeIcon.Verifier.csproj -c Debug --no-build || exit /b 1

echo.
echo Repair succeeded.
exit /b 0
