@echo off
setlocal EnableExtensions
cd /d "%~dp0\..\.."

call tools\commands\doctor.cmd || exit /b 1

echo.
echo [1/8] Verifying repository project model...
node tools\quality\verify-repository.mjs || exit /b 1

echo [2/8] Installing pinned npm dependencies...
call npm install --no-audit --no-fund --ignore-scripts || exit /b 1

echo [3/8] Generating all 1544 Lets Icons and the strongly typed C# API...
call npm run icons:sync || exit /b 1

echo [4/8] Verifying generated icons...
call npm run icons:verify || exit /b 1

echo [5/8] Building Tailwind CSS v4...
call npm run css:build || exit /b 1

echo [6/8] Restoring the .NET solution...
dotnet restore ShadBlazor.FreeIcon.sln --force-evaluate || exit /b 1

echo [7/8] Building the complete solution...
dotnet build ShadBlazor.FreeIcon.sln -c Debug --no-restore --nologo || exit /b 1

echo [8/8] Running compiled catalog verification...
dotnet run --project tools\ShadBlazor.FreeIcon.Verifier\ShadBlazor.FreeIcon.Verifier.csproj -c Debug --no-build || exit /b 1

echo.
echo =============================================================
echo Bootstrap succeeded. The repository is ready to run.
echo Start preview: tools\commands\dev.cmd
echo URL:           http://localhost:5188
echo =============================================================
exit /b 0
