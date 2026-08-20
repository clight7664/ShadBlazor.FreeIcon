@echo off
call "%~dp0..\tools\commands\clean.cmd" %*
exit /b %errorlevel%
