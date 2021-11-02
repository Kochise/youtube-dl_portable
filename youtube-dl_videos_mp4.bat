youtube-dl -f "bestvideo[height<=1080][fps<50][ext=mp4]+bestaudio[ext=m4a]/mp4" --merge-output-format mp4 --config-location youtube-dl_videos.cnf 1>youtube-dl_stdout.txt 2>youtube-dl_stderr.txt
