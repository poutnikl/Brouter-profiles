@echo off
rem ***********************************************************************
rem * 
rem * Windows batch for automated  file download
rem * Usage:
rem * Get and install Wget and 7-zip for Windows from link below, if not done yet.
rem * Set variables to pathname of wget.exe and 7z.exe
rem * Set variables for download and extract folders
rem *
rem * Wget for Windows can be obtained here..
rem * http://gnuwin32.sourceforge.net/packages/wget.htm
rem *
rem * 7-zip for Windows can be obtained here..
rem * http://www.7-zip.org
rem * 
rem ***********************************************************************

rem if set to yes, running has pause breakpoints to debug
set debug=no

set wget=S:\utils\GnuWin32\bin\wget.exe -N
rem folder where ZIpped map files are downloaded
set downloadfolder=s:\downloads

set zip=c:\bin64\7-Zip\7z.exe

rem yes      makes the script to extract map from zip files to spefified folder
rem no       keeps ZIP files and exist or skip to next download
set ExtractZipAfterDownload=yes

rem yes      makes the script to delete temporary zip files after zip extract, to save place
rem no       keeps ZIP files to allow conditional downloading of updated file only 
set DeleteZipAfterExtract=no

set whost=http://download.osmand.net/
set wprefix="download.php?standard=yes&file="

rem For non Europian counties, use suffix accordingly 
rem to applicable continent name used in http://download.osmand.net/rawindexes/
set wsuffix=_europe_2.obf.zip

rem folder where ZIpped map files areautomatically extracted
set extractfolder=M:\OSMSH\

cd /D %downloadfolder%

rem Put "y" at the end of line to enable processing
rem remove"y" at the end of line to temporary disable processing
rem Remove lines not needed at all
rem Add lines that are missing, based on naming convention at http://download.osmand.net/rawindexes/

rem for tests, as it is small
call :get Albania 0


call :get Czech-republic 
call :get Czech-republic_partials 
call :get Austria
call :get Slovakia 
call :get Hungary
call :get Gb_england
call :get Gb_england_partials
call :get Netherlands
call :get Netherlands_partials
call :get Germany_partials
call :get France_partials
call :get Italy_partials


if %debug%==yes pause
exit /b

:get
if not %2==y exit /b
if %1==Czech-republic_partials goto getCzech-republic 
if %1==Germany_partials goto getGermany
if %1==France_partials goto getFrance
if %1==Italy_partials goto getItaly
if %1==Gb_england_partials goto getGb_england
if %1==Netherlands_partials goto getNetherlands


call :subwget %1
exit /b


:getCzech-republic
call :subwget Czech-republic_jihovychod
call :subwget Czech-republic_jihozapad
call :subwget Czech-republic_moravskoslezsko
call :subwget Czech-republic_praha
call :subwget Czech-republic_severovychod
call :subwget Czech-republic_severozapad
call :subwget Czech-republic_stredni-cechy
call :subwget Czech-republic_stredni-morava
exit /b

:getGermany
call :subwget Germany_baden-wuerttemberg
call :subwget Germany_bayern
call :subwget Germany_berlin
call :subwget Germany_brandenburg
call :subwget Germany_bremen
call :subwget Germany_hamburg
call :subwget Germany_hessen
call :subwget Germany_mecklenburg-vorpommern
call :subwget Germany_niedersachsen
call :subwget Germany_nordrhein-westfalen
call :subwget Germany_rheinland-pfalz
call :subwget Germany_saarland
call :subwget Germany_sachsen-anhalt
call :subwget Germany_sachsen
call :subwget Germany_schleswig-holstein
call :subwget Germany_thueringen
exit /b

:getFrance
call :subwget France_alsace
call :subwget France_aquitaine
call :subwget France_auvergne
call :subwget France_basse-normandie
call :subwget France_bourgogne
call :subwget France_bretagne
call :subwget France_centre
call :subwget France_champagne-ardenne
call :subwget France_corse
call :subwget France_franche-comte
call :subwget France_haute-normandie
call :subwget France_ile-de-france
call :subwget France_languedoc-roussillon
call :subwget France_limousin
call :subwget France_lorraine
call :subwget France_midi-pyrenees
call :subwget France_nord-pas-de-calais
call :subwget France_pays-de-la-loire
call :subwget France_picardie
call :subwget France_poitou-charentes
call :subwget France_provence-alpes-cote-d-azur
call :subwget France_rhone-alpes
exit /b

:getItaly
call :subwget Italy_abruzzo
call :subwget Italy_basilicata
call :subwget Italy_calabria
call :subwget Italy_campania
call :subwget Italy_emilia-romagna
call :subwget Italy_friuli-venezia-giulia
call :subwget Italy_lazio
call :subwget Italy_liguria
call :subwget Italy_lombardia
call :subwget Italy_marche
call :subwget Italy_molise
call :subwget Italy_piemonte
call :subwget Italy_puglia
call :subwget Italy_sardegna
call :subwget Italy_sicilia
call :subwget Italy_toscana
call :subwget Italy_trentino-alto-adige
call :subwget Italy_umbria
call :subwget Italy_valle-aosta
call :subwget Italy_veneto
exit /b

:getGb_england
call :subwget Gb_england_channel-islands
call :subwget Gb_england_east-midlands
call :subwget Gb_england_east-of-england
call :subwget Gb_england_greater-london
call :subwget Gb_england_north-east-england
call :subwget Gb_england_north-west-england
call :subwget Gb_england_south-east-england
call :subwget Gb_england_south-west-england
call :subwget Gb_england_west-midlands
call :subwget Gb_england_yorkshire-and-the-humber
exit /b


:getNetherlands
call :subwget Netherlands_drenthe
call :subwget Netherlands_flevoland
call :subwget Netherlands_friesland
call :subwget Netherlands_gelderland
call :subwget Netherlands_groningen
call :subwget Netherlands_limburg
call :subwget Netherlands_noord-brabant
call :subwget Netherlands_noord-holland
call :subwget Netherlands_overijssel
call :subwget Netherlands_utrecht
call :subwget Netherlands_zeeland
call :subwget Netherlands_zuid-holland
exit /b

:subwget


set URL=%whost%%wprefix%%1%wsuffix%
set localfile=%wprefix%%1%wsuffix%

echo URL=%whost%%wprefix%%1%wsuffix%
echo  localfile=%wprefix%%1%wsuffix%
if %debug%==yes pause
%wget%  %URL%
if %debug%==yes pause
if not %ExtractZipAfterDownload%==yes exit /b
echo %zip% e %localfile% -o%extractfolder% -y
if %debug%==yes pause
%zip% e %localfile% -o%extractfolder% -y
if %debug%==yes pause
if not %DeleteZipAfterExtract%==yes exit /b
if %debug%==yes pause
del %localfile%
exit /b
