#!/bin/bash
#if [$# -ne 3]
#then
#  echo "Usage: `basename $0` {futureacebdata} {baseacebdata} {climate_variable} {pngoutput}"
#  exit -1
#fi

#set -x

acmoinfo=$2
whichplot=$1
pdf=$3

command -v R >/dev/null 2>&1 || { echo >&2 "'R' is required by this tool but was not found on path"; exit 1; }

INSTALL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rctwn=$INSTALL_DIR/ctwn.R

echo $acmoinfo
#cp $acmoinfo $INSTALL_DIR

#echo $future
#cp $future $INSTALL_DIR
#echo $base
#cp $base $INSTALL_DIR

#read future data package

declare -i count
count=0
while read line
do
    data1=`echo $line|awk '{ print $1 }'`
    data2=`echo $line|awk '{ print $2_$3_$4_$5_$6_$7_$8 }'`
    if [ $count -gt 0 ]
    then
       echo data_$count: $data1 $data2
       cp -f $data1 $PWD/$data2.csv
#cp -f $data1 $data2
#unzip $data2
#for FILE in *.csv
#do
#mv "$FILE" ../$(echo "$FILE"_"$data2".csv)
#done
    fi
    count=$count+1
done < "$acmoinfo"


xvfb-run -a R --no-save --vanilla --slave --args $PWD $whichplot $pdf < $rctwn

exit
