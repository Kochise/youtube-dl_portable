@echo off
setlocal enableExtensions disableDelayedExpansion

ffmpeg -i "%~1" -y -vn -acodec copy "%~dpn1-audio.ac3"
