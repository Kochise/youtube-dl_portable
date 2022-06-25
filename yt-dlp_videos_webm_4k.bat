@echo off
if exist "yt-dlp.exe" (set "yt_exe=yt-dlp") else (if exist "..\yt-dlp.exe" (set "yt_exe=..\yt-dlp") else (if exist "..\..\yt-dlp.exe" (set "yt_exe=..\..\yt-dlp") else (set "yt_exe=..\..\..\yt-dlp")))
@echo on

%yt_exe% -f "bestvideo+bestaudio" --config-location yt-dlp_videos_4k.cnf 1>yt-dlp_stdout.txt 2>yt-dlp_stderr.txt
