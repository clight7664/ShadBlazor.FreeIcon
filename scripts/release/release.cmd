@echo off
setlocal EnableExtensions
cd /d "%~dp0\..\.."
set "RELEASE_VERSION=%~1"
if not defined RELEASE_VERSION set "RELEASE_VERSION=1.0.0"

call tools\commands\build.cmd || exit /b 1
if not exist "release\packages" mkdir "release\packages"
dotnet pack src\ShadBlazor.FreeIcon\ShadBlazor.FreeIcon.csproj -c Release --no-build -p:PackageVersion=%RELEASE_VERSION% -o release\packages || exit /b 1
powershell -NoProfile -ExecutionPolicy Bypass -File tools\quality\verify-package.ps1 ^
  -PackagePath "release\packages\ShadBlazor.FreeIcon.%RELEASE_VERSION%.nupkg" ^
  -SymbolPackagePath "release\packages\ShadBlazor.FreeIcon.%RELEASE_VERSION%.snupkg" ^
  -ExpectedVersion "%RELEASE_VERSION%" || exit /b 1
echo Release %RELEASE_VERSION% is ready in release\packages.
exit /b 0
