@echo off
setlocal enableExtensions disableDelayedExpansion

set /p tstart="Start (hh:mm:ss): "
set /p tlength="Length (hh:mm:ss): "

ffmpeg -ss %tstart% -i "%~1" -t %tlength% -vcodec copy -acodec copy "%~dpn1-extract%~x1"
