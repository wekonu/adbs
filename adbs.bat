@echo off
set dir=%~dp0
set mode=%1
set filename=%2

echo:
echo use help as param to show options. eg: adbs help
echo ===================================
echo:
echo adb version:
adb version
echo:
echo connected devices:
adb devices

echo == Note: Please connect a device if no devices are listed
echo:

if "%mode%"=="" (goto UNDEF)
if "%mode%"=="install" (goto INSTALL)
if "%mode%"=="log" (goto LOG)
if "%mode%"=="dumplog" (goto DUMPLOG)
if "%mode%"=="help" (goto HELP) else (goto UNDEF)

:UNDEF
goto HELP

:HELP
echo available param:
echo install		: install an app to a device. eg: adbs install
echo log		: shows adb logs to the prompt. eg: adbs log
echo dumplog		: save logs to a log file. eg: adbs dumplog
goto END

:INSTALL
setlocal ENABLEDELAYEDEXPANSION
set /a count=0
echo:
echo == select .apk to install:
for %%f in (*.apk) do (
     set /a count+=1
     set apk[!count!]=%%f
     echo !count!. %%f
)

if %count% equ 0 (
    echo No APK files found in the current directory.
    pause
    goto END
)

set /p apk_choice=Enter the number of the APK to install: 

rem Validate user input
if %apk_choice% lss 1 (
    echo Invalid choice. Exiting.
    pause
    goto END
)

if %apk_choice% gtr %count% (
    echo Invalid choice. Exiting.
    pause
    goto END
)

echo Installing: "%cd%\!apk[%apk_choice%]!"
echo Please do not close this window
echo:
adb install -r "%cd%\!apk[%apk_choice%]!"
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