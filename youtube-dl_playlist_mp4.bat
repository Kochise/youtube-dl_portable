@echo off
if exist "youtube-dl.exe" (set "yt_exe=youtube-dl") else (if exist "..\youtube-dl.exe" (set "yt_exe=..\youtube-dl") else (set "yt_exe=..\..\youtube-dl"))
@echo on

%yt_exe% -f "bestvideo[ext=mp4][height=1080][fps<=50]+bestaudio[ext=m4a]/bestvideo[ext=mp4][height=1080][fps=60]+bestaudio[ext=m4a]/bestvideo[ext=mp4][height<=1080][fps<=50]+bestaudio[ext=m4a]/best[ext=mp4]" --merge-output-format mp4 --config-location youtube-dl_playlist.cnf 1>youtube-dl_stdout.txt 2>youtube-dl_stderr.txt
