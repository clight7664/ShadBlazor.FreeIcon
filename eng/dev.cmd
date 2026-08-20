@echo off
call "%~dp0..\tools\commands\dev.cmd" %*
exit /b %errorlevel%
