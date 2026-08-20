@echo off
setlocal EnableExtensions
cd /d "%~dp0\..\.."
where node >nul 2>nul || (echo [ERROR] Node.js 20+ is required.& exit /b 2)
where npm >nul 2>nul || (echo [ERROR] npm is required.& exit /b 2)
if not exist "node_modules\@iconify-json\lets-icons\icons.json" (
  call npm install --no-audit --no-fund --ignore-scripts || exit /b 1
)
call npm run icons:sync || exit /b 1
call npm run icons:verify || exit /b 1
exit /b 0
