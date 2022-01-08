@echo off
if exist "youtube-dl.exe" (set "yt_exe=youtube-dl") else (if exist "..\youtube-dl.exe" (set "yt_exe=..\youtube-dl") else (set "yt_exe=..\..\youtube-dl"))
@echo on

%yt_exe%  --help>youtube-dl_help.txt
