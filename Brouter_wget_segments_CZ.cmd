@echo off
rem ***********************************************************************
rem * 
rem * Windows batch for automated Brouter segment file download
rem * 
rem * Usage:
rem * 
rem * Get and install Wget for windows from link below, if not done yet.
rem * Set Wget variable to pathname of wget.exe
rem *
rem * Set segmentdownloadfolder variable to your choice
rem * If needed in future, modify rest of variables
rem *
rem * For each segment tile of interest put below the command line
rem * call :subwget <longitude> <latitude> [b]
rem * call :subwget E10 N45 b  download grid segment file 
rem * call :subwget E10 N45    downloads nothing
rem * 
rem * Files are downloaded only if not exist locally or if newer than local ones.
rem * 
rem * Wget for Windows can be obtained here..
rem * http://gnuwin32.sourceforge.net/packages/wget.htm
rem * 
rem ***********************************************************************

set wget=S:\utils\GnuWin32\bin\wget.exe -N
set websegments=http://brouter.de/brouter/segments4
set segmentdownloadfolder=s:\downloads\segments4

rem ***********************************************************************
rem * This is example download job set I use
rem * It downloads nonexistent or newer files 
rem ***********************************************************************

call :subwget E0 N40 
call :subwget E0 N45 
call :subwget E5 N40 
call :subwget E5 N45 
call :subwget E5 N50
call :subwget E10 N45 b
call :subwget E10 N50 b
call :subwget E15 N45 b
call :subwget E15 N50 b
call :subwget E15 N40 
call :subwget E20 N45 
call :subwget E20 N50 
call :subwget E5 N35 
call :subwget E5 N40 
pause

exit /b

:subwget
rem %1 = lon  E5,E10,   %2=lat

cd /D %segmentdownloadfolder%

if "%3"=="b"  %wget% %websegments%/%1_%2%.rd5


exit /b
