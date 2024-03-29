@echo off

rem "%~dp0ffmpeg" -i "%~1" -vf "transpose=2" -c:a copy "%~dpn1_cw%~x1"
rem "%~dp0ffmpeg" -i "%~1" -vf "vflip,hflip,vflip,hflip" -c:a copy "%~dpn1_cw%~x1"
rem "%~dp0ffmpeg" -i "%~1" -vf "transpose=clock" -crf 18 -c:a copy "%~dpn1_cw%~x1"
"%~dp0ffmpeg" -i "%~1" -vf "transpose=clock" -b:v 2M -c:a copy "%~dpn1_cw%~x1"
rem "%~dp0ffmpeg" -i "%~1" -vf "transpose=clock,transpose=clock" -crf 18 -c:a copy "%~dpn1_cw%~x1"
rem "%~dp0ffmpeg" -i "%~1" -vf "transpose=clock,transpose=clock" -b:v 10M -c:a copy "%~dpn1_cw%~x1"
rem "%~dp0ffmpeg" -i "%~1" -c copy -metadata:s:v:0 rotate=90 "%~dpn1_cw%~x1"
rem "%~dp0ffmpeg" -i "%~1" -c copy -map_metadata 0 -metadata:s:v:0 rotate=90 "%~dpn1_cw%~x1"
rem "%~dp0ffmpeg" -i "%~1" -c copy rotate=90 "%~dpn1_cw%~x1"
rem "%~dp0ffmpeg" -i "%~1" -vf "transpose=1" "%~dpn1_cw%~x1"

rem http://ffmpeg.org/ffmpeg-filters.html#transpose

rem 0 = 90CounterCLockwise and Vertical Flip (default)
rem 1 = 90Clockwise
rem 2 = 90CounterClockwise
rem 3 = 90Clockwise and Vertical Flip
