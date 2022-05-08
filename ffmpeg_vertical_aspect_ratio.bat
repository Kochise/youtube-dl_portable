@echo off
rem https://trac.ffmpeg.org/wiki/Scaling

rem ffmpeg -i "%~1" -aspect 720:1280 -c copy "%~dpn1_vertical%~x1"
rem ffmpeg -i "%~1" -aspect 720:1280 -filter:v scale=iw:-2 -c:a copy "%~dpn1_vertical%~x1"
rem ffmpeg -i "%~1" -aspect 720:1280 -filter:v scale=320:568 -c:a copy "%~dpn1_vertical%~x1"
rem ffmpeg -i "%~1" -aspect 720:1280 -filter:v scale=480:-2 -c:a copy "%~dpn1_vertical%~x1"
ffmpeg -i "%~1" -aspect 720:1280 -filter:v scale=iw:-2 -b:v 2M -c:a copy "%~dpn1_vertical%~x1"
