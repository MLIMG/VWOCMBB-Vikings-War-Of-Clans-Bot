@echo off
"C:\Program Files (x86)\Nox\bin\adb" devices

echo Type adb device
set /p dddevice=""
:blabla
"C:\Program Files (x86)\Nox\bin\adb" -s %dddevice% shell screencap -p  /mnt/shared/Image/compare-screen.png
pause
goto blabla