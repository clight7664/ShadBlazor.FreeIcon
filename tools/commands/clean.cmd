@echo off
setlocal EnableExtensions
cd /d "%~dp0\..\.."
node tools\quality\clean-dotnet.mjs || exit /b 1
if exist "artifacts" rmdir /s /q "artifacts"
if exist "preview\ShadBlazor.FreeIcon.Preview\wwwroot\css\app.css" del /q "preview\ShadBlazor.FreeIcon.Preview\wwwroot\css\app.css"
echo Clean complete. Generated icon source is intentionally preserved.
