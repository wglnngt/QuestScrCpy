@echo off
if not defined ADB set ADB=adb
if not defined VLC set "VLC=start "" vlc --qt-start-minimized "
if not defined SNDCPY_APK set SNDCPY_APK=sndcpy.apk
if not defined SNDCPY_PORT set SNDCPY_PORT=28200

if not "%1"=="" (
    set serial=-s %1
    echo Waiting for device %1...
) else (
    echo Waiting for device...
)

%ADB% %serial% wait-for-device || goto :error
%ADB% %serial% install -t -r -g %SNDCPY_APK% || (
    echo Uninstalling existing version first...
    %ADB% %serial% uninstall com.rom1v.sndcpy || goto :error
    %ADB% %serial% install -t -g %SNDCPY_APK% || goto :error
)

%ADB% %serial% forward --remove-all
%ADB% %serial% shell appops set com.rom1v.sndcpy PROJECT_MEDIA allow
%ADB% %serial% forward tcp:%SNDCPY_PORT% localabstract:sndcpy || goto :error
%ADB% %serial% shell am start com.rom1v.sndcpy/.MainActivity || goto :error

for /f "delims=" %%i in ('adb shell "ps -A | grep sndcpy"') do set "PROC=%%i"
echo,"%PROC%"
if "%PROC%" EQU "" (
	echo,Process not running...
	call %~s0
	Exit /b 0
) else (
	echo,Process already running...
)

timeout 5

echo Playing audio...
REM %VLC%
REM %VLC% -I dummy --demux rawaud --network-caching=0 --play-and-exit tcp://localhost:%SNDCPY_PORT%
REM ffplay -hide_banner -probesize 32 -f s16le -ar 48k -ac 2 -sync ext -showmode 1 -i tcp://localhost:%SNDCPY_PORT%
REM ffplay -hide_banner -fflags nobuffer -f s16le -ar 48k -ac 2 -sync ext -showmode 1 -i tcp://localhost:%SNDCPY_PORT%
ffplay -hide_banner -fflags nobuffer -f s16le -ar 48k -ac 2 -sync ext -nodisp -i tcp://localhost:%SNDCPY_PORT%
goto :EOF

:error
echo Failed with error #%errorlevel%.
pause
exit /b %errorlevel%
