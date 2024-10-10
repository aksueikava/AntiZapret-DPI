@echo off
setlocal

:: Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as an administrator.
    pause
    exit /b
)

:: Set the BIN variable to the path of the bin directory
set BIN=%~dp0bin\

:: Define arguments for the winws.exe tool
set ARGS=--wf-tcp=443 --wf-udp=443,50000-65535 ^
--filter-udp=443 --hostlist=\"%BIN%hostlist.txt\" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=\"%BIN%quic_initial_www_google_com.bin\" --new ^
--filter-udp=50000-65535 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-fake-quic=\"%BIN%quic_initial_www_google_com.bin\" --new ^
--filter-tcp=443 --hostlist=\"%BIN%hostlist.txt\" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls=\"%BIN%tls_clienthello_www_google_com.bin\"

:: Set the service name
set SRVCNAME=AntiZapret

:: Stop the service if it is running
echo Stopping service "%SRVCNAME%"...
net stop "%SRVCNAME%" || echo Service "%SRVCNAME%" is not running or does not exist.

:: Delete the service
echo Deleting service "%SRVCNAME%"...
sc delete "%SRVCNAME%" || echo Failed to delete service "%SRVCNAME%". It may not exist.

:: Create the service with the specified parameters
echo Creating service "%SRVCNAME%"...
sc create "%SRVCNAME%" binPath= "%~dp0tools\winws.exe %ARGS%" DisplayName= "AntiZapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "AntiZapret DPI bypass software"
sc start "%SRVCNAME%"

:: Wait for user input before closing the window
pause
endlocal