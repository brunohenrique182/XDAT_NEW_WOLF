@echo off
setlocal
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-modern-schema.ps1"
if errorlevel 1 (
    echo.
    echo Failed to install the modern XDAT schema.
    pause
    exit /b 1
)
echo.
pause
