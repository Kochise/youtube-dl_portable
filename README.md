# youtube-dl_portable
Ready to use youtube-dl package (minus ffmpeg)

Standalone ready-to-use package of [youtube-dl](https://github.com/ytdl-org/youtube-dl)

You must also download [FFMPEG](https://www.ffmpeg.org/download.html) and add the BIN folder (not the TRASH folder) to the PATH environment variable

Some nice FFMPEG tips [protrolium](https://gist.github.com/protrolium/e0dbd4bb0f1a396fcb55) or [sebsauvage](https://sebsauvage.net/wiki/doku.php?id=ffmpeg)

* For playlist
  - Paste some playlist URLS into 'youtube-dl_playlist.txt'
  - Run 'youtube-dl_playlist_m4a.bat' to get raw M4A files
  - Run 'youtube-dl_playlist_mp3_forced.bat' to get MP3 files (converted from M4A)
  - Run 'youtube-youtube-dl_playlist_mp4_forced.bat' to get MP4 files (1920x1080 50fps max)
  
* For videos
  - Paste some videos/watch URLS into 'youtube-dl_videos.txt'
  - Run 'youtube-dl_videos_m4a.bat' to get raw M4A files
  - Run 'youtube-dl_videos_mp3.bat' to get MP3 files (converted from M4A)
  - Run 'youtube-dl_videos_mp4_forced.bat' to get MP4 files (1920x1080 50fps max)
  - Run 'youtube-dl_videos_mp4_forced_slow.bat' to get MP4 files (300KB/s max)

* For updating
  - Run 'youtube-dl_update.bat' when not downloading anything, wait a bit
  - Run 'youtube-dl_help.bat' to get an updated help file

When downloading files, you get their description informations in a separate file<br>
When downloading M4A files, you get their thumbnail and subtitles as well<br>
When downloading MP3 files, you get their thumbnail and subtitles as well<br>
When downloading MP4 files, you just get their subtitles<br>

If M4A files are present, their are resumed (if unifinished) but not overwritten<br>
If MP3 files are present, their are converted AGAIN from M4A files (if present, otherwise downloaded AGAIN)<br>
If MP4 files are present, their are resumed (if unifinished) but not overwritten<br>

Hence beware downloading MP3 files from a /videos or /playlist, better be sure you won't have other files to download in the future
