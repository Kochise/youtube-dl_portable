@echo off
if exist "youtube-dl.exe" (set "yt_exe=youtube-dl") else (if exist "..\youtube-dl.exe" (set "yt_exe=..\youtube-dl") else (set "yt_exe=..\..\youtube-dl"))
@echo on

%yt_exe% -f "bestaudio[ext=m4a]" --extract-audio --audio-format mp3 --audio-quality 0 --config-location youtube-dl_videos.cnf 1>youtube-dl_stdout.txt 2>youtube-dl_stderr.txt
