@echo off

ffmpeg -i "%~1" -aspect 720:1280 -c copy "%~dpn1_vertical%~x1"
