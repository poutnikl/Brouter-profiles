#!/bin/bash

# ***********************************************************************
# * 
# * Ported from Windows batch for automated Brouter segment file download
# https://raw.githubusercontent.com/poutnikl/Brouter-profiles/master/Brouter_wget_segments_CZ.cmd
# * 
# * Usage:
# * 
# *
# * Set segmentdownloadfolder variable to the local folder of your choice
# * where the rd5 file are to be stored
# *
# * For each segment tile of interest put below the command line
# * getrd5file <longitude> <latitude>
# * e.g. 
# * getrd5file E10 N45  download grid segment file E10_N45.rd5

# * 
# * Files are downloaded only if they do not exist locally or if newer than local ones.
# * 
# * 
# ***********************************************************************

websegments=http://brouter.de/brouter/segments4
segmentdownloadfolder=~/Downloads/segments4

function getrd5file {
# %1 = lon  E5,E10,   %2=lat

wget -N --limit-rate=1M $websegments/$1_$2.rd5
}

# ***********************************************************************
# * This is example download job set I use
# * It downloads nonexistent or newer files 
# ***********************************************************************

cd $segmentdownloadfolder

getrd5file E0 N40 
getrd5file E0 N45 
getrd5file E5 N40 
getrd5file E5 N45 
getrd5file E5 N50
getrd5file E10 N40
getrd5file E10 N45
getrd5file E10 N50
getrd5file E15 N40
getrd5file E15 N45
getrd5file E15 N50
getrd5file E15 N40 
getrd5file E20 N45 
getrd5file E20 N50 
getrd5file E5 N35 
getrd5file E5 N40 
