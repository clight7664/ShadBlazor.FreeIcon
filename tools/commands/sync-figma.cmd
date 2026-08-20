@echo off
setlocal EnableExtensions
cd /d "%~dp0\..\.."
if "%~1"=="" (
  echo Usage: tools\commands\sync-figma.cmd export.json [--accept-count-change]
  exit /b 2
)
node tools\icons\sync-figma-export.mjs "%~1" %2 || exit /b 1
node tools\icons\verify-icons.mjs || exit /b 1
exit /b 0
