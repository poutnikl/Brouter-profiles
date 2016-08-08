@echo off

rem windows batch to automatically generate a bunch of Brouter profiles 
rem based on the bike/car/foot profile templates by Poutnik

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

if "%*"=="" goto :legend
if /i "%*"=="all" goto :all

:shiftloop

if /i "%1"=="car" call :car
if /i "%1"=="bike" call :bike
if /i "%1"=="foot" call :foot
shift
if not "%1"=="" goto :shiftloop
goto :closing

rem ******************************************************
rem                     A L L
rem ******************************************************

:all
call :car
call :bike
call :foot
goto :closing


rem ******************************************************
rem                     L E G E N D
rem ******************************************************

:legend

echo Launch the batch file %0 as "%0 [car] [bike] [foot]", or "%0 all" , where [] means optional
echo E.g. "%0 all" generates all  car + bike + foot profile packages
echo "%0 car" generates the car package, "%0 foot bike" generates foot and bike packages.
echo In contrary to previous %1 version, it generates independent packages for car/bike/foot profiles
pause
goto :closing

rem ******************************************************
rem     B R O U T E R   B I C Y C L E   P R O F I L E S
rem ******************************************************

:bike

%wgetexe% https://raw.githubusercontent.com/poutnikl/Trekking-Poutnik/master/Trekking-Poutnik.brf

set src=Trekking-Poutnik

copy %src%.brf Trekking-Dry.brf

call :replace iswet 0 1 %src% Trekking-Wet

call :replace MTB_factor 0.0 0.2 %src%  Trekking-MTB-light
call :replace MTB_factor 0.0 0.5 %src%  Trekking-MTB-medium
call :replace MTB_factor 0.0 1.0 %src%  Trekking-MTB-strong
call :replace MTB_factor 0.0 -0.5 %src%  Trekking-Fast

call :replace iswet 0 1 Trekking-MTB-light Trekking-MTB-light-wet
call :replace iswet 0 1 Trekking-MTB-medium Trekking-MTB-medium-wet
call :replace iswet 0 1 Trekking-MTB-strong Trekking-MTB-strong-wet
call :replace iswet 0 1 Trekking-Fast Trekking-Fast-wet

call :replace2 MTB_factor 0.0 2.0 smallpaved_factor 0.0 -0.5  %src% MTB
call :replace2 MTB_factor 0.0 1.0 smallpaved_factor 0.0 -0.3  %src% MTB-light

call :replace iswet 0 1 MTB MTB-wet
call :replace iswet 0 1 MTB-light MTB-light-wet

call :replace cycleroutes_pref 0.2 0.0 %src% Trekking-ICR
call :replace iswet 0 1 Trekking-ICR Trekking-ICR-wet

call :replace routelevel 2 4 %src% Trekking-CRsame
call :replace iswet 0 1 Trekking-CRsame Trekking-CRsame-wet

call :replace cycleroutes_pref 0.2 0.6 %src% Trekking-FCR
call :replace iswet 0 1 Trekking-FCR Trekking-FCR-wet

call :replace routelevel 2 4 Trekking-FCR Trekking-FCR-CRsame
call :replace iswet 0 1 Trekking-FCR-CRsame Trekking-FCR-CRsame-wet

call :replace2 MTB_factor 0.0 -1.7 smallpaved_factor  0.0 2.0 %src% Trekking-SmallRoads
call :replace iswet 0 1 Trekking-SmallRoads Trekking-SmallRoads-wet

del %src%.brf

%zipexe% a ..\BR-Bike-Profiles.zip *.brf
del *.brf

exit /b

rem ******************************************************
rem     B R O U T E R   C A R   P R O F I L E S
rem ******************************************************

:car

%wgetexe% https://raw.githubusercontent.com/poutnikl/Car-Profile/master/Car-test-Template.brf
set src=Car-test-Template

copy %src%.brf Car-Fast.brf

call :replace drivestyle 3 2 %src%% Car-FastEco
call :replace drivestyle 3 1 %src%% Car-Eco
call :replace drivestyle 3 0 %src%% Car-Short

call :replace avoid_toll 0 1 Car-Fast Car-Fast-TollFree
call :replace avoid_toll 0 1 Car-FastEco Car-FastEco-TollFree
call :replace avoid_toll 0 1 Car-Eco Car-Eco-TollFree

call :replace avoid_motorways 0 1 Car-Fast Car-Fast-NoMotorway
call :replace avoid_motorways 0 1 Car-FastEco Car-FastEco-NoMotorway
call :replace avoid_motorways 0 1 Car-Eco Car-Eco-NoMotorway

del %src%.brf

%zipexe% a ..\BR-Car-Profiles.zip *.brf
del *.brf

exit /b

rem ******************************************************
rem     B R O U T E R   H I K I N G   P R O F I L E S
rem ******************************************************

:foot

%wgetexe% https://raw.githubusercontent.com/poutnikl/Hiking-Poutnik/master/Hiking.brf

ren Hiking.brf Hiking-template.brf
set src=Hiking-template

call :replace2 SAC_scale_limit 3 1 SAC_scale_preferred 1 0 %src% Walking
call :replace2 SAC_scale_limit 3 2 SAC_scale_preferred 1 1 %src% Hiking-SAC2
call :replace2 SAC_scale_limit 3 3 SAC_scale_preferred 1 1 %src% Hiking-Mountain-SAC3
call :replace2 SAC_scale_limit 3 4 SAC_scale_preferred 1 2 %src% Hiking-Alpine-SAC4
call :replace2 SAC_scale_limit 3 5 SAC_scale_preferred 1 3 %src% Hiking-Alpine-SAC5
call :replace2 SAC_scale_limit 3 6 SAC_scale_preferred 1 4 %src% Hiking-Alpine-SAC6

call :replace iswet 0 1 Walking Walking-wet
call :replace iswet 0 1 Hiking-SAC2 Hiking-SAC2-wet
call :replace iswet 0 1 Hiking-Mountain-SAC3 Hiking-Mountain-SAC3-wet
call :replace iswet 0 1 Hiking-Alpine-SAC4 Hiking-Alpine-SAC4-wet
call :replace iswet 0 1 Hiking-Alpine-SAC5 Hiking-Alpine-SAC5-wet
call :replace iswet 0 1 Hiking-Alpine-SAC6 Hiking-Alpine-SAC6-wet

del %src%.brf

%zipexe% a ..\BR-Foot-Profiles.zip *.brf
del *.brf

exit /b

rem ******************************************************
rem                    C L O S I N G
rem ******************************************************

:closing

del *.brf
cd ..
rd .\sedwdir

exit /b

rem ******************************************************
rem     E X E C U T I V E    S U B R O U T I N E S
rem ******************************************************

:replace
 rem parameters 1=keyword 2=oldvalue 3=newvalue 4=oldfile but ext 5=new file but ext
rem echo %sedexe% -b -e  "s/\(assign\s\+%1\s\+\)%2/\1%3/gi" %4.brf > %5.brf
%sedexe% -b -e  "s/\(assign\s\+%1\s\+\)%2/\1%3/gi" %4.brf > %5.brf

exit /b

:replace2
 rem parameters 1=keyword1 2=oldvalue1 3=newvalue2 4=keyword2 5=oldvalue2 6=newvalue2 7=oldfile but ext 8=new file but ext
rem echo %sedexe% -b -e  "s/\(assign\s\+%1\s\+\)%2/\1%3/gi" %7.brf  | %sedexe% -b -e  "s/\(assign\s\+%4\s\+\)%5/\1%6/gi" > %8.brf
%sedexe% -b -e  "s/\(assign\s\+%1\s\+\)%2/\1%3/gi" %7.brf  | %sedexe% -b -e  "s/\(assign\s\+%4\s\+\)%5/\1%6/gi" > %8.brf

exit /b
