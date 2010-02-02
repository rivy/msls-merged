@echo off
REM
REM SETBUILD.CMD - Set build environment for various compilers.
REM Written by Alan Klietz 
REM
REM Copyright (c) 2007, Algin Technology LLC.  Distributed under GNU
REM General Public License version 2.
REM
REM You will need to edit the drive letters and paths to match your
REM particular configuration.
REM
if "%LOCALAPPDATA%"=="" ( set VC8Settings=%USERPROFILE%\Local Settings\Application Data\Microsoft\VisualStudio\8.0
set VC9Settings=%USERPROFILE%\Local Settings\Application Data\Microsoft\VisualStudio\9.0
) else ( set VC8Settings=%LOCALAPPDATA%\Microsoft\VisualStudio\8.0
set VC9Settings=%LOCALAPPDATA%\Microsoft\VisualStudio\9.0
)
set VCSettings=%VC9Settings%

set HomeVC8Settings=E:\home\alan\doc\Visual Studio 2005\Settings
set HomeVC9Settings=E:\home\alan\doc\Visual Studio 2008\Settings
set HomeVCSettings=%HomeVC9Settings%

set VCName=VS2008
set VCLib=E:\ae\libvc96

set FrameworkVersion=v3.5
set FrameworkSDKDir=H:\VS2008\SDK\v3.5\

if "%~1"=="/silent" (
	shift /1
	set silent=yes
)
if "%~1"=="/force" (
	shift /1
	set force=yes
)
rem
if "%1"=="restore" goto restore
if "%1"=="%BUILDTYPE%" goto done
set BUILDTYPE=%1
rem
if not "%basepath%"=="" goto nosave
rem
rem Basepath is empty. Save the basepath for later restore
rem 
set basepath=%PATH%
set baseinclude=%INCLUDE%
set baselib=%LIB%
:nosave
rem
rem Common paths to the MS SDK
rem Note: Put c:\lbin first to pick up the right copy of rebase.exe!
rem
rem set PATH=C:\lbin;H:\mssdk09\bin\winnt;H:\mssdk09\bin;%basepath%
set PATH=%basepath%
rem set INCLUDE=H:\mssdk09\include;%baseinclude%
set INCLUDE=%baseinclude%
rem set LIB=H:\mssdk09\lib;%baselib%
set LIB=%baselib%
rem
if "%1"=="msvc16" goto m16
if "%1"=="vc6" goto vc6
if "%1"=="vc8" goto vc8
if "%1"=="vc9" goto vc9
if "%1"=="vc8x64" goto vc8x64
if "%1"=="vc9x64" goto vc9x64
if "%1"=="vc86" goto vc86
if "%1"=="vc96" goto vc96
if "%1"=="vc86x64" goto vc86x64
if "%1"=="vc96x64" goto vc96x64
if "%1"=="watcom32" goto w32
if "%1"=="watcom32_win32s" goto w32_win32s
if "%1"=="watcom32_os2" goto w32_os2
if "%1"=="watcom32_nt" goto w32_nt
echo Usage: setbuild [vc6,vc8,vc9,vc8x64,vc9x64,vc86,vc96,vc86x64,vc96x64,msvc16,restore,watcom32,watcom32_win32s,watcom32_os2,watcom32_nt]
goto done
:restore
if "%basepath%"=="" goto norestore
rem
rem Restore the PATH from the basepath
rem
set BUILDTYPE=
set toolrootdir=
set PATH=%basepath%
set basepath=
set INCLUDE=%baseinclude%
set baseinclude=
set LIB=%baselib%
set baselib=
rem
set FrameworkDir=
set FrameworkVersion=
set FrameworkSDKDir=
set VSInstallDir=
set VCInstallDir=
set LIBPATH=
:norestore
goto done
:m16
set toolrootdir=E:\msvc16
set path=%toolrootdir%\bin;%path%
set include=%toolrootdir%\include;%toolrootdir%\mfc\include
set lib=%toolrootdir%\lib;%toolrootdir%\mfc\lib
if not "%silent%"=="yes" echo Environment variables set for 16-bit Visual C++.
goto done
rem --------------------------------------------------------------------------
:vc6
set AMD64=
set StudioDir=G:\DevStudio
set PATH=H:\mssdk06\bin;H:\mssdk06\bin\winnt;%PATH%;%StudioDir%\Common\MSDev98\Bin;%StudioDir%\Common\Tools;%StudioDir%\VC98\bin
set LIB=H:\mssdk06\lib;%StudioDir%\VC98\mfc\lib;%StudioDir%\VC98\lib;%LIB%
rem set LIB=%LIB%;E:\ae\libvc96;H:\mssdk09\lib;%FrameworkSDKDir%lib;H:\DDK\7000\lib\mfc\i386;H:\DDK\7000\lib\crt\i386;H:\DDK\7000\lib\atl\i386
set INCLUDE=H:\mssdk06\include;H:\mssdk06\include\atl;H:\mssdk06\include\mfc;H:\mssdk06\include\crt;%INCLUDE%
rem set INCLUDE=H:\mssdk06\include;%INCLUDE%;%StudioDir%\VC98\atl\include;%StudioDir%\VC98\mfc\include;%StudioDir%\VC98\include
set StudioDir=
rem
if not "%silent%"=="yes" echo Environment varibles set for Visual Studio 6.
goto done
rem --------------------------------------------------------------------------
:vc8
set VCSettings=%VC8Settings%
set HomeVCSettings=%HomeVC8Settings%
set VCName=VS2005
set FrameworkVersion=v2.0.50727
set FrameworkSDKDir=H:\VS2005\SDK\v2.0\
:vc9
set VCLib=
set AMD64=
REM
REM Set the build environment for Visual Studio 200x (VC9), target 32-bit x86
REM
set FrameworkDir=%SystemRoot%\Microsoft.NET\Framework\
REM 
REM Need path %FrameworkDir%%FrameworkVersion% for gac, caspol, ilasm, regasm
REM
set VSInstallDir=H:\%VCName%\
set VCInstallDir=%VSInstallDir%VC\
set PATH=H:\mssdk09\bin;%FrameworkSDKDir%Bin;%VCInstallDir%bin;%VSInstallDir%Common7\Tools;%VSInstallDir%Common7\IDE;%VCInstallDir%vcpackages;%FrameworkDir%%FrameworkVersion%;%PATH%
REM Use PE+ versions of tools
if not "%ProgramFiles(x86)%"=="" set PATH=H:\mssdk09\bin\X64;H:\mssdk09\bin\win64\X64;%PATH%
set LIB=%LIB%;H:\mssdk09\lib;%FrameworkSDKDir%lib;%VCInstallDir%lib;%VCInstallDir%atlmfc\lib
set LIBPATH=%FrameworkDir%%FrameworkVersion%;%VCInstallDir%atlmfc\lib
set INCLUDE=%INCLUDE%;H:\mssdk09\include;%FrameworkSDKDir%include;%VCInstallDir%include;%VCInstallDir%atlmfc\include
REM
if "%force%"=="yes" goto force_vc9
cmp -s "%VCSettings%\VCComponents_Alan_vc9.dat" "%VCSettings%\VCComponents.dat"
if %ERRORLEVEL% EQU 0 goto done
:force_vc9
cp "%VCSettings%\VCComponents_Alan_vc9.dat" "%VCSettings%\VCComponents.dat"
rem BUG: Race condition causes Exit to occur before /ResetSettings
rem start /wait devenv.exe /ResetSettings "%HomeVCSettings%\Alan_vc9.vssettings" /Command Exit
rem python "%HomeVCSettings%\SpliceSettings.py" %1
if not "%silent%"=="yes" echo Environment varibles set for %VCName%, target x86.
rem if not "%silent%"=="yes" echo Be sure to run the %VCName% GUI at least once!
goto done
rem --------------------------------------------------------------------------
:vc8x64
set VCSettings=%VC8Settings%
set HomeVCSettings=%HomeVC8Settings%
set VCName=VS2005
set FrameworkVersion=v2.0.50727
set FrameworkSDKDir=H:\VS2005\SDK\v2.0\
:vc9x64
set VCLib=
set AMD64=1
REM
REM Set the build environment for VC9, target AMD64/EMT64 (x64), use VC9 DLLs
REM
set FrameworkDir=%SystemRoot%\Microsoft.NET\Framework64\
REM 
REM Need path %FrameworkDir%%FrameworkVersion% for gac, caspol, ilasm, regasm
REM
set VSInstallDir=H:\%VCName%\
set VCInstallDir=%VSInstallDir%VC\
set PATH=H:\mssdk09\bin;%FrameworkSDKDir%Bin;%VCInstallDir%bin\x86_amd64;%VCInstallDir%bin;%VSInstallDir%Common7\Tools;%VSInstallDir%Common7\IDE;%VCInstallDir%vcpackages;%FrameworkDir%%FrameworkVersion%;%PATH%
REM Use PE+ versions of tools
if not "%ProgramFiles(x86)%"=="" set PATH=H:\mssdk09\bin\X64;H:\mssdk09\bin\win64\X64;%PATH%
set LIB=H:\mssdk09\lib\x64;%FrameworkSDKDir%lib\amd64;%VCInstallDir%lib\amd64;%VCInstallDir%atlmfc\lib\amd64
set LIBPATH=%FrameworkDir%%FrameworkVersion%;%VCInstallDir%atlmfc\lib\amd64
set INCLUDE=H:\mssdk09\include;%FrameworkSDKDir%include;%VCInstallDir%include;%VCInstallDir%atlmfc\include;%INCLUDE%
REM
if "%force%"=="yes" goto force_vc8x64
cmp -s "%VCSettings%\VCComponents_Alan_vc9.dat" "%VCSettings%\VCComponents.dat"
if %ERRORLEVEL% EQU 0 goto done
:force_vc8x64
cp "%VCSettings%\VCComponents_Alan_vc9.dat" "%VCSettings%\VCComponents.dat"
rem BUG: Race condition causes Exit to occur before /ResetSettings
rem start /wait devenv.exe /ResetSettings "%HomeVCSettings%\Alan_vc9.vssettings" /Command Exit
rem python "%HomeVCSettings%\SpliceSettings.py" %1
if not "%silent%"=="yes" echo Environment varibles set for %VCName%, target x64
rem if not "%silent%"=="yes" echo Be sure to run the %VCName% GUI at least once!
goto done
rem --------------------------------------------------------------------------
:vc86
set VCSettings=%VC8Settings%
set HomeVCSettings=%HomeVC8Settings%
set VCName=VS2005
set VCLib=E:\ae\libvc86
set FrameworkVersion=v2.0.50727
set FrameworkSDKDir=H:\VS2005\SDK\v2.0\
:vc96
set AMD64=
REM
REM Set the build environment for Visual Studio 200x (VC9), target 32-bit x86
REM Use backward-compatible DLLs (MFC42, MSVCRT)
REM
REM Uses Visual Studio 200x (VC9) compiler, but with VC6 includes and libraries.
REM The VC6 Includes were updated for 32/64-bit in \DDK\7000\
REM
set FrameworkDir=%SystemRoot%\Microsoft.NET\Framework\
REM 
REM Need path %FrameworkDir%%FrameworkVersion% for gac, caspol, ilasm, regasm
REM
set VSInstallDir=H:\%VCName%\
set VCInstallDir=%VSInstallDir%VC\
set PATH=H:\mssdk09\bin;%FrameworkSDKDir%Bin;%VCInstallDir%bin;%VSInstallDir%Common7\Tools;%VSInstallDir%Common7\IDE;%VCInstallDir%vcpackages;%FrameworkDir%%FrameworkVersion%;%PATH%
if not "%ProgramFiles(x86)%"=="" set PATH=H:\mssdk09\bin\X64;H:\mssdk09\bin\win64\X64;%PATH%
rem
set StudioDir=G:\DevStudio
set LIB=%LIB%;%VCLib%;H:\mssdk09\lib;%FrameworkSDKDir%lib;%StudioDir%\VC98\mfc\lib;%StudioDir%\VC98\lib
rem Cannot use the following - missing H:\DDK\7000\bin\msvcrtd.dll
rem set LIB=%LIB%;%VCLib%;H:\mssdk09\lib;%FrameworkSDKDir%lib;H:\DDK\7000\lib\crt\i386;H:\DDK\7000\lib\atl\i386;H:\DDK\7000\lib\mfc\i386
set LIBPATH=%FrameworkDir%%FrameworkVersion%
set INCLUDE=H:\mssdk09\include;H:\DDK\7000\inc\crt;H:\DDK\7000\inc\mfc42;H:\DDK\7000\inc\atl30;H:\DDK\7000\inc\api\crt\stl60;%FrameworkSDKDir%include;%INCLUDE%
set StudioDir=
REM
if "%force%"=="yes" goto force_vc86
cmp -s "%VCSettings%\VCComponents_Alan_vc96.dat" "%VCSettings%\VCComponents.dat"
if %ERRORLEVEL% EQU 0 goto done
:force_vc86
cp "%VCSettings%\VCComponents_Alan_vc96.dat" "%VCSettings%\VCComponents.dat"
rem BUG: Race condition causes Exit to occur before /ResetSettings
rem start /wait devenv.exe /ResetSettings "%HomeVCSettings%\Alan_vc96.vssettings" /Command Exit
rem python "%HomeVCSettings%\SpliceSettings.py" %1
if not "%silent%"=="yes" echo Environment varibles set for Visual Studio 2005 w/VC6 include and lib
rem if not "%silent%"=="yes" echo Be sure to run the %VCName% GUI at least once!
goto done
rem --------------------------------------------------------------------------
:vc86x64
set VCSettings=%VC8Settings%
set HomeVCSettings=%HomeVC8Settings%
set VCName=VS2005
set FrameworkVersion=v2.0.50727
set FrameworkSDKDir=H:\VS2005\SDK\v2.0\
:vc96x64
set VCLib=
set AMD64=1
REM
REM Set the build environment for VC, target 64-bit x64 (W2K3 x64 and XP x64)
REM
REM Uses the Visual Studio 200x (VC9) compiler, but with the VC6 includes and
REM mssdk06 libs.  The VC6 Includes were updated for 32/64-bit in \DDK\7000\
REM
set FrameworkDir=%SystemRoot%\Microsoft.NET\Framework64\
REM 
REM Need path %FrameworkDir%%FrameworkVersion% for gac, caspol, ilasm, regasm
REM
set VSInstallDir=H:\%VCName%\
set VCInstallDir=%VSInstallDir%VC\
set PATH=H:\mssdk06\bin;%FrameworkSDKDir%Bin;H:\mssdk06\bin\win64\x86\AMD64;%VCInstallDir%bin;%VSInstallDir%Common7\Tools;%VSInstallDir%Common7\IDE;%VCInstallDir%vcpackages;%FrameworkDir%%FrameworkVersion%;%PATH%
rem Cannot use the VS200x compiler because it generates unref symbols
rem set PATH=H:\mssdk09\bin;%FrameworkSDKDir%Bin;%VCInstallDir%bin\x86_amd64;%VCInstallDir%bin;%VSInstallDir%Common7\Tools;%VSInstallDir%Common7\IDE;%VCInstallDir%vcpackages;%FrameworkDir%%FrameworkVersion%;%PATH%
REM Use PE+ versions of tools
if not "%ProgramFiles(x86)%"=="" set PATH=H:\mssdk09\bin\X64;H:\mssdk09\bin\win64\X64;%PATH%
rem
set LIB=H:\mssdk06\lib\AMD64;%FrameworkSDKDir%lib\amd64;H:\mssdk06\lib\amd64\atlmfc;H:\mssdk06\lib\amd64
rem Cannot use the following - missing H:\DDK\7000\bin\amd64\msvcrtd.dll
rem set LIB=%LIB%;%VCLib%;H:\mssdk09\lib;%FrameworkSDKDir%lib;H:\DDK\7000\lib\crt\amd64;H:\DDK\7000\lib\atl\amd64;H:\DDK\7000\lib\mfc\amd64
set LIBPATH=%FrameworkDir%%FrameworkVersion%
set INCLUDE=H:\mssdk06\include;H:\mssdk06\include\mfc;H:\mssdk06\include\atl;H:\mssdk06\include\crt;%FrameworkSDKDir%include;%INCLUDE%
rem Cannot use the following
rem set INCLUDE=H:\mssdk09\include;H:\DDK\7000\inc\crt;H:\DDK\7000\inc\mfc42;H:\DDK\7000\inc\atl30;H:\DDK\7000\inc\api\crt\stl60;%FrameworkSDKDir%include;%INCLUDE%
REM
if "%force%"=="yes" goto force_vc86x64
cmp -s "%VCSettings%\VCComponents_Alan_vc96.dat" "%VCSettings%\VCComponents.dat"
if %ERRORLEVEL% EQU 0 goto done
:force_vc86x64
cp "%VCSettings%\VCComponents_Alan_vc96.dat" "%VCSettings%\VCComponents.dat"
rem BUG: Race condition causes Exit to occur before /ResetSettings
rem start /wait devenv.exe /ResetSettings "%HomeVCSettings%\Alan_vc96.vssettings" /Command Exit
rem python "%HomeVCSettings%\SpliceSettings.py" %1
if not "%silent%"=="yes" echo Environment varibles set for %VCName%, target x64, with libs for MSVCRT x64 and MFC x64
rem if not "%silent%"=="yes" echo Be sure to run the %VCName% GUI at least once!
goto done
rem --------------------------------------------------------------------------
:w32
set watcom=d:\watcom
set edpath=%watcom%\eddat
set path=%watcom%\bin;%watcom%\binb;%watcom%\binw;%path%
set include=%include%;%watcom%\h;%watcom%\h\win
set lib=%lib%
goto done
:w32_win32s
set watcom=d:\watcom
set edpath=%watcom%\eddat
set toolrootdir=d:\msdev
set path=%watcom%\bin;%watcom%\binb;%path%
rem set lib=%lib%;%toolrootdir%\lib;%toolrootdir%\mfc\lib
set lib=%lib%
set include=%include%;%watcom%\h;%watcom%\h\nt
goto done
:w32_nt
set watcom=d:\watcom
set edpath=%watcom%\eddat
set toolrootdir=d:\msdev
set path=%watcom%\binnt;%watcom%\bin;%watcom%\binb;%path%
set lib=%lib%;%toolrootdir%\lib;%toolrootdir%\mfc\lib
set include=%include%;%watcom%\h;%watcom%\h\nt;%toolrootdir%\h;%toolrootdir%\mfc\include
set cpu=i386
goto done
:w32_os2
set watcom=d:\watcom
set edpath=%watcom%\eddat
set path=%watcom%\bin;%watcom%\binb;h:\toolkit\os2bin;%path%
set lib=%lib%
set include=.;%watcom%\h;h:\toolkit\c\os2h
goto done
:done
set VC8Settings=
set VC9Settings=
set VCSettings=
set HomeVC8Settings=
set HomeVC9Settings=
set HomeVCSettings=
set VCName=
set VCLib=
set silent=
set force=
exit /b 0
