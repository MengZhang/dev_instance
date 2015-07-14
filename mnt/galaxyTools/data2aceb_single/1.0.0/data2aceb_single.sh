#!/bin/bash

dataFile=$1
acebData=$2

echo dataFile: $dataFile
echo acebData: $acebData

cp $dataFile input.zip

INSTALL_DIR=/mnt/galaxyTools/data2aceb_single/1.0.0
#"$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
aceb2quadui=$INSTALL_DIR/quadui-1.2.1-SNAPSHOT-Beta30.jar
cp -f $aceb2quadui quadui.jar
java -jar quadui.jar -cli -clean -n -aceb input.zip
cp input.aceb $acebData
