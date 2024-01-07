@echo off
setlocal enableExtensions disableDelayedExpansion

"%~dp0ffmpeg" -i "%~1" -vf hflip -c:a copy "%~dpn1-hflip%~x1"
