@echo off
title Time Sync Repair
color 0B

echo Time Sync Repair
echo github.com/Roddensmich
echo.

net session >nul 2>&1
if not %errorlevel%==0 (
    echo Please run this as administrator.
    pause
    exit
)

echo Stopping Windows Time service...
net stop w32time >nul 2>&1

echo Re-registering Windows Time service...
w32tm /unregister >nul 2>&1
w32tm /register >nul 2>&1

echo Starting Windows Time service...
net start w32time >nul 2>&1

echo Setting service startup mode...
sc config w32time start= auto >nul 2>&1

echo Resetting sync configuration...
w32tm /config /syncfromflags:manual /manualpeerlist:"time.windows.com pool.ntp.org" /update >nul 2>&1

echo Resyncing clock...
w32tm /resync /force

echo Flushing DNS cache...
ipconfig /flushdns >nul 2>&1

echo Restarting time provider...
net stop w32time >nul 2>&1
net start w32time >nul 2>&1

echo.
echo Current time status:
w32tm /query /status

echo.
echo Current sync source:
w32tm /query /source

echo.
echo Done.
echo Your clock should now sync correctly.
echo.

pause
