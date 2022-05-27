@echo off
setlocal enabledelayedexpansion

for /f "tokens=2 delims=:." %%x in ('chcp') do set cp=%%x
chcp 1252>nul

rem %~dpnx0 youtube
set "cdir=/B /A:-D /ON /S"
set "cdst=..\_CHAN\"
set "curl=https://www.youtube.com/watch?v="
set "cerr=ERROR: [youtube]"

set "quiet=1>nul 2>nul"
set "fquiet=/f /q 1>nul 2>nul"

dir "*.mp4" %cdir% >".cdir.txt"
dir "*.mkv" %cdir% >>".cdir.txt"
dir "*.webm" %cdir% >>".cdir.txt"
dir "*.jpg" %cdir% >>".cdir.txt"
dir "*.webp" %cdir% >>".cdir.txt"
dir "*.description" %cdir% >>".cdir.txt"

if exist ".cdir.txt" (
	for /f "delims=|" %%i in (.cdir.txt) do (
		set "vcmd=$[NAME]"
		call :adaptvcmd "yt-dlp" "%%i" "" "" "" ""
		set "vinc=!pcmd:~-11!"
		rem echo Checking "!vinc!"...

		yt-dlp --print "%%(channel)s" "%curl%!vinc!" 1>.vout.txt 2>.verr.txt

		if exist ".vout.txt" (
			for /f "tokens=1* delims=|" %%j in (.vout.txt) do (
				echo !vinc! - "%%j"
				mkdir "%cdst%%%j" 2>nul
				set "vcmd=$[PATH]"
				call :adaptvcmd "yt-dlp" "%%i" "" "" "" ""
				move /y "!pcmd!*!vinc!*" "%cdst%%%j" %quiet%
			)
			del .vout.txt %fquiet%
		)
		
		if exist ".verr.txt" (
			for /f "tokens=1* delims=|" %%j in (.verr.txt) do (
				set "verr=%%j"
				set "vtmp=!verr:~0,16!
				if "!vtmp!"=="%cerr%" (
					set "vtmp=!verr:~30!
					echo !vinc! x "!vtmp!"
					mkdir "_%cdst%!vtmp!" 2>nul
					set "vcmd=$[PATH]"
					call :adaptvcmd "yt-dlp" "%%i" "" "" "" ""
					move /y "!pcmd!*!vinc!*" "_%cdst%!vtmp!" %quiet%
				)
			)
			del .verr.txt %fquiet%
		)
	)
	del ".cdir.txt" %fquiet%
)

chcp %cp%>nul

goto :eof

rem - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
