@echo off
call "%~dp0..\tools\commands\sync-icons.cmd" %*
exit /b %errorlevel%
