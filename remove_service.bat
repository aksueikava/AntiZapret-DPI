@echo off
setlocal

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as an administrator.
    pause
    exit /b
)

set SRVCNAME=AntiZapret

echo Stopping service "%SRVCNAME%"...
net stop "%SRVCNAME%" >nul 2>&1
if errorlevel 1 (
    echo Service "%SRVCNAME%" is not running or does not exist.
)

echo Deleting service "%SRVCNAME%"...
sc delete "%SRVCNAME%" >nul 2>&1
if errorlevel 1 (
    echo Failed to delete service "%SRVCNAME%". It may not exist.
)

endlocal