@echo off
setlocal EnableExtensions
cd /d "%~dp0\..\.."
set "RELEASE_VERSION=%~1"
if not defined RELEASE_VERSION set "RELEASE_VERSION=1.0.0"
set "PUSH_API_KEY=%~2"
if not defined PUSH_API_KEY set "PUSH_API_KEY=%NUGET_API_KEY%"
set "PUSH_SOURCE=%~3"
if not defined PUSH_SOURCE set "PUSH_SOURCE=https://api.nuget.org/v3/index.json"

if not defined PUSH_API_KEY (
  echo [ERROR] NuGet API key is missing. Set NUGET_API_KEY or pass it as the second argument.
  exit /b 2
)
set "PACKAGE_PATH=release\packages\ShadBlazor.FreeIcon.%RELEASE_VERSION%.nupkg"
set "SYMBOL_PATH=release\packages\ShadBlazor.FreeIcon.%RELEASE_VERSION%.snupkg"
if not exist "%PACKAGE_PATH%" (
  echo [ERROR] %PACKAGE_PATH% does not exist. Run scripts\release\release.cmd %RELEASE_VERSION% first.
  exit /b 2
)
if not exist "%SYMBOL_PATH%" (
  echo [ERROR] %SYMBOL_PATH% does not exist. Run scripts\release\release.cmd %RELEASE_VERSION% first.
  exit /b 2
)

dotnet nuget push "%PACKAGE_PATH%" --api-key "%PUSH_API_KEY%" --source "%PUSH_SOURCE%" --skip-duplicate || exit /b 1
exit /b 0
