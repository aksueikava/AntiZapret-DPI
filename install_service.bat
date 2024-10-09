@echo off
setlocal

set ARGS=--wf-tcp=443-65535 --wf-udp=443-65535 ^
--wf-tcp=80,443,50000-65535 --wf-udp=443,50000-65535 ^
--filter-udp=443 --hostlist=\"%~dp0bin\list-general.txt\" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=50000-65535 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist=\"%~dp0bin\list-general.txt\" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--dpi-desync=fake,disorder2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig

set SRVCNAME=AntiZapret

echo Stopping service "%SRVCNAME%"...
net stop "%SRVCNAME%" || echo Service "%SRVCNAME%" is not running or does not exist.

echo Deleting service "%SRVCNAME%"...
sc delete "%SRVCNAME%" || echo Failed to delete service "%SRVCNAME%". It may not exist.

echo Creating service "%SRVCNAME%"...
sc create "%SRVCNAME%" binPath= "%~dp0tools\winws.exe %ARGS%" DisplayName= "AntiZapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "AntiZapret DPI bypass software"
sc start "%SRVCNAME%"

endlocal