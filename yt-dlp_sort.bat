@echo off && setlocal enabledelayedexpansion && chcp 65001>nul

rem %~dpnx0 youtube
set "cdir=/B /A:-D /ON /S"
set "cdst=..\_CHAN\"
set "cfil=.cdir.txt"
set "curl=https://www.youtube.com/watch?v="
set "cerr=ERROR: [youtube]"

set "quiet=1>nul 2>nul"
set "fquiet=/f /q 1>nul 2>nul"

del "%cfil%" %fquiet%

rem List extension
call :listext "mp3" "%cfil%"
call :listext "mp4" "%cfil%"
call :listext "mkv" "%cfil%"
call :listext "webm" "%cfil%"
call :listext "jpg" "%cfil%"
call :listext "webp" "%cfil%"
call :listext "description" "%cfil%"
call :listext "txt" "%cfil%"

rem Merge duplicate files
call :sortmerge "%cfil%"

if exist "%cfil%" (
	for /f "delims=" %%i in (.cdir.txt) do (
		set "vcmd=$[NAME]"
		call :adaptvcmd "yt-dlp" "%%i.ext" "" "" "" ""
		set "vinc=!pcmd:_snapshot_=!"
		if "!vinc!"=="!pcmd!" (
			set "vinc=!pcmd:~-11!"
		) else (
			set "vinc=!pcmd:~-34,11!"
		)

		rem echo Checking "!vinc!"...
		yt-dlp --print "%%(channel)s" "%curl%!vinc!" 1>.vout.txt 2>.verr.txt

		if exist ".vout.txt" (
			for /f "tokens=1* delims=" %%j in (.vout.txt) do (
				set "vstr=%%j"
				call :cleanstr
				echo !vinc! - "!pstr!"
				mkdir "%cdst%!pstr!" 2>nul
				set "vcmd=$[PATH]"
				call :adaptvcmd "yt-dlp" "%%i.ext" "" "" "" ""
				move /y "!pcmd!*!vinc!*" "%cdst%!pstr!" %quiet%
			)
			del ".vout.txt" %fquiet%
		)
		
		if exist ".verr.txt" (
			for /f "tokens=1* delims=" %%j in (.verr.txt) do (
				set "verr=%%j"
				set "vtmp=!verr:~0,16!
				if "!vtmp!"=="%cerr%" (
					set "vstr=!verr:~30!
					call :cleanstr
					echo !vinc! x "!pstr!"
					mkdir "%cdst%_!pstr!" 2>nul
					set "vcmd=$[PATH]"
					call :adaptvcmd "yt-dlp" "%%i.ext" "" "" "" ""
					move /y "!pcmd!*!vinc!*" "%cdst%_!pstr!" %quiet%
				)
			)
			del ".verr.txt" %fquiet%
		)
	)
	del "%cfil%" %fquiet%
)

goto :eof

rem - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:listext
	for /f "delims=" %%a in ('dir %cdir% "*.%~1"') do echo %%~dpna>>"%~2"
goto :eof

:sortmerge
	rem Merge list
	if not "%~1"=="" if exist "%~1" (
		sort "%~1">"%~1.sorted"
		if exist "%~1.sorted" (
			del "%~1" %fquiet%
			for /f "delims=" %%a in (%~1.sorted) do (
				REM echo   a=%%a
				rem Get file name
				set "vcmd=$[NAME]"
				rem Add fake extension to keep (last) real extension
				call :adaptvcmd "yt-dlp" "%%a.ext" "" "" "" ""
				rem Check if "_snapshot_"
				set "vinc=!pcmd:_snapshot_=!"
				if not "!vinc!"=="!pcmd!" (
					set "vinc=%%a"
					set "vinc=!vinc:~0,-22!"
					rem Add fake extension for it to work
					call :adaptvcmd "yt-dlp" "!vinc!" "" "" "" ""
					set "vinc=!pcmd!"
				)
				REM echo   vinc=!vinc!
				if not "!vdup!"=="!vinc!" (
					set "vdup=!vinc!"
					echo:!vinc!>>"%~1"
				)
			)
			del "%~1.sorted" %fquiet%
		)
	)
goto :eof

:cleanstr
	set "pstr=!vstr!"
	set "pstr=!pstr::=-!"
	set "pstr=!pstr:/=-!"
	set "pstr=!pstr:^*=-!"
	set "pstr=!pstr:?=_!"
	set "pstr=!pstr:|=_!"
	set "pstr=!pstr:Ã=A!"
	set "pstr=!pstr:ï=i!"
	rem echo pstr="!pstr!"
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
	set "pcmd=!pcmd:$[PATH]=%~dp2!"
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
	rem Remove double characters
	set "pcmd=!pcmd:\\=\!"
	set "pcmd=!pcmd:""="!"
goto :eof
