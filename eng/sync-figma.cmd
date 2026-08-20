@echo off
call "%~dp0..\tools\commands\sync-figma.cmd" %*
exit /b %errorlevel%
