@echo off
if exist "yt-dlp.exe" (set "yt_exe=yt-dlp") else (if exist "..\yt-dlp.exe" (set "yt_exe=..\yt-dlp") else (set "yt_exe=..\..\yt-dlp"))
@echo on

%yt_exe% -f "bestvideo[ext=mp4][height=1080][fps<=50]+bestaudio[ext=m4a]/bestvideo[ext=mp4][height=1080][fps=60]+bestaudio[ext=m4a]/bestvideo[ext=mp4][height<=1080][fps<=50]+bestaudio[ext=m4a]/best[ext=mp4]" --merge-output-format mp4 --config-location yt-dlp_videos.cnf 1>yt-dlp_stdout.txt 2>yt-dlp_stderr.txt