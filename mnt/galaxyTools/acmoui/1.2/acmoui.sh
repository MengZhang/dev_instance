#! /bin/bash

modeloutputfiles=$1
cropModel=$2
acmoOutput=$3

echo Model Output Files: $modeloutputfiles
echo Crop Model: $cropModel
echo ACMO Output: $acmoOutput

INSTALL_DIR=/mnt/galaxyTools/acmoui/1.2
acmoui=acmoui-1.2-SNAPSHOT-beta7.jar

ln -sf $INSTALL_DIR/$acmoui .

cp $modeloutputfiles modeloutputfiles
#tar xvzf modeloutputfiles .
unzip -o -q modeloutputfiles -d output/
java -Xms256m -Xmx512m -jar $acmoui -cli -$cropModel "output" "./output"

cd output
files=`ls *.csv`
for file in $files
do 
  mv $file $acmoOutput
done

exit
