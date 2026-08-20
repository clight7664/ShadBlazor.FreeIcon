@echo off
setlocal EnableExtensions
cd /d "%~dp0\..\.."
call tools\commands\build.cmd || exit /b 1
if not exist "release\packages" mkdir "release\packages"
dotnet pack src\ShadBlazor.FreeIcon\ShadBlazor.FreeIcon.csproj -c Release --no-build -o release\packages %* || exit /b 1
echo Packages are in release\packages
exit /b 0
