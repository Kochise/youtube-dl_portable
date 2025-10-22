@echo off
if exist "yt-dlp.exe" (set "yt_exe=yt-dlp") else (if exist "..\yt-dlp.exe" (set "yt_exe=..\yt-dlp") else (if exist "..\..\yt-dlp.exe" (set "yt_exe=..\..\yt-dlp") else (set "yt_exe=..\..\..\yt-dlp")))
@echo on

%yt_exe% -f "bestaudio[ext=m4a]" --config-location yt-dlp_playlist.cnf -o "%%(playlist_title)s/%%(playlist_index)s - %%(title)s-[%%(uploader)s]-%%(id)s.%%(ext)s" 1>yt-dlp_stdout.txt 2>yt-dlp_stderr.txt
