@echo off
setlocal enableExtensions disableDelayedExpansion

"%~dp0ffmpeg" -i "%~1" -q:a 0 -map 0:a:0 "%~dpn1-audio_0.wav" -map 0:a:1 "%~dpn1-audio_1.wav" -map 0:a:2 "%~dpn1-audio_2.wav" -map 0:v -c copy "%~dpn1-video.mp4"

rem pause
