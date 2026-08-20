@echo off
call "%~dp0..\..\tools\commands\pack.cmd" %*
exit /b %errorlevel%
