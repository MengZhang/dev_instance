#! /bin/bash

#if [ $# -ne 7 ]
#then
#  echo "Usage: `basename $0` {dssat input} {dssat output}"
#  exit -1
#fi

title=$1
zipfile=$2
ttype=$3
tformat=$4
variable=$5
pngoutput=$6
acmooutput=$7


cp $zipfile $PWD/1.zip
unzip 1.zip

command -V R >/dev/null 2>&1 || { echo >&2 " 'R' is required by this tool was not found on past";exit 1;}

INSTALL_DIR=/mnt/galaxyTools/ria_standardplots/1.0.0
ria_standardplots_batch=$INSTALL_DIR/ria_standardplots_batch.r

xvfb-run -a R --no-save --vanilla --slave --args "$title" $PWD $ttype $tformat $variable $pngoutput $acmooutput< $ria_standardplots_batch

exit
