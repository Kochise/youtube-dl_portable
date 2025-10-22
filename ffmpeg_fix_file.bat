@echo off
setlocal enableExtensions disableDelayedExpansion

"%~dp0ffmpeg" -err_detect ignore_err -i "%~1" -c copy "%~dpn1.fixed.mp4"

rem pause
