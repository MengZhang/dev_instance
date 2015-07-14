#! /bin/bash

JsonInput=$1
CultivarInput=$2
AcmoOutput=$3
dssatInput=$4
dssatOutput=$5

echo JsonInput: $JsonInput
echo CultivarInput: $CultivarInput
echo AcmoOutput: $AcmoOutput
echo dssatInput: $dssatInput
echo dssatOutput: $dssatOutput

# Setup QuadUI
#INSTALL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALL_DIR=/mnt/galaxyTools/quadui/1.3.3
quadui=quadui-1.3.3.jar
ln -sf $INSTALL_DIR/$quadui

# Run QuadUI
cp -f $JsonInput $PWD/1.json
java -jar $quadui -cli -clean -n -D 1.json $PWD

# Setup Cultivar files
if [ "$CultivarInput" != "N/A" ]
then
  cp -f $CultivarInput $PWD/cul.zip
  unzip -o -q cul.zip -d cul/
  if [ -d "./cul/dssat_specific" ]
  then
    mv -f ./cul/dssat_specific/* ./DSSAT/.
  else
    echo "[Warn] Could not find dssat_specific diretory in the cultivar package, will using default cultivar loaded in the system"
  fi
fi

# Generate output zip package for DSSAT input files
cd DSSAT
zip -r -q ../retIn.zip *
cd ..
cp retIn.zip $dssatInput

# Setup DSSAT model
INSTALL_DIR=/mnt/galaxyTools/dssat_ria/4.5
cp $INSTALL_DIR/dssat_aux.tgz dssat_aux.tgz
tar xvzf dssat_aux.tgz
mv -f ./dssat_aux/* .
mv -f ./DSSAT/* .

# Run DSSAT model
./DSCSM045.EXE b DSSBatch.v45 DSCSM045.CTR 

# Generate the output zip package for DSSAT output files
mkdir ./output
mv -f *.OUT ./output
mv -f ACMO_meta.dat ./output
cd output
zip -r -q ../retOut.zip *
cd ..
cp retOut.zip $dssatOutput

# Setup ACMOUI
INSTALL_DIR=/mnt/galaxyTools/acmoui/1.2
acmoui=acmoui-1.2-SNAPSHOT-beta7.jar
ln -sf $INSTALL_DIR/$acmoui .

# Run ACMOUI
java -Xms256m -Xmx512m -jar $acmoui -cli -dssat "output" "./output"

# Generate the output for ACMO result CSV file
cd output
files=`ls *.csv`
for file in $files
do 
  mv $file $AcmoOutput
done
cd ..

exit 0
