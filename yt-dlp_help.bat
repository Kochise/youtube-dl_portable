@echo off
if exist "yt-dlp.exe" (set "yt_exe=yt-dlp") else (if exist "..\yt-dlp.exe" (set "yt_exe=..\yt-dlp") else (set "yt_exe=..\..\yt-dlp"))
@echo on

%yt_exe% --help>yt-dlp_help.txt

