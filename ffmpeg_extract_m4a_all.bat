@echo off
setlocal enableExtensions disableDelayedExpansion

"%~dp0ffmpeg" -i "%~1" -q:a 0 -map 0:a:0 -c copy "%~dpn1-audio_0.m4a" -map 0:a:1 -c copy "%~dpn1-audio_1.m4a" -map 0:a:2 -c copy "%~dpn1-audio_2.m4a"
