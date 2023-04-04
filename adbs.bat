@echo off
set dir=%~dp0
set mode=%1
set filename=%2

echo:
echo use help as param to show options. eg: adbs help
echo ===================================
echo:
adb version
adb devices

echo == Note: Please connect a device if no devices are listed
echo:

if "%mode%"=="" (goto UNDEF)
if "%mode%"=="install" (goto INSTALL)
if "%mode%"=="log" (goto LOG)
if "%mode%"=="dumplog" (goto DUMPLOG)
if "%mode%"=="help" (goto HELP) else (goto UNDEF)

:UNDEF
echo param is undefined.
goto HELP

:HELP
echo use param:
echo install		: intall an app to a device. eg: adbs install app_name.apk
echo log		: shows adb logs to the prompt. eg: adbs log
echo dumplog		: save logs to a log file. eg: adbs dumplog
goto END

:INSTALL
echo Installing: "%cd%\%filename%"
echo Please do not close this window
echo:
adb install -r "%cd%\%filename%"
goto END

:LOG
echo Press CTRL + C to stop logging
echo Now logging..
adb logcat -c
adb logcat -s Unity
goto END

:DUMPLOG
for /f "tokens=1-4 delims=/ " %%i in ("%date%") do (
     set dow=%%i
     set month=%%j
     set day=%%k
     set year=%%l
)
set datestr=%month%-%day%-%year%
for /f "tokens=1-4 delims=: " %%i in ("%time%") do (
     set hour=%%i
     set minute=%%j
     set sec=%%k
     set mil=%%l
)
set timestr=%hour%.%minute%.%sec%
echo Please do not close this window
echo No log shown on the prompt is expected
echo Press CTRL + C to stop logging
echo:
echo Now logging..
adb logcat -c
adb logcat -s Unity > %cd%\%datestr%_%timestr%.log
goto END

:END