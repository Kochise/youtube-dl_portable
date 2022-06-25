@echo off
setlocal enableExtensions disableDelayedExpansion

set /p tstart="Start (hh:mm:ss): "
set /p tlength="Length (hh:mm:ss): "

"%~dp0ffmpeg" -ss %tstart% -t %tlength% -i "%~1" -vcodec copy -acodec copy -copyts "%~dpn1-extract%~x1"
