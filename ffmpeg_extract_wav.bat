@echo off
setlocal enableExtensions disableDelayedExpansion

"%~dp0ffmpeg" -i "%~1" -q:a 0 "%~dpn1-audio.wav"
