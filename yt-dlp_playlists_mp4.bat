@echo off
if exist "yt-dlp.exe" (set "yt_exe=yt-dlp") else (if exist "..\yt-dlp.exe" (set "yt_exe=..\yt-dlp") else (if exist "..\..\yt-dlp.exe" (set "yt_exe=..\..\yt-dlp") else (set "yt_exe=..\..\..\yt-dlp")))
@echo on

%yt_exe% -f "bestvideo[ext=mp4][height=1080][fps<=50]+bestaudio[ext=m4a]/bestvideo[ext=mp4][height=1080][fps=60]+bestaudio[ext=m4a]/bestvideo[ext=mp4][height<=1080][fps<=50]+bestaudio[ext=m4a]/best[ext=mp4]" --config-location yt-dlp_playlist.cnf -o "%%(uploader)s/%%(playlist_title)s/%%(playlist_index)s - %%(title)s-%%(id)s.%%(ext)s" 1>yt-dlp_stdout.txt 2>yt-dlp_stderr.txt
