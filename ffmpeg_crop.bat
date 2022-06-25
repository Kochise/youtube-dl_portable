@echo off
setlocal enableExtensions disableDelayedExpansion

set /p twidth="Width (px): "
set /p theight="Height (px): "
set /p tleft="Left (px): "
set /p ttop="Top (px): "

rem "%~dp0ffmpeg" -i "%~1" -filter:v "crop=%twidth%:%theight%:%tleft%:%ttop%" -vcodec copy -acodec copy "%~dpn1-crop%~x1"
"%~dp0ffmpeg" -i "%~1" -b:v 2M -filter:v "crop=%twidth%:%theight%:%tleft%:%ttop%" "%~dpn1-crop%~x1"
rem "%~dp0ffmpeg" -i "%~1" -c copy -bsf:v h264_metadata=crop_left=%tleft%:crop_right=%tleft%:crop_top=%ttop%:crop_bottom=%ttop% "%~dpn1-crop%~x1"
