@echo off
setlocal enabledelayedexpansion

for /f "tokens=2 delims=:." %%x in ('chcp') do set cp=%%x
chcp 1252>nul

rem %~dpnx0 youtube
set "vdir=/B /A:-D /ON /S"
set "vdst=..\_CHAN\"
set "vurl=https://www.youtube.com/watch?v="

set "quiet=1>nul 2>nul"
set "fquiet=/f /q 1>nul 2>nul"

dir "*.mp4" %vdir% >".vdir.txt"
dir "*.webm" %vdir% >>".vdir.txt"

if exist ".vdir.txt" for /f "delims=!" %%i in (.vdir.txt) do (
	set "vcmd=$[NAME]"
	call :adaptvcmd "yt-dlp" "%%i" "" "" "" "" && set "vnam=!pcmd!"
	set "vinc=!vnam:~-11!"
	
	for /f "tokens=1* delims=:" %%j in ('yt-dlp --print "%%(channel)s" "!vurl!!vinc!"') do (
		if errorlevel 0 (
			echo !vinc! - "%%j"
			mkdir "!vdst!%%j" 2>nul
			set "vcmd=$[PATH]$[NAME]"
			call :adaptvcmd "yt-dlp" "%%i" "" "" "" "" && set "vnam=!pcmd!"
			dir "!vnam!.*" %vdir% >".vlst.txt"
			if exist ".vlst.txt" for /f "delims=!" %%k in (.vlst.txt) do (
				move /y "%%k" "!vdst!%%j" %quiet%
			)
		) else (
			echo ERROR
		)
	)
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
