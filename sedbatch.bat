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

%sedexe% -b -e  "s/\(assign\s\+iswet\s\+\)0/\11/gi" Trekking-Poutnik.brf > Trekking-Wet.brf

%sedexe% -b -e  "s/\(assign\s\+MTB_factor\s\+\)0.0/\10.2/gi" Trekking-Poutnik.brf > Trekking-MTB-light.brf
%sedexe% -b -e  "s/\(assign\s\+MTB_factor\s\+\)0.0/\10.5/gi" Trekking-Poutnik.brf > Trekking-MTB-medium.brf
%sedexe% -b -e  "s/\(assign\s\+MTB_factor\s\+\)0.0/\11.0/gi" Trekking-Poutnik.brf > Trekking-MTB-strong.brf
%sedexe% -b -e  "s/\(assign\s\+MTB_factor\s\+\)0.0/\1-0.5/gi" Trekking-Poutnik.brf > Trekking-Fast.brf

%sedexe% -b -e  "s/\(assign\s\+iswet\s\+\)0/\11/gi" Trekking-MTB-light.brf > Trekking-MTB-light-wet.brf
%sedexe% -b -e  "s/\(assign\s\+iswet\s\+\)0/\11/gi" Trekking-MTB-medium.brf > Trekking-MTB-medium-wet.brf
%sedexe% -b -e  "s/\(assign\s\+iswet\s\+\)0/\11/gi" Trekking-MTB-strong.brf >  Trekking-MTB-strong-wet.brf
%sedexe% -b -e  "s/\(assign\s\+iswet\s\+\)0/\11/gi" Trekking-Fast.brf >  Trekking-Fast-wet.brf

%sedexe% -b -e  "s/\(assign\s\+MTB_factor\s\+\)0.0/\12.0/gi" Trekking-Poutnik.brf | %sedexe% -b -e  "s/\(assign\s\+smallpaved_factor\s\+\)0.0/\1-0.5/gI"  > MTB.brf
%sedexe% -b -e  "s/\(assign\s\+MTB_factor\s\+\)0.0/\11.0/gi" Trekking-Poutnik.brf | %sedexe% -b -e  "s/\(assign\s\+smallpaved_factor\s\+\)0.0/\1-0.3/gI"  > MTB-light.brf
%sedexe% -b -e  "s/\(assign\s\+iswet\s\+\)0/\11/gi" MTB.brf > MTB-wet.brf
%sedexe% -b -e  "s/\(assign\s\+iswet\s\+\)0/\11/gi" MTB-light.brf > MTB-light-wet.brf

%sedexe% -b -e  "s/\(assign\s\+cycleroutes_pref\s\+\)0.2/\10.0/gi" Trekking-Poutnik.brf > Trekking-ICR.brf

%sedexe% -b -e  "s/\(assign\s\+routelevel\s\+\)2/\14/gi" Trekking-Poutnik.brf > Trekking-CRsame.brf

%sedexe% -b -e  "s/\(assign\s\+cycleroutes_pref\s\+\)0.2/\10.6/gi" Trekking-Poutnik.brf > Trekking-FCR.brf
%sedexe% -b -e  "s/\(assign\s\+routelevel\s\+\)2/\14/gi" Trekking-FCR.brf > Trekking-FCR-CRsame.brf

%sedexe% -b -e  "s/\(assign\s\+MTB_factor\s\+\)0.0/\1-1.7/gi" Trekking-Poutnik.brf | %sedexe% -b -e  "s/\(assign\s\+smallpaved_factor\s\+\)0.0/\12.0/g" > Trekking-SmallRoads.brf
%sedexe% -b -e  "s/\(assign\s\+iswet\s\+\)0/\11/gi" Trekking-SmallRoads.brf > Trekking-SmallRoads-wet.brf

del Trekking-Poutnik.brf

%zipexe% a ..\BR-Trekking-Profiles.zip *.brf

del *.brf
cd ..
rd .\sedwdir
