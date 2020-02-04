youtube-dl --ignore-errors --continue --hls-prefer-native --no-overwrites --no-progress --no-mark-watched --no-call-home --all-subs --sub-format "srt/best" --extract-audio --audio-format mp3 --audio-quality 0 --write-thumbnail --write-description --batch-file youtube-dl_playlist.txt --yes-playlist 1>youtube-dl_stdout.txt 2>youtube-dl_stderr.txt

rem --write-info-json --write-annotations
rem --simulate --get-id --get-description --get-duration --get-filename --get-format
