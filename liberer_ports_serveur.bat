@echo off
chcp 65001 >nul
echo Liberation des ports 8081, 8090, 9083...
echo.
cd /d "%~dp0server"
powershell -ExecutionPolicy Bypass -File stop_server_ports.ps1
echo.
pause
