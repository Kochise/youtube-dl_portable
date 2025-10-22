# youtube-dl_portable

Ready to use [yt-dlp] package (including [FFmpeg])

[yt-dlp]: https://github.com/yt-dlp/yt-dlp
[FFmpeg]: https://www.ffmpeg.org/download.html

Some nice `FFmpeg` tips
* [protrolium](https://gist.github.com/protrolium/e0dbd4bb0f1a396fcb55)
* [sebsauvage](https://sebsauvage.net/wiki/doku.php?id=ffmpeg)

* For playlist
  - Paste some playlist **URLS** into `yt-dlp_playlist.txt`
  - Run `yt-dlp_playlist_m4a.bat` to get raw **M4A** files
  - Run `yt-dlp_playlist_mp3.bat` to get **MP3** files (converted from **M4A**)
  - Run `youtube-yt-dlp_playlist_mp4.bat` to get **MP4** files (1920x1080 50fps max)
  
* For videos
  - Paste some videos/watch **URLS** into `yt-dlp_videos.txt`
  - Run `yt-dlp_videos_m4a.bat` to get raw **M4A** files
  - Run `yt-dlp_videos_mp3.bat` to get **MP3** files (converted from **M4A**)
  - Run `yt-dlp_videos_mp4.bat` to get **MP4** files (1920x1080 50fps max)
  - Run `yt-dlp_videos_mp4_slow.bat` to get **MP4** files (300KB/s max)
  - Run `yt-dlp_videos_webm_4k.bat` to get **WEBM** files (max res, like 4K+)

* For updating
  - Run `yt-dlp_update.bat` when not downloading anything, wait a bit
  - Run `yt-dlp_help.bat` to get an updated help file

When downloading files, you get their description informations in a separate file<br>
You also get their thumbnail (**JPG** or **WEBP**) and subtitles as well (if available)<br>

If **M4A** files are present, their are resumed (if unifinished) but not overwritten<br>
If **MP3** files are present, their are converted AGAIN from **M4A** files (if present, otherwise downloaded AGAIN)<br>
If **MP4** files are present, their are resumed (if unifinished) but not overwritten<br>

Hence beware downloading **MP3** files from a /videos or /playlist, better be sure you won't have other files to download in the future
