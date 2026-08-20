@echo off
setlocal EnableExtensions
cd /d "%~dp0\..\.."
if not exist "src\ShadBlazor.FreeIcon\Resources\lets-icons.json" (
  echo [ERROR] Full icon catalog is missing.
  echo Run: tools\commands\bootstrap.cmd
  exit /b 2
)
if not exist "node_modules\@tailwindcss\cli" (
  echo [ERROR] npm dependencies are missing.
  echo Run: tools\commands\bootstrap.cmd
  exit /b 2
)
call npm run dev
