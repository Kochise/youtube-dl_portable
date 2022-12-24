@echo off && setlocal enabledelayedexpansion

:: https://learn.microsoft.com/en-us/windows/win32/intl/code-page-identifiers
for /f "tokens=2 delims=:." %%x in ('chcp') do set /a cp=%%x

:: 'dir', 'for /f' and 'type' works with 'ansi' and 'utf-16 le bom'
chcp 65001>nul

:: %~dpnx0 youtube
set "cdir=/B /A:-D /ON"
set "cdst=..\_CHAN\"
set "cfil=.cdir.txt"
set "curl=https://www.youtube.com/watch?v="
set "cerr=ERROR: [youtube]"

set "quiet=1>nul 2>nul"
set "fquiet=/f /q 1>nul 2>nul"

del "%cfil%" %fquiet%

REM	cmd /d /a /c (set/p=ÿþ)<nul >"%cfil%" 2>nul
REM	cmd /d /u /c type "%cfil%" >>"%cfil%"

:: List extension
call :listext "mp3" "%cfil%"
call :listext "m4a" "%cfil%"

call :listext "mp4" "%cfil%"
call :listext "mkv" "%cfil%"
call :listext "webm" "%cfil%"

call :listext "jpg" "%cfil%"
call :listext "webp" "%cfil%"

call :listext "description" "%cfil%"
call :listext "txt" "%cfil%"

call :listext "srt" "%cfil%"
call :listext "vtt" "%cfil%"

:: Merge duplicate and snapshot files
call :sortmerge "%cfil%"

if exist "%cfil%" (
REM	set /p vinc= <%cfil%
REM	echo vinc = "!vinc!"
	for /f "delims=" %%i in (%cfil%) do (
		:: At this moment, file names are already merged
		set "vinc=%%i"
REM		echo vinc=!vinc!

		:: Get video ID
		set "vinc=!vinc:~-11!"

REM		echo Checking video ID : !vinc!
		yt-dlp --no-download --print-to-file "%%(channel)s" ".vout.txt" "%curl%!vinc!" 1>.vcon.txt 2>.verr.txt

		:: Generated ".vout.txt" is in OEM format
REM		chcp 1252>nul

		:: When the video is found
		if exist ".vout.txt" (
			set /p vstr= <.vout.txt
REM			echo vstr = "!vstr!"
			call :cleanstr
			:: Video ID - Channel name
			echo !vinc! - "!pstr!"
			mkdir "%cdst%!pstr!" 2>nul
REM			set "vcmd=$[PATH]"
REM			call :adaptvcmd "yt-dlp" "%%i.ext" "" "" "" ""
			move /y "*!vinc!*" "%cdst%!pstr!" %quiet%
			del ".vout.txt" %fquiet%
			set "vstr="
		)

		:: When the video has been striked
		if exist ".verr.txt" (
			set /p verr= <.verr.txt
REM			echo verr = "!verr!"
			:: Extract error header
			set "vtmp=!verr:~0,16!
			if "!vtmp!"=="%cerr%" (
				set "vstr=!verr:~30!
REM				echo vstr = "!vstr!"
				call :cleanstr
				:: Video ID - Error message
				echo !vinc! x "!pstr!"
				:: Striked video are kept on top with a '_' prefix
				mkdir "%cdst%_!pstr!" 2>nul
REM				set "vcmd=$[PATH]"
REM				call :adaptvcmd "yt-dlp" "%%i.ext" "" "" "" ""
				move /y "*!vinc!*" "%cdst%_!pstr!" %quiet%
			)
			del ".verr.txt" %fquiet%
			set "verr="
		)

		:: Return in UTF-8 for the file list
REM		chcp 65001>nul

		del ".vcon.txt" %fquiet%
	)
	del "%cfil%" %fquiet%
)

chcp %cp%>nul

goto :eof

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:listext
	for /f "delims=" %%a in ('dir %cdir% "*.%~1" 2^>nul') do (
		set "vinc=%%~na"
		if not "!vinc:~0,1!"=="." (
			:: If subtitile, should remove language identifier
			if "%%~xa"==".srt" (
				set "vcmd=$[LANG]"
				call :adaptvcmd "yt-dlp" "%%~dpna" "" "" "" ""
REM				echo srt=!pcmd!
				echo !pcmd!>>"%~2"
			) else if "%%~xa"==".vtt" (
				set "vcmd=$[LANG]"
				call :adaptvcmd "yt-dlp" "%%~dpna" "" "" "" ""
REM				echo vtt=!pcmd!
				echo !pcmd!>>"%~2"
			) else (
				:: If snapshot, removes the image extension
				echo %%~dpna>>"%~2"
			)
		)
	)
goto :eof

:sortmerge
	:: Merge list
	if not "%~1"=="" if exist "%~1" (
		sort "%~1">"%~1.sorted"
		if exist "%~1.sorted" (
			del "%~1" %fquiet%
			for /f "delims=" %%a in (%~1.sorted) do (
REM				echo   a=%%a
				:: Aggregate snapshot timecode using a fake extension
				set "vcmd=$[NAME]"
				call :adaptvcmd "yt-dlp" "%%a.ext" "" "" "" ""
				:: Check if snapshot image : -I7xlwVZiVe0.mp4_snapshot_08.15.043
				set "vinc=!pcmd:_snapshot_=!"
				if not "!vinc!"=="!pcmd!" (
					:: Snapshot, beware of regional settings
					set "pcmd=!pcmd:~0,-19!"
					:: Remove remaining extension
					call :adaptvcmd "yt-dlp" "!pcmd!" "" "" "" ""
					set "vinc=!pcmd!"
				)
REM				echo   vinc=!vinc!
				if not "!vdup!"=="!vinc!" (
					:: Not already found name, store it
					set "vdup=!vinc!"
					echo:!vinc!>>"%~1"
				)
			)
			del "%~1.sorted" %fquiet%
		)
	)
goto :eof

:cleanstr
	set "pstr="
:cleanstr_loop
	:: Remove asterix
	for /f "tokens=1* delims=*" %%a in ("!vstr!") do (
		set pstr=!pstr!-%%a&set vstr=%%b
	)
	if defined vstr goto :cleanstr_loop
	set "pstr=!pstr:~1!"
REM	set "pstr=!vstr!"
REM	echo pstr="!pstr!"
	set "pstr=!pstr:"='!"
	set "pstr=!pstr::=-!"
	set "pstr=!pstr:/=-!"
	set "pstr=!pstr:?=_!"
	set "pstr=!pstr:|=_!"
REM	set "pstr=!pstr:Ã=A!"
REM	set "pstr=!pstr:ï=i!"
REM	echo pstr="!pstr!"
goto :eof

:adaptvcmd
	:: Replace defined tags with parameters
	:: %1 : configuration
	:: %2 : file
	:: %3 : source
	:: %4 : relative
	:: %5 : move
	:: %6 : list
	:: When a command includes spaces and/or double quotes, it gets exploded
	:: That's why I process the !vcmd! variable directly
	set "pcmd=!vcmd!"
	set "pcmd=!pcmd:$[CONF]=%~1!"
	set "pcmd=!pcmd:$[THIS]=%~2!"
	set "pcmd=!pcmd:$[PATH]=%~dp2!"
	set "pcmd=!pcmd:$[LANG]=%~dpn2!"
	set "pcmd=!pcmd:$[NAME]=%~n2!"
	set "pcmd=!pcmd:$[EXT]=%~x2!"
	set "pcmd=!pcmd:$[FILE]=%~nx2!"
	set "pcmd=!pcmd:$[ATTR]=%~a2!"
	set "pcmd=!pcmd:$[TIME]=%~t2!"
	set "pcmd=!pcmd:$[SIZE]=%~z2!"
	set "pcmd=!pcmd:$[LOC_SRC]=%~3!"
	set "pcmd=!pcmd:$[LOC_DST]=%~4!"
	set "pcmd=!pcmd:$[LOC_MOV]=%~5!"
	set "pcmd=!pcmd:$[LIST]=%~6!"
	:: Remove double characters
	set "pcmd=!pcmd:\\=\!"
	set "pcmd=!pcmd:""="!"
goto :eof
