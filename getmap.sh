#!/bin/bash

#https://stackoverflow.com/questions/255898/how-to-iterate-over-arguments-in-a-bash-script 
##  https://www.vionblog.com/linux-delete-files-older-than-x-days/
# find /path/to/files/ -type f -name '*.jpg' -mtime +30 -exec rm {} \;


webaddr=https://osm.paws.cz
pawsaddr=https://osm.paws.cz
oamaddr=http://download.openandromaps.org/maps/europe
oam4addr=http://download.openandromaps.org/mapsV4/europe
#downloadfolder=~/Downloads
downloadfolder=~/storage/shared/Locus/mapsVector

websegments=http://brouter.de/brouter/segments4
segmentdownloadfolder=~/storage/shared/Brouter/segments4
andaddr=https://download.osmand.net
testfile=Anguilla_centralamerica_2.obf.zip
anddl=~/storage/shared/OSMAnd/files
test=https://download.osmand.net/Anguilla_centralamerica_2.obf.zip

function getfile { #web #localfile #webfile(opt)
echo "$@"
cd $downloadfolder
maxdayage=60
file2=${3:-$2}
echo wget -N $1/$file2
if test -f  $2
then
find $downloadfolder/  -type f -name $2 -mtime +$maxdayage -exec wget -N $1/$file2 \;
else
wget -N $1/$file2
fi
if [ "$2" != "$file2" ] 
then
	if test -f $file2
	then
	unzip $file2 -o
	rm  $file2
	fi
fi
}

function getpaws {
getfile  "$pawsaddr"  "$@" 
}

function getoam {
getfile  "$oamaddr"  "$@" 
}

function getoam4 {
getfile  "$oam4addr"  "$@" 
}


function getrd5file {
cd $segmentdownloadfolder
rd5file=$1_$2.rd5
maxdayage=20
if test -f $rd5file
then
find $segmentdownloadfolder/  -type f -name $rd5file -mtime +$maxdayage -exec wget -N --limit-rate=10M $websegments/$rd5file \;
else
wget -N --limit-rate=10M $websegments/$rd5file
fi
}

for var in "$@"
do

#   https://www.shellscript.sh/case.html

    case $var in
    	0)
	getrd5file E15 N45
    	;;
	1)
    	getrd5file E10 N45
	getrd5file E10 N50
	getrd5file E15 N50
    	;;
	2)
    	getrd5file E10 N40
	getrd5file E15 N40
	getrd5file E20 N40 
	getrd5file E20 N45 
	getrd5file E20 N50 
    	;;
	3)
    	getrd5file E0 N40 
	getrd5file E0 N45 
	getrd5file E0 N50
	getrd5file E5 N40 
	getrd5file E5 N45 
	getrd5file E5 N50
    	;;
	4)
    	getrd5file E20 N50 
	getrd5file E20 N55
	getrd5file E25 N50
	getrd5file E25 N55 
    	;;
	9)
	getrd5file W20 N30
	;;
	cz)
	getpaws czech_republic_gccz.map
	;;
	sk)
	getpaws slovakia_gccz.map
	;;
	at)
	getpaws austria_gccz.map
	;;
	ato)
	getoam Austria.map Austria.zip
	;;
	at4)
	getoam4 Austria_ML.map Austria.zip
	;;
	ee)
	getoam4 Estonia_ML.map Estonia.zip
	getoam4 Latvia_ML.map Latvia.zip
	getoam4 Lithuania_ML.map Lithuania.zip
	;;
	sa)
	getpaws sachsen_gccz.map
	;;
	ba)
	getpaws bayern_gccz.map
	;;
	ine)
	getpaws nord_est_gccz.map
	;;
	inw)
	getpaws nord_ovest_gccz.map
	;;
	cr)
	getpaws croatia_gccz.map
	;;
	sl)
	getpaws slovenia_gccz.map
	;;
	hu)
	getpaws hungary_gccz.map
	;;
	sw)
	getpaws switzerland_gccz.map
	;;
	uk)
	getpaws ukraine_gccz.map
	;;
	pl)
	getpaws poland_gccz.map poland_gccz.map.zip
	;;
	*)      echo "Unknown code"
		;;
    esac

done

