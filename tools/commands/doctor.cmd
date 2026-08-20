@echo off
setlocal EnableExtensions EnableDelayedExpansion

title ShadBlazor.FreeIcon Environment Doctor

echo.
echo ShadBlazor.FreeIcon environment doctor
echo ======================================
echo.

set FAILED=0

REM =====================================================
REM Current directory
REM =====================================================

set ROOT=%~dp0..\..\

cd /d "%ROOT%"

echo [INFO] Repository:
echo %CD%
echo.


REM =====================================================
REM Check dotnet
REM =====================================================

echo [CHECK] .NET SDK

where dotnet >nul 2>nul

if errorlevel 1 (
    echo [FAIL] dotnet not found
    set FAILED=1
) else (

    for /f "tokens=1" %%i in ('dotnet --version') do (
        set DOTNET_VERSION=%%i
    )


    echo [INFO] Selected SDK: !DOTNET_VERSION!


    echo !DOTNET_VERSION! | findstr /r "^10\." >nul

    if errorlevel 1 (
        echo [FAIL] Selected SDK must be .NET 10.x
        echo [INFO] Install .NET 10 SDK or update global.json
        set FAILED=1
    ) else (
        echo [ OK ] .NET SDK !DOTNET_VERSION!
    )
)

echo.


REM =====================================================
REM Check global.json
REM =====================================================

echo [CHECK] global.json

if exist "%ROOT%\global.json" (

    echo [ OK ] global.json found

    findstr "10.0" "%ROOT%\global.json" >nul

    if errorlevel 1 (
        echo [WARN] global.json does not lock .NET 10
    )

) else (

    echo [WARN] global.json missing
    echo [INFO] Recommended:

    echo {
    echo   "sdk": {
    echo     "version": "10.0.400",
    echo     "rollForward": "latestPatch"
    echo   }
    echo }

)

echo.


REM =====================================================
REM Check node
REM =====================================================

echo [CHECK] Node.js

where node >nul 2>nul

if errorlevel 1 (

    echo [FAIL] node not found
    set FAILED=1

) else (

    for /f %%i in ('node --version') do set NODE_VERSION=%%i

    echo [ OK ] Node !NODE_VERSION!

)

echo.


REM =====================================================
REM Check npm
REM =====================================================

echo [CHECK] npm

where npm >nul 2>nul

if errorlevel 1 (

    echo [FAIL] npm not found
    set FAILED=1

) else (

    for /f %%i in ('npm --version') do set NPM_VERSION=%%i

    echo [ OK ] npm !NPM_VERSION!

)

echo.


REM =====================================================
REM Check git
REM =====================================================

echo [CHECK] Git

where git >nul 2>nul

if errorlevel 1 (

    echo [FAIL] git not found
    set FAILED=1

) else (

    for /f "tokens=*" %%i in ('git --version') do (
        echo [ OK ] %%i
    )

)

echo.


REM =====================================================
REM Check solution
REM =====================================================

echo [CHECK] Solution

if exist "%ROOT%\ShadBlazor.FreeIcon.sln" (

    echo [ OK ] Solution found

) else (

    echo [FAIL] ShadBlazor.FreeIcon.sln missing
    set FAILED=1

)

echo.


REM =====================================================
REM Check source project
REM =====================================================

echo [CHECK] Library project

if exist "%ROOT%\src\ShadBlazor.FreeIcon\ShadBlazor.FreeIcon.csproj" (

    echo [ OK ] Library project

) else (

    echo [FAIL] Library project missing
    set FAILED=1

)

echo.


REM =====================================================
REM Check preview project
REM =====================================================

echo [CHECK] Preview project

if exist "%ROOT%\preview\ShadBlazor.FreeIcon.Preview\ShadBlazor.FreeIcon.Preview.csproj" (

    echo [ OK ] Blazor WASM Preview

) else (

    echo [FAIL] Preview project missing
    set FAILED=1

)

echo.


REM =====================================================
REM Check package.json
REM =====================================================

echo [CHECK] Frontend tooling

if exist "%ROOT%\package.json" (

    echo [ OK ] package.json

) else (

    echo [WARN] package.json missing

)

echo.


REM =====================================================
REM Check node_modules
REM =====================================================

if exist "%ROOT%\node_modules" (

    echo [ OK ] node_modules installed

) else (

    echo [INFO] node_modules not installed
    echo [INFO] Run bootstrap.cmd

)

echo.


REM =====================================================
REM Check icon source
REM =====================================================

echo [CHECK] Icon source


if exist "%ROOT%\src\ShadBlazor.FreeIcon\Resources\lets-icons.json" (

    echo [ OK ] Icon JSON exists

) else (

    echo [INFO] Icon JSON not generated
    echo [INFO] bootstrap will generate 1544 icons

)


echo.


REM =====================================================
REM Check generated C#
REM =====================================================

echo [CHECK] Generated API


if exist "%ROOT%\src\ShadBlazor.FreeIcon\Generated\FreeIcons.Generated.cs" (

    echo [ OK ] Generated FreeIcons API

) else (

    echo [INFO] Generated API missing
    echo [INFO] bootstrap will generate it

)


echo.


REM =====================================================
REM Check Tailwind
REM =====================================================

echo [CHECK] Tailwind


if exist "%ROOT%\tailwind.config.js" (

    echo [ OK ] Tailwind config

) else (

    echo [INFO] Tailwind config not found

)


echo.


REM =====================================================
REM Result
REM =====================================================


if "%FAILED%"=="1" (

    echo.
    echo ======================================
    echo Doctor FAILED
    echo ======================================
    echo.

    exit /b 1

)


echo.
echo ======================================
echo Doctor PASSED
echo ======================================
echo.

exit /b 0