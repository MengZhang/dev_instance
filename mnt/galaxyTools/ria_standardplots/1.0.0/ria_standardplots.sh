#! /bin/bash

#if [ $# -ne 7 ]
#then
#  echo "Usage: `basename $0` {dssat input} {dssat output}"
#  exit -1
#fi

title=$1
ttype=$2
tformat=$3
variable=$4
confinput=$5
pngoutput=$6
acmooutput=$7


command -V R >/dev/null 2>&1 || { echo >&2 " 'R' is required by this tool was not found on past";exit 1;}

INSTALL_DIR=/mnt/galaxyTools/ria_standardplots/1.0.0
ria_standardplots=$INSTALL_DIR/ria_standardplots.r

xvfb-run -a R --no-save --vanilla --slave --args "$title" $ttype $tformat $variable $confinput $pngoutput $acmooutput< $ria_standardplots

exit
