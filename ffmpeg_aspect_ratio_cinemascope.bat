@echo off
rem https://trac.ffmpeg.org/wiki/Scaling

"%~dp0ffmpeg" -i "%~1" -aspect 1280:720 -filter:v scale=iw:-2 -b:v 2M -c:a copy "%~dpn1_cinema%~x1"
