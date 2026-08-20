@echo off
call "%~dp0..\tools\commands\build.cmd" %*
exit /b %errorlevel%
