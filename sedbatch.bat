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

rem 1/  Install CygWin ( https://www.cygwin.com/ ), or alternative ( like GNUWinNN ] 
rem     to have available Windows ports of UNIX utilities SED and WGET
rem        In case of Cygwin, they should be present on folder c:\cygwin64\bin, resp. c:\cygwin32\bin
rem        If not, install them via cygwin setup.exe, if these utilities are not default ones.

rem 2/  Install 7-zip from http://www.7-zip.org/download.html 
rem     ( optional, if you want to get zipped profiles, e.g. for mass transfer to the phone) 

rem 3/  Set environment variables below to there pathnames ( in my case, junction bin64 means c:\Program files )

rem @echo on

set sedexe=c:\cygwin64\bin\sed.exe
set wgetexe=c:\cygwin64\bin\wget.exe
set zipexe=C:\bin64\7-Zip\7z.exe



if not exist .\sedwdir md .\sedwdir
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
echo In contrary to previous %0 version, it generates independent packages for car/bike/foot profiles
pause
goto :closing

rem ******************************************************
rem     B R O U T E R   B I C Y C L E   P R O F I L E S
rem ******************************************************

:bike

set tmplpath=master

%wgetexe% https://raw.githubusercontent.com/poutnikl/Trekking-Poutnik/%tmplpath%/Trekking-Poutnik.brf

set src=Trekking-Poutnik

set legfile=Bike-Profiles-List-Legend.txt
if exist %legfile% del %legfile% 

Echo Profile name,  Profile description ( generated )  >%legfile% 

call :replace iswet 0 1 %src% %src%-wet

call :replace iswet 0 0 %src%     Poutnik-dry "Standard Trekking profile by Poutnik, for dry weather"
call :replace iswet 0 1 %src%-wet Poutnik-wet "Standard Trekking profile by Poutnik, for wet weather ( partially avoids muddy or slicky surface, but does not forbid them )"


call :replace MTB_factor 0.0 0.2  %src%  Trekking-MTB-light     "Trekking profile with light focus on unpaved roads, slightly penalizing mainroads."
call :replace MTB_factor 0.0 0.5  %src%  Trekking-MTB-medium    "Trekking profile with medium focus on unpaved roads, moderately penalizing mainroads."
call :replace MTB_factor 0.0 1.0  %src%  Trekking-MTB-strong    "Trekking profile with strong focus on unpaved roads, strongly penalizes mainroads. Similar to MTB light, that is preferred."
call :replace MTB_factor 0.0 -0.5 %src%  Trekking-Fast          "Trekking profile with moderate focus on mainroads, penalizing unpaved roads. Between Trekking and FastBike."


call :replace MTB_factor 0.0 0.2  %src%-wet  Trekking-MTB-light-wet     "Trekking wet weather profile with light focus on unpaved roads, slightly penalizing mainroads."
call :replace MTB_factor 0.0 0.5  %src%-wet  Trekking-MTB-medium-wet    "Trekking wet weather profile with medium focus on unpaved roads, moderately penalizing mainroads."
call :replace MTB_factor 0.0 1.0  %src%-wet  Trekking-MTB-strong-wet    "Trekking wet weather profile with strong focus on unpaved roads, strongly penalizes mainroads. Similar to MTB light, that is preferred."
call :replace MTB_factor 0.0 -0.5 %src%-wet  Trekking-Fast-wet          "Trekking wet weather profile with moderate focus on mainroads, penalizing unpaved roads. Between Trekking and FastBike."


call :replace2 MTB_factor 0.0 2.0 smallpaved_factor 0.0 -0.5  %src%    MTB "MTB profile, based on MTBiker feedback"
call :replace2 MTB_factor 0.0 1.0 smallpaved_factor 0.0 -0.3  %src%    MTB-light "Light MTB profile for tired bikers, based on MTBiker feedback. Preferred to Trekking-MTB-strong"

call :replace2 MTB_factor 0.0 2.0 smallpaved_factor 0.0 -0.5  %src%-wet MTB-wet "MTB wet weather profile, based on MTBiker feedback"
call :replace2 MTB_factor 0.0 1.0 smallpaved_factor 0.0 -0.3  %src%-wet MTB-light-wet "Light MTB wet weather profile for tired bikers, based on MTBiker feedback. Preferred to Trekking-MTB-strong"

call :replace cycleroutes_pref 0.2 0.0 %src%      Trekking-ICR-dry  "Trekking profile ignoring existance of cycleroutes"
call :replace cycleroutes_pref 0.2 0.0 %src%-wet  Trekking-ICR-wet  "Trekking profile ignoring existance of cycleroutes, wet weather variant"

call :replace cycleroutes_pref 0.2 0.6 %src%      Trekking-FCR-dry  "Trekking profile sticking to cycleroutes"
call :replace cycleroutes_pref 0.2 0.6 %src%-wet  Trekking-FCR-wet  "Trekking profile sticking to cycleroutes, wet weather variant"

call :replace routelevel 2 4 %src%      Trekking-CRsame             "Trekking profile increasing preference of local routes, evaluating them as long distance routes" 
call :replace routelevel 2 4 %src%-wet  Trekking-CRsame-wet         "Trekking profile increasing preference of local routes, evaluating them as long distance routes. Wet variant" 

call :replace2 cycleroutes_pref 0.2 0.6 routelevel 2 4 %src%             Trekking-FCR-CRsame          "Trekking profile sticking to cycleroutes, increasing preference of local routes, evaluating them as long distance routes" 
call :replace2 cycleroutes_pref 0.2 0.6 routelevel 2 4 %src%-wet         Trekking-FCR-CRsame-wet      "Trekking profile sticking to cycleroutes, increasing preference of local routes, evaluating them as long distance routes. Wet variant"  

call :replace2 MTB_factor 0.0 -1.7 smallpaved_factor  0.0 2.0 %src%       Trekking-SmallRoads       "Trekking profile more preferring small paved roads and tracks"
call :replace2 MTB_factor 0.0 -1.7 smallpaved_factor  0.0 2.0 %src%-wet   Trekking-SmallRoads-wet   "Trekking profile more preferring small paved roads and tracks, wet weather variant"

:skoc
del %src%*.brf

if exist ..\BR-Bike-Profiles.zip del ..\BR-Bike-Profiles.zip

if exist %zipexe%  %zipexe% a ..\BR-Bike-Profiles.zip *.brf %legfile%
if exist %zipexe%  del *.brf
if exist %zipexe%  del %legfile%

exit /b

rem ******************************************************
rem     B R O U T E R   C A R   P R O F I L E S
rem ******************************************************

:car

set tmplpath=master
%wgetexe% https://raw.githubusercontent.com/poutnikl/Car-Profile/%tmplpath%/Car-test-Template.brf
set src=Car-test-Template

rem echo on

set legfile=Car-Profiles-List-Legend.txt
if exist %legfile% del %legfile% 

set avoid_motorways=%%avoid_motorways%%
set avoid_toll=%%avoid_toll%%

Echo Profile name,  Profile description ( generated )  >%legfile% 

call :replace avoid_toll      0 1 %src% %src%-TollFree
call :replace avoid_motorways 0 1 %src% %src%-NoMotorway

call :replace2 avoid_toll      0 %avoid_toll%  avoid_motorways 0 %avoid_motorways%    %src% %src%-Locus

call :replace drivestyle 3 3 %src%  Car-Fast "Fast Car profile, estimating the fastest routes, possible with booth or vignette tolls"
call :replace drivestyle 3 1 %src%  Car-Eco "Economic Car profile, fuel saving. May be slow, as consuption minimum speed range is typically 60-80 km per h"
call :replace drivestyle 3 2 %src%  Car-FastEco "Economic but Fast Car profile, balancing speed and cost. RECOMMENDED"
call :replace drivestyle 3 0 %src%  Car-Short "Car profile, shorted ways, useless unless for technical emergency."

call :replace drivestyle 3 3 %src%-Locus Car-Fast-Locus     "Locus edition, Fast Car profile, estimating the fastest routes, possible with booth or vignette tolls"
call :replace drivestyle 3 2 %src%-Locus Car-FastEco-Locus  "Locus edition, Economic but Fast Car profile, balancing speed and cost of Fast and Eco. RECOMMENDED"
call :replace drivestyle 3 1 %src%-Locus Car-Eco-Locus      "Locus edition, Economic Car profile, fuel saving. May be slow, as consuption minimum speed range is typically 60-80 km per h"


call :replace drivestyle 3 3 %src%-TollFree  Car-Fast-TollFree      "Toll free, Fast Car profile"
call :replace drivestyle 3 2 %src%-TollFree  Car-FastEco-TollFree   "Toll free, Economic but Fast Car profile, balancing speed and cost of Fast and Eco. RECOMMENDED"
call :replace drivestyle 3 1 %src%-TollFree  Car-Eco-TollFree       "Toll free, Economic Car profile, fuel saving. May be slow, as consuption minimum speed range is typically 60-80 km per h"


call :replace drivestyle 3 3 %src%-NoMotorway  Car-Fast-NoMotorway      "Fast Car profile, Avoiding motorways\/motorroads"
call :replace drivestyle 3 2 %src%-NoMotorway Car-FastEco-NoMotorway   "Economic but Fast Car profile, balancing speed and cost of Fast and Eco. Avoiding motorways\/motorroads, RECOMMENDED"
call :replace drivestyle 3 1 %src%-NoMotorway  Car-Eco-NoMotorway       "Economic Car profile, fuel saving, Avoiding motorways\/motorroads, May be slow."
echo off

del %src%*.brf

if exist %zipexe%  %zipexe% a ..\BR-Car-Profiles.zip *.brf

if exist %zipexe%  %zipexe% a ..\BR-Car-Profiles.zip *.brf %legfile%
if exist %zipexe%  del *.brf
if exist %zipexe%  del %legfile%


exit /b

rem ******************************************************
rem     B R O U T E R   H I K I N G   P R O F I L E S
rem ******************************************************

:foot

set tmplpath=master
%wgetexe% https://raw.githubusercontent.com/poutnikl/Hiking-Poutnik/%tmplpath%/Hiking.brf

ren Hiking.brf Hiking-template.brf
set src=Hiking-template

set legfile=Hiking-Profiles-List-Legend.txt
if exist %legfile% del %legfile% 

Echo Profile name,  Profile description ( generated )  >%legfile% 

call :replace iswet 0 1 %src% %src%-wet

call :replace2 SAC_scale_limit 3 1 SAC_scale_preferred 1 0 %src%  Walking "SAC T1 - hiking - Trail well cleared, 	Area flat or slightly sloped, no fall hazard"
call :replace2 SAC_scale_limit 3 2 SAC_scale_preferred 1 1 %src%  Hiking-SAC2 "SAC T2 - mountain_hiking - Trail with continuous line and balanced ascent, Terrain partially steep, fall hazard possible, Hiking shoes recommended, Some sure footedness"
call :replace2 SAC_scale_limit 3 3 SAC_scale_preferred 1 1 %src%  Hiking-Mountain-SAC3 "SAC T3 - demanding_mountain_hiking - exposed sites may be secured, possible need of hands for balance,	Partly exposed with fall hazard, Well sure-footed, Good hiking shoes, Basic alpine experience "
call :replace2 SAC_scale_limit 3 4 SAC_scale_preferred 1 2 %src%  Hiking-Alpine-SAC4 "SAC T4 - alpine_hiking - sometimes need for hand use, Terrain quite exposed, jagged rocks, Familiarity with exposed terrain, Solid trekking boots, Some ability for terrain assessment, Alpine experience"
call :replace2 SAC_scale_limit 3 5 SAC_scale_preferred 1 3 %src%  Hiking-Alpine-SAC5 "SAC T5 - demanding_alpine_hiking - single plainly climbing up to second grade, Exposed, demanding terrain, jagged rocks,  Mountaineering boots, Reliable assessment of terrain, Profound alpine experience, Elementary knowledge of handling with ice axe and rope"
call :replace2 SAC_scale_limit 3 6 SAC_scale_preferred 1 4 %src%  Hiking-Alpine-SAC6 "SAC T6 - difficult_alpine_hiking - climbing up to second grade, Often very exposed, precarious jagged rocks, glacier with danger to slip and fall, Mature alpine experience, Familiarity with the handling of technical alpine equipment"

set src=%src%-wet

call :replace2 SAC_scale_limit 3 1 SAC_scale_preferred 1 0 %src%  Walking "SAC T1 - hiking - Wet variant"
call :replace2 SAC_scale_limit 3 2 SAC_scale_preferred 1 1 %src%  Hiking-SAC2 "SAC T2 - mountain_hiking - Wet variant"
call :replace2 SAC_scale_limit 3 3 SAC_scale_preferred 1 1 %src%  Hiking-Mountain-SAC3 "SAC T3 - demanding_mountain_hiking - Wet variant"
call :replace2 SAC_scale_limit 3 4 SAC_scale_preferred 1 2 %src%  Hiking-Alpine-SAC4 "SAC T4 - alpine_hiking - Wet variant"
call :replace2 SAC_scale_limit 3 5 SAC_scale_preferred 1 3 %src%  Hiking-Alpine-SAC5 "SAC T5 - demanding_alpine_hiking - Wet variant"
call :replace2 SAC_scale_limit 3 6 SAC_scale_preferred 1 4 %src%  Hiking-Alpine-SAC6 "SAC T6 - difficult_alpine_hiking - Wet variant"



set src=Hiking-template
del %src%*.brf

if exist %zipexe%  %zipexe% a ..\BR-Foot-Profiles.zip *.brf

if exist %zipexe%  %zipexe% a ..\BR-Foot-Profiles.zip *.brf %legfile%
if exist %zipexe%  del *.brf
if exist %zipexe%  del %legfile%


exit /b

rem ******************************************************
rem                    C L O S I N G
rem ******************************************************

:closing

if not exist %zipexe%  goto :no7zip 
del *.brf
cd ..
rd .\sedwdir

exit /b

:no7zip
echo As 7zip exe location is not set, profiles are left in sedwdir subfolder.
dir *.brf /w
cd ..
pause


exit /b

rem ******************************************************
rem     E X E C U T I V E    S U B R O U T I N E S
rem ******************************************************

:replace
rem if "%~6"=="" goto  :r1

if "%~6"=="" goto  :r1
 rem parameters 1=keyword 2=oldvalue 3=newvalue 4=oldfile but ext 5=new file but ext  6=optionally Legend
set par="s/# LEGEND/# %~6/"

%sedexe% -b -e  "s/\(assign\s\+%1\s\+\)%2/\1%3/gi" %4.brf | %sedexe% -b -e  %par% >%5.brf 
echo %5.brf, %~6 >>%legfile% 
exit /b
:r1
%sedexe% -b -e  "s/\(assign\s\+%1\s\+\)%2/\1%3/gi" %4.brf >%5.brf
exit /b

:replace2
rem parameters 1=keyword1 2=oldvalue1 3=newvalue2 4=keyword2 5=oldvalue2 6=newvalue2 7=oldfile but ext 8=new file but ext 9=optionally legend

rem if "%~9"=="" goto  :r2
if "%~9"=="" goto  :r2
set par="s/# LEGEND/# %~9/" 
%sedexe% -b -e  "s/\(assign\s\+%1\s\+\)%2/\1%3/gi" %7.brf  | %sedexe% -b -e  "s/\(assign\s\+%4\s\+\)%5/\1%6/gi" | %sedexe% -b -e  %par% >%8.brf
echo %8.brf, %~9 >>%legfile% 
exit /b
:r2 
%sedexe% -b -e  "s/\(assign\s\+%1\s\+\)%2/\1%3/gi" %7.brf  | %sedexe% -b -e  "s/\(assign\s\+%4\s\+\)%5/\1%6/gi" > %8.brf
exit /b
