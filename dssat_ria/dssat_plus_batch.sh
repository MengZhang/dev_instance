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
echo Running in $PWD

# Setup QuadUI
#INSTALL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALL_DIR=/mnt/galaxyTools/quadui/1.3.3
quadui=quadui-1.3.3.jar
ln -sf $INSTALL_DIR/$quadui

# Setup ACMOUI
INSTALL_DIR=/mnt/galaxyTools/acmoui/1.2
acmoui=acmoui-1.2-SNAPSHOT-beta7.jar
ln -sf $INSTALL_DIR/$acmoui .

# Setup DSSAT model
INSTALL_DIR=/mnt/galaxyTools/dssat_ria/4.5
cp $INSTALL_DIR/dssat_aux.tgz dssat_aux.tgz
tar xvzf dssat_aux.tgz

# Prepare JSON files
cp -f $JsonInput $PWD/json.zip
unzip -o -q json.zip -d json/
mkdir result
cd json
for file in *.json; do
{
	filename="${file%.*}"
	mkdir ../output/$filename
	cp -f $filename.json $PWD/output/$filename/1.json
}
done
cd..

# Prepare Cultivar files
if [ "$CultivarInput" != "N/A" ]
then
  cp -f $CultivarInput $PWD/cul.zip
  unzip -o -q cul.zip -d cul/
  if [ -d "$PWD/cul/dssat_specific" ]
  then
  else
  	echo "[Warn] Could not find dssat_specific diretory in the cultivar package, will using default cultivar loaded in the system"
  fi
fi

# Loop all the input JSON file
cd result
for dir in */; do
{
	cd $dir
	batchId=${dir%/}
	echo $batchId
	
	# Run QuadUI
	java -jar ../../$quadui -cli -clean -n -D 1.json $PWD
	
	# Setup Cultivar files
	if [ -d "$PWD/cul/dssat_specific" ]
  then
    cp -f $PWD/cul/dssat_specific/* $PWD/DSSAT/.
  else
  fi
  
  # Generate output zip package for DSSAT input files
	cd DSSAT
	zip -r -q ../../retIn_$batchId.zip *
	cd ..
	
	# Setup DSSAT model
	cp -f ../../dssat_aux/* .
	cp -f $PWD/DSSAT/* .
	
	# Run DSSAT model
	DSCSM045.EXE b DSSBatch.v45 DSCSM045.CTR 
	
	# Generate the output zip package for DSSAT output files
	mkdir output
	mv -f *.OUT output
	mv -f ACMO_meta.dat output
	cd output
	zip -r -q ../../retOut_$batchId.zip *
	cd ..
	
	# Run ACMOUI
	java -Xms256m -Xmx512m -jar ../../$acmoui -cli -dssat "output" "../../"
}
done
dir
cd ..

cp retIn.zip $dssatInput
cp retOut.zip $dssatOutput

# Generate the output for ACMO result CSV file
cd output
files=`ls *.csv`
for file in $files
do 
  mv $file $AcmoOutput
done
cd ..

exit 0
