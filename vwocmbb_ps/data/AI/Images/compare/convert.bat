@echo off
:start
echo drag image here
echo .
set /p imagepath=""
C:\vwocmbbot\data\AI\ICompare\convert %imagepath% -resize 10%% %imagepath%
timeout 3
goto start
exit 0