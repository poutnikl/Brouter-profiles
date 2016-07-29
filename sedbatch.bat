@echo off

rem windows batch to automatically generate a bunch of Brouter profiles for bicycle
rem based on the the profile template by Poutnik

rem Linux users should be easily able modify the batch to create the Linux sh script
rem as I am not good in unix shell scripts.

Rem When the batch is launched, 
rem   1/  it create a working subfolder in a folder where the script resides
rem   2/  it downloads latest Trekking-Poutnik.brf template from GitHub depository
rem   3/  it generates end user profiles by automatic subtitution of the modifiers
rem   4/  it packs them into a single ZIP archive BR-Trekking-Profiles.zip and deletes the working subfolder.

rem prerequisities for windows

rem 1/  Install CygWin ( https://www.cygwin.com/ ), or alternative ( like GNUWinNN ] to have available UNIX utilities sed.exe and wget.exe
rem        In case of Cygwin, they should be present on folder c:\cygwin64\bin, resp. c:\cygwin32\bin
rem        If not, install within cygwin setup.exe these utilities as non default one.

rem 2/  Install 7-zip from http://www.7-zip.org/download.html

rem 3/  Set environment variables below to there pathnames ( junction \bin64 below is shortcut to "c:\Program files" )

rem @echo on

set sedexe=c:\cygwin64\bin\sed.exe
set wgetexe=c:\cygwin64\bin\wget.exe
set zipexe=C:\bin64\7-Zip\7z.exe

md .\sedwdir
cd .\sedwdir

%wgetexe% https://raw.githubusercontent.com/poutnikl/Trekking-Poutnik/master/Trekking-Poutnik.brf

copy Trekking-Poutnik.brf Trekking-Dry.brf


call :replace iswet 0 1 Trekking-Poutnik  Trekking-Wet

call :replace MTB_factor 0.0 0.2 Trekking-Poutnik  Trekking-MTB-light
call :replace MTB_factor 0.0 0.5 Trekking-Poutnik  Trekking-MTB-medium
call :replace MTB_factor 0.0 1.0 Trekking-Poutnik  Trekking-MTB-strong
call :replace MTB_factor 0.0 -0.5 Trekking-Poutnik  Trekking-Fast

call :replace iswet 0 1 Trekking-MTB-light Trekking-MTB-light-wet
call :replace iswet 0 1 Trekking-MTB-medium Trekking-MTB-medium-wet
call :replace iswet 0 1 Trekking-MTB-strong Trekking-MTB-strong-wet
call :replace iswet 0 1 Trekking-Fast Trekking-Fast-wet

call :replace2 MTB_factor 0.0 2.0 smallpaved_factor 0.0 -0.5  Trekking-Poutnik MTB
call :replace2 MTB_factor 0.0 1.0 smallpaved_factor 0.0 -0.3  Trekking-Poutnik MTB-light

call :replace iswet 0 1 MTB MTB-wet
call :replace iswet 0 1 MTB-light MTB-light-wet

call :replace cycleroutes_pref 0.2 0.0 Trekking-Poutnik Trekking-ICR
call :replace iswet 0 1 Trekking-ICR Trekking-ICR-wet

call :replace routelevel 2 4 Trekking-Poutnik Trekking-CRsame
call :replace iswet 0 1 Trekking-CRsame Trekking-CRsame-wet

call :replace cycleroutes_pref 0.2 0.6 Trekking-Poutnik Trekking-FCR
call :replace iswet 0 1 Trekking-FCR Trekking-FCR-wet

call :replace routelevel 2 4 Trekking-FCR Trekking-FCR-CRsame
call :replace iswet 0 1 Trekking-FCR-CRsame Trekking-FCR-CRsame-wet

call :replace2 MTB_factor 0.0 -1.7 smallpaved_factor  0.0 2.0 Trekking-Poutnik Trekking-SmallRoads
call :replace iswet 0 1 Trekking-SmallRoads Trekking-SmallRoads-wet

del Trekking-Poutnik.brf

%zipexe% a ..\BR-Trekking-Profiles.zip *.brf

del *.brf
cd ..
rd .\sedwdir

exit /b

:replace
 rem parameters 1=keyword 2=oldvalue 3=newvalue 4=oldfile but ext 5=new file but ext
echo %sedexe% -b -e  "s/\(assign\s\+%1\s\+\)%2/\1%3/gi" %4.brf > %5.brf
%sedexe% -b -e  "s/\(assign\s\+%1\s\+\)%2/\1%3/gi" %4.brf > %5.brf

exit /b

:replace2
 rem parameters 1=keyword1 2=oldvalue1 3=newvalue2 4=keyword2 5=oldvalue2 6=newvalue2 7=oldfile but ext 8=new file but ext
echo %sedexe% -b -e  "s/\(assign\s\+%1\s\+\)%2/\1%3/gi" %7.brf  | %sedexe% -b -e  "s/\(assign\s\+%4\s\+\)%5/\1%6/gi" > %8.brf
%sedexe% -b -e  "s/\(assign\s\+%1\s\+\)%2/\1%3/gi" %7.brf  | %sedexe% -b -e  "s/\(assign\s\+%4\s\+\)%5/\1%6/gi" > %8.brf

exit /b
