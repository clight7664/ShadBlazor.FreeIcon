@echo off
call "%~dp0..\tools\commands\repair.cmd" %*
exit /b %errorlevel%
