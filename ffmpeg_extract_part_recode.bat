@echo off
setlocal enableExtensions disableDelayedExpansion

set /p tstart="Start (hh:mm:ss): "
set /p tlength="Length (hh:mm:ss): "

"%~dp0ffmpeg" -ss %tstart% -t %tlength% -i "%~1" -c:v libx264 -c:a aac "%~dpn1-extract%~x1"

pause
