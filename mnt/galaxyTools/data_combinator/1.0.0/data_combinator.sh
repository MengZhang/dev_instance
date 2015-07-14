#!/bin/bash

dataPackage=$1
acebDataPackage=$2
jsonDataPackage=$3
zipFile=$4
acebData=$5
jsonData=$6

echo dataPackage: $dataPackage
echo acebDataPackage: $acebDataPackage
echo jsonDataPackage: $jsonDataPackage
echo Output Zip File: $zipFile
echo Output ACEB File: $acebData
echo Output JSON File: $jsonData

mkdir tmp
declare -i count

# read general data packages
count=0
while read line
do
  data=`echo $line|awk '{ print $1 }'`
  if [ $count -gt 0 ]
  then
  	echo data_$count: $data
    cp $data $count.zip
    mkdir tmp/$count
    unzip -o -q $count.zip -d tmp/$count/
  fi
  count=$count+1
done < "$dataPackage"

# read ACEB data packages
count=0
while read line
do
  data=`echo $line|awk '{ print $1 }'`
  if [ $count -gt 0 ]
  then
  	echo acebData_$count: $data
    cp $data tmp/$count.aceb
  fi
  count=$count+1
done < "$acebDataPackage"

# read JSON data packages
count=0
while read line
do
  data=`echo $line|awk '{ print $1 }'`
  if [ $count -gt 0 ]
  then
  	echo jsonData_$count: $data
    cp $data tmp/$count.json
  fi
  count=$count+1
done < "$jsonDataPackage"

# zip everything
cd tmp
zip -r -q ../combinedData.zip *
cd ..
cp combinedData*.zip $zipFile
#/mnt/galaxyTools/data2aceb/1.0.0/test/1.zip (for debug)

INSTALL_DIR=/mnt/galaxyTools/data2aceb/1.0.0
#"$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALL_DIR=/mnt/galaxyTools/quadui/1.3.3
quadui=quadui-1.3.3.jar
ln -sf $INSTALL_DIR/$quadui
java -jar $quadui -cli -clean -n -J "combinedData.zip"
cp combinedData*.aceb $acebData
ls
#cp combinedData.json /mnt/galaxyTools/data_combinator/1.0.0/test/1.json
cp combinedData*.json $jsonData
rm -f $quadui