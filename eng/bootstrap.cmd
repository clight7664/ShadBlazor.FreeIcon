@echo off
call "%~dp0..\tools\commands\bootstrap.cmd" %*
exit /b %errorlevel%
