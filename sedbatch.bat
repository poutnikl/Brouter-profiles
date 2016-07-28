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



set sedexe=c:\cygwin64\bin\sed.exe
set wgetexe=c:\cygwin64\bin\wget.exe
set zipexe=C:\bin64\7-Zip\7z.exe

md .\wdir
cd .\wdir

%wgetexe% https://raw.githubusercontent.com/poutnikl/Trekking-Poutnik/master/Trekking-Poutnik.brf

%sedexe% -b -e  "s/assign   iswet                  0/assign   iswet                  0/g" Trekking-Poutnik.brf > Trekking-Dry.brf
%sedexe% -b -e  "s/assign   iswet                  0/assign   iswet                  1/g" Trekking-Poutnik.brf > Trekking-Wet.brf
%sedexe% -b -e  "s/assign   MTB_factor             0.0/assign   MTB_factor             0.2/g" Trekking-Poutnik.brf > Trekking-MTB-light.brf
%sedexe% -b -e  "s/assign   MTB_factor             0.0/assign   MTB_factor             0.5/g" Trekking-Poutnik.brf > Trekking-MTB-medium.brf
%sedexe% -b -e  "s/assign   MTB_factor             0.0/assign   MTB_factor             1.0/g" Trekking-Poutnik.brf > Trekking-MTB-strong.brf

%sedexe% -b -e  "s/assign   cycleroutes_pref       0.2/assign   cycleroutes_pref       0.0/g" Trekking-Poutnik.brf > Trekking-ICR.brf

%sedexe% -b -e  "s/assign   routelevel             2/assign   routelevel             4/g" Trekking-Poutnik.brf > Trekking-sameCR.brf

%sedexe% -b -e  "s/assign   cycleroutes_pref       0.2/assign   cycleroutes_pref       0.6/g" Trekking-Poutnik.brf > Trekking-CR.brf

%sedexe% -b -e  "s/assign   iswet                  0/assign   iswet                  1/g" Trekking-MTB-light.brf > Trekking-MTB-light-wet.brf
%sedexe% -b -e  "s/assign   iswet                  0/assign   iswet                  1/g" Trekking-MTB-medium.brf > Trekking-MTB-medium-wet.brf
%sedexe% -b -e  "s/assign   iswet                  0/assign   iswet                  1/g"  Trekking-MTB-strong.brf >  Trekking-MTB-strong-wet.brf

%sedexe% -b -e  "s/assign   MTB_factor             0.0/assign   MTB_factor             -0.5/g" Trekking-Poutnik.brf > Trekking-fast.brf
%sedexe% -b -e  "s/assign   iswet                  0/assign   iswet                  1/g"  Trekking-fast.brf >  Trekking-fast-wet.brf

%sedexe% -b -e  "s/assign   MTB_factor             0.0/assign   MTB_factor             2.0/g" Trekking-Poutnik.brf > auxiliary.brf
%sedexe% -b -e  "s/assign   smallpaved_factor      0.0/assign   smallpaved_factor      -0.5/g" auxiliary.brf > MTB.brf
del auxiliary.brf

%sedexe% -b -e  "s/assign   MTB_factor             0.0/assign   MTB_factor             1.0/g" Trekking-Poutnik.brf > auxiliary.brf
%sedexe% -b -e  "s/assign   smallpaved_factor      0.0/assign   smallpaved_factor      -0.3/g" auxiliary.brf > MTB-light.brf
del auxiliary.brf

%sedexe% -b -e  "s/assign   iswet                  0/assign   iswet                  1/g" MTB.brf > MTB-wet.brf
%sedexe% -b -e  "s/assign   iswet                  0/assign   iswet                  1/g" MTB-light.brf > MTB-light-wet.brf

%sedexe% -b -e  "s/assign   MTB_factor             0.0/assign   MTB_factor             -1.7/g" Trekking-Poutnik.brf > auxiliary.brf
%sedexe% -b -e  "s/assign   smallpaved_factor      0.0/assign   smallpaved_factor      2.0/g" auxiliary.brf > Trekking-SmallRoads.brf
del auxiliary.brf

%sedexe% -b -e  "s/assign   iswet                  0/assign   iswet                  1/g" Trekking-SmallRoads.brf > Trekking-SmallRoads-wet.brf

%zipexe% a ..\BR-Trekking-Profiles.zip *.brf

del *.brf
cd ..
rd .\wdir


 
