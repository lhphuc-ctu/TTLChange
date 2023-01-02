::==================================================================
::   TTL Change - Change TTL to bypass hotspot limit
::   Github: https://github.com/lhphuc-ctu
::==================================================================


::==================================================================

:: Check if it running as administator. If not, then prompt an administator request
if not "%1"=="am_admin" (
    TIMEOUT 2 > NUL
    @ECHO :: Requesting administator access...
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)

::==================================================================   

@echo off
color 07
mode 76, 30
title  TTL Change v1.0
set "tempfolder=%SystemRoot%\Temp\__TTLChange"
if exist "%tempfolder%\.*" rmdir /s /q "%tempfolder%\" %nul%

::==================================================================   

:MainMenu

cls
:: Get current TTL value from localhost
for /f "tokens=6" %%i in ('ping -n 1 127.0.0.1^|find "TTL"') do set ttl="%%i"
set ttl=%ttl:"=%

echo:
echo:       ______________________________________________________________
echo:
echo:                        TTL Change Menu:
echo:
echo:            [33m Current %ttl% [0m
echo:
echo:             [1] Using Mobile Hotspot - TTL 65
echo:             [2] Wi-Fi repeater - TTL 64
echo:             [3] Custom TTL value
echo:             [4] Set to default - TTL 128
echo:             __________________________________________________      
echo:
echo:             [5] Help
echo:             [0] Exit                                   
echo:       ______________________________________________________________
echo:
echo:            [92m Enter a menu option in the Keyboard [1,2,3,4,0] :[0m
choice /C:123450 /N
set _goto=%errorlevel%

if %_goto%==6 exit /b
if %_goto%==5 start https://github.com/lhphuc-ctu & goto :MainMenu
if %_goto%==4 goto :SetDefault
if %_goto%==3 goto :CustomTTL
if %_goto%==2 goto :WifiRepreater
if %_goto%==1 goto :Hotspot
goto :MainMenu

::========================================================================================================================================
:Hotspot

echo:             Using Mobile Hotspot:
netsh int ipv4 set glob defaultcurhoplimit=65 >NUL
netsh int ipv6 set glob defaultcurhoplimit=65 >NUL
echo:             Change TTL value sucess! 
timeout 1 >NUL
goto :MainMenu

::========================================================================================================================================
:WifiRepreater

echo:             Wi-Fi repeater
netsh int ipv4 set glob defaultcurhoplimit=64 >NUL
netsh int ipv6 set glob defaultcurhoplimit=64 >NUL
echo:             Change TTL value sucess! 
timeout 1 >NUL
goto :MainMenu

::========================================================================================================================================
:CustomTTL

echo:             Custom TTL value
echo:             Enter TTL value:                
set /p Input=""
netsh int ipv4 set glob defaultcurhoplimit=%Input% >NUL
netsh int ipv6 set glob defaultcurhoplimit=%Input% >NUL
echo:             Change TTL value sucess! 
timeout 1 >NUL
goto :MainMenu

::========================================================================================================================================
:SetDefault

echo:             Set to default
netsh int ipv4 set glob defaultcurhoplimit=128 >NUL
netsh int ipv6 set glob defaultcurhoplimit=128 >NUL
echo:             Change TTL value sucess! 
timeout 1 >NUL
goto :MainMenu

::========================================================================================================================================

pause