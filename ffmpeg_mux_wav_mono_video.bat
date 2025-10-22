@echo off
setlocal enableExtensions disableDelayedExpansion

"%~dp0ffmpeg" -i "%~dpn1.audio_1.wav" -i "%~dpn1.audio_2.wav" -filter_complex "[0:a:0][1:a:0] amerge=inputs=2" -i "%~1" -c:v copy -c:a aac -shortest "%~dpn1-muxed.mp4"

pause
