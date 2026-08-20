@echo off
call "%~dp0..\tools\commands\doctor.cmd" %*
exit /b %errorlevel%
