@echo off
call "%~dp0..\..\tools\commands\push-nuget.cmd" %*
exit /b %errorlevel%
