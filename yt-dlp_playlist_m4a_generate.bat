@echo off && setlocal enabledelayedexpansion && chcp 65001>nul

rem Current path (beware if 'root')
set "PATH_FULL=%~p0"

:loop
for /f "tokens=1* delims=\" %%a in ("%PATH_FULL%") do (
	set "PATH_LAST=%%a"
	set "PATH_FULL=%%b"
)
rem Loop as long as we're not at the end
if defined PATH_FULL goto :loop

rem If no last folder found (ie 'root') use batch's name
if not defined PATH_LAST set "PATH_LAST=%~n0"

set "PLAYLIST=_%PATH_LAST%.m3u"

rem Create playlist based on name (should be checked with source though)
dir /o:n /b *.m4a>"%PLAYLIST%"

echo;>>"%PLAYLIST%"
echo ___playlist_end___>>"%PLAYLIST%"
