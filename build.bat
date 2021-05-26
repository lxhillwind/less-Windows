goto build_x86
exit 1

:build_x86
:: ----------------------------------------------------------------------
@echo on

set LESS_URL=https://www.greenwoodsoftware.com/less/less-%LESS_VERSION%.zip
call :downloadfile %LESS_URL% less.zip
7z x -y less.zip
mv less-* less-src
cd less-src

:: Setting for targeting Windows XP, 32bit
set WinSdk71=%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1A
set INCLUDE=%WinSdk71%\Include;%INCLUDE%
set "LIB=%WinSdk71%\Lib;%LIB%"
set CL=/D_USING_V110_SDK71_
set "LINK=/SUBSYSTEM:CONSOLE,5.01 %LINK%"

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
nmake /f Makefile.wnm

copy /Y less.exe ..\
copy /Y lesskey.exe ..\

goto :eof

:downloadfile
:: ----------------------------------------------------------------------
:: call :downloadfile <URL> <localfile>
if not exist %2 (
	curl -f -L %1 -o %2
)
if ERRORLEVEL 1 (
	rem Retry once.
	curl -f -L %1 -o %2 || exit 1
)
@goto :eof
