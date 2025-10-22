@echo off && setlocal enabledelayedexpansion

rem https://learn.microsoft.com/en-us/windows/win32/intl/code-page-identifiers
for /f "tokens=2 delims=:." %%x in ('chcp') do set /a cp=%%x

rem 'dir', 'for /f' and 'type' works with 'ansi' and 'utf-16 le bom'
chcp 65001>nul

rem %~dpnx0 youtube
set "cdir=/B /A:-D /ON"
set "cdst=..\_CHAN_SORTED\"
set "cfil=.cdir.txt"
set "curl=https://www.youtube.com/watch?v="
set "cerr=ERROR: [youtube]"

	set "carg="
	set "carg=%carg% --cookies-from-browser firefox"
	set "carg=%carg% --no-download"
	set "carg=%carg% --print-to-file"
rem	set "carg=%carg% --rm-cache"

echo carg=%carg%

set "sout=.yt-dlp_stdout.txt"
set "scon=.yt-dlp_stdcon.txt"
set "serr=.yt-dlp_stderr.txt"

set "vout=.vout.txt"
set "vcon=.vcon.txt"
set "verr=.verr.txt"

set "quiet=1>nul 2>nul"
set "fquiet=/f /q 1>nul 2>nul"

del "%cfil%" %fquiet%

del "%sout%" %fquiet%
del "%scon%" %fquiet%
del "%serr%" %fquiet%

REM	cmd /d /a /c (set/p=ÿþ)<nul >"%cfil%" 2>nul
REM	cmd /d /u /c type "%cfil%" >>"%cfil%"

rem List extension
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

rem Merge duplicate and snapshot files
call :sortmerge "%cfil%"

if exist "%cfil%" (
REM	set /p vinc= <%cfil%
REM	echo vinc = "!vinc!"
	for /f "delims=" %%i in (%cfil%) do (
		rem At this moment, file names are already merged
		set "vinc=%%i"
REM		echo vinc=!vinc!

		rem Get video ID
		set "vinc=!vinc:~-11!"

REM		echo Checking video ID : !vinc!
		yt-dlp %carg% "%%(channel)s" "%vout%" "%curl%!vinc!" 1>"%vcon%" 2>"%verr%"

		rem Generated "%vout%" is in OEM format
REM		chcp 1252>nul

		type "%vcon%">>"%scon%" 

		rem When the video is found
		if exist "%vout%" (
			type "%vout%">>"%sout%" 
			set /p vstr= <%vout%
REM			echo vstr = "!vstr!"
			call :cleanstr
			rem Video ID - Channel name
			echo !vinc! - "!pstr!"
			mkdir "%cdst%!pstr!" 2>nul
REM			set "vcmd=$[PATH]"
REM			call :adaptvcmd "yt-dlp" "%%i.ext" "" "" "" ""
			move /y "*!vinc!*" "%cdst%!pstr!" %quiet%
			del "%vout%" %fquiet%
			set "vstr="
		)

		rem When the video has been striked
		if exist "%verr%" (
			type "%verr%">>"%serr%" 
			set /p verr= <"%verr%"
REM			echo verr = "!verr!"
			rem Extract error header
			set "vtmp=!verr:~0,16!
			if "!vtmp!"=="%cerr%" (
				set "vstr=!verr:~30!
REM				echo vstr = "!vstr!"
				call :cleanstr
				rem Video ID - Error message
				echo !vinc! x "!pstr!"
				rem Striked video are kept on top with a '_' prefix
				mkdir "%cdst%_!pstr!" 2>nul
REM				set "vcmd=$[PATH]"
REM				call :adaptvcmd "yt-dlp" "%%i.ext" "" "" "" ""
				move /y "*!vinc!*" "%cdst%_!pstr!" %quiet%
			)
			del "%verr%" %fquiet%
			set "verr="
		)

		rem Return in UTF-8 for the file list
REM		chcp 65001>nul

		del "%vcon%" %fquiet%
	)
	del "%cfil%" %fquiet%
)

chcp %cp%>nul

goto :eof

rem - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:listext
	for /f "delims=" %%a in ('dir %cdir% "*.%~1" 2^>nul') do (
		set "vinc=%%~na"
		if not "!vinc:~0,1!"=="." (
			rem If subtitile, should remove language identifier
			if "%%~xa"==".srt" (
				set "vcmd=$[LANG]"
				call :adaptvcmd "yt-dlp" "%%~dpna" "" "" "" ""
				call :adaptvcmd "yt-dlp" "!pcmd!" "" "" "" ""
REM				echo srt=!pcmd!
				echo !pcmd!>>"%~2"
			) else if "%%~xa"==".vtt" (
				set "vcmd=$[LANG]"
				call :adaptvcmd "yt-dlp" "%%~dpna" "" "" "" ""
REM				echo vtt=!pcmd!
				echo !pcmd!>>"%~2"
			) else (
				rem If snapshot, removes the image extension
				echo %%~dpna>>"%~2"
			)
		)
	)
goto :eof

:sortmerge
	rem Merge list
	if not "%~1"=="" if exist "%~1" (
		sort "%~1">"%~1.sorted"
		if exist "%~1.sorted" (
			del "%~1" %fquiet%
			for /f "delims=" %%a in (%~1.sorted) do (
REM				echo   a=%%a
				rem Aggregate snapshot timecode using a fake extension
				set "vcmd=$[NAME]"
				call :adaptvcmd "yt-dlp" "%%a.ext" "" "" "" ""
				rem Check if snapshot image : -I7xlwVZiVe0.mp4_snapshot_08.15.043
				set "vinc=!pcmd:_snapshot_=!"
				if not "!vinc!"=="!pcmd!" (
					rem Snapshot, beware of regional settings
					set "pcmd=!pcmd:~0,-19!"
					rem Remove remaining extension
					call :adaptvcmd "yt-dlp" "!pcmd!" "" "" "" ""
					set "vinc=!pcmd!"
				)
REM				echo   vinc=!vinc!
				if not "!vdup!"=="!vinc!" (
					rem Not already found name, store it
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
	rem Remove asterix
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
	rem Replace defined tags with parameters
	rem %1 : configuration
	rem %2 : file
	rem %3 : source
	rem %4 : relative
	rem %5 : move
	rem %6 : list
	rem When a command includes spaces and/or double quotes, it gets exploded
	rem That's why I process the !vcmd! variable directly
	set "pcmd=!vcmd!"
	set "pcmd=!pcmd:$[CONF]=%~1!"
	set "pcmd=!pcmd:$[THIS]=%~2!"
	set "pcmd=!pcmd:$[FULL]=%~f2!"
	set "pcmd=!pcmd:$[DISK]=%~d2!"
	set "pcmd=!pcmd:$[FOLD]=%~p2!"
	set "pcmd=!pcmd:$[PATH]=%~dp2!"
	rem Special identifier to remove language "extension" of subtitles
	set "pcmd=!pcmd:$[LANG]=%~dpn2!"
	set "pcmd=!pcmd:$[NAME]=%~n2!"
	set "pcmd=!pcmd:$[DOSN]=%~s2!"
	set "pcmd=!pcmd:$[EXT]=%~x2!"
	set "pcmd=!pcmd:$[FILE]=%~nx2!"
	set "pcmd=!pcmd:$[ATTR]=%~a2!"
	set "pcmd=!pcmd:$[TIME]=%~t2!"
	set "pcmd=!pcmd:$[SIZE]=%~z2!"
	set "pcmd=!pcmd:$[LOC_SRC]=%~3!"
	set "pcmd=!pcmd:$[LOC_DST]=%~4!"
	set "pcmd=!pcmd:$[LOC_MOV]=%~5!"
	set "pcmd=!pcmd:$[LIST]=%~6!"
	rem Remove double characters
	set "pcmd=!pcmd:\\=\!"
	set "pcmd=!pcmd:""="!"
goto :eof
