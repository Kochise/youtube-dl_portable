@echo off
setlocal enableExtensions disableDelayedExpansion

ffmpeg -i "%~1" -q:a 0 -map a "%~dpn1-audio.mp3"
