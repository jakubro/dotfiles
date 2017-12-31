@echo off
setlocal

:: Check prerequisites
set _msbuildexe="%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe"
if not exist %_msbuildexe% set _msbuildexe="%ProgramFiles(x86)%\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin\MSBuild.exe"
:: if not exist %_msbuildexe% set _msbuildexe="%ProgramFiles(x86)%\MSBuild\14.0\Bin\MSBuild.exe"
:: if not exist %_msbuildexe% set _msbuildexe="%ProgramFiles%\MSBuild\14.0\Bin\MSBuild.exe"
if not exist %_msbuildexe% echo Error: Could not find MSBuild.exe && exit /b 2

:: Command
set _command=test

:: Log command line
set _prefix=echo
set _postfix=^> "%~dp0%_command%.log"
call :run %*

:: Run
set _prefix=
set _postfix=
call :run %*

goto :after

:run
%_prefix% %_msbuildexe% "%~dp0%_command%.proj" /nologo /maxcpucount /verbosity:minimal /nodeReuse:false /fileloggerparameters:Verbosity=diag;LogFile="%~dp0%_command%.log";Append %* %_postfix%
set LASTERRORLEVEL=%ERRORLEVEL%
goto :eof

:after

echo.
:: Pull the summary from the log file
findstr /ir /c:".*Warning(s)" /c:".*Error(s)" /c:"Time Elapsed.*" "%~dp0%_command%.log"
echo Exit Code = %LASTRRORLEVEL%

exit /b %LASTERRORLEVEL%
