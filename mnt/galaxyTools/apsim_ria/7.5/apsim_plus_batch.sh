#!/bin/bash

JsonInput=$1
CultivarInput=$2
AcmoOutput=$3
apsimInput=$4
apsimOutput=$5

echo JsonInput: $JsonInput
echo CultivarInput: $CultivarInput
echo AcmoOutput: $AcmoOutput
echo apsimInput: $apsimInput
echo apsimOutput: $apsimOutput
echo Running in $PWD

# Setup QuadUI
#INSTALL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALL_DIR=/mnt/galaxyTools/quadui/1.3.3
quadui=quadui-1.3.4-beta1.jar
ln -sf $INSTALL_DIR/$quadui

# Setup ACMOUI
INSTALL_DIR=/mnt/galaxyTools/acmoui/1.2
acmoui=acmoui-1.2-SNAPSHOT-beta7.jar
ln -sf $INSTALL_DIR/$acmoui .

# Setup APSIM model
tar xfz /mnt/galaxyTools/apsim_ria/7.5/apsim.tar.gz
APSIMDIR=$PWD
export LD_LIBRARY_PATH=$APSIMDIR:$APSIMDIR/Model:$APSIMDIR/Files:$LD_LIBRARY_PATH
export PATH=$APSIMDIR:$APSIMDIR/Model:$APSIMDIR/Files:$PATH

# Prepare JSON files
cp -f $JsonInput $PWD/json.zip
unzip -o -q json.zip -d json/
mkdir result
cd json
for file in *.json; do
{
  filename="${file%.*}"
  mkdir ../result/$filename
  cp -f $filename.json ../result/$filename/1.json
}
done
cd ..

# Prepare Cultivar files
if [ "$CultivarInput" != "N/A" ]
then
  cp -f $CultivarInput $PWD/cul.zip
  unzip -o -q cul.zip -d cul/
  if [ -d "$PWD/cul/apsim_specific" ]
  then
    echo "Found APSIM cultivar files correctly"
  else
    echo "[Warn] Could not find apsim_specific diretory in the cultivar package, will using default cultivar loaded in the system"
  fi
fi

# Loop all the input JSON file
cd result
for dir in */; do
{
  cd $dir
  batchId=${dir%/}
  
  # Run QuadUI
  java -jar ../../$quadui -cli -clean -n -A $PWD/1.json $PWD
  
  # Setup Cultivar files
  if [ -d "../../cul/apsim_specific" ]
  then
    cp -f ../../cul/apsim_specific/* $PWD/APSIM/.
  fi
  
  # Generate output zip package for APSIM input files
  cd APSIM
  zip -r -q ../../retIn_$batchId.zip *
  cd ..
  
  # Setup APSIM model
  cp -f $PWD/APSIM/* .
  
  # Run APSIM model
  #mono Model/Apsim.exe AgMip.apsim >> log.out 2>/dev/null
  mono ../../Model/ApsimToSim.exe AgMip.apsim 2>/dev/null

  tmp_fifofile="./control.fifo"
  mkfifo $tmp_fifofile
  exec 6<>$tmp_fifofile
  rm $tmp_fifofile

  thread=`cat /proc/cpuinfo | grep processor | wc -l`
  echo "detect $thread cores, will use $thread threads to run APSIM"
  for ((i=0;i<$thread;i++));do 
    echo
  done >&6 

  for file in *.sim; do
  {
  	read -u6
    filename="${file%.*}"
    ../../Model/ApsimModel.exe $file >> $filename.sum 2>/dev/null
    echo >&6
  } &
  done
  wait
  exec 6>&-
  
  # Generate the output zip package for APSIM output files
  mkdir output
  mv -f *.out output
  mv -f *.sum output
  mv -f ACMO_meta.dat output
  cd output
  zip -r -q ../../retOut_$batchId.zip *
  cd ..
  
  # Run ACMOUI
  java -Xms256m -Xmx512m -jar ../../$acmoui -cli -apsim "$PWD/output"
  cp -f output/*.csv ../$batchId.csv
  
  cd ..
}
done

# Setup outputs
zip -r -q retIn.zip retIn_*
cp retIn.zip $apsimInput

zip -r -q retOut.zip retOut_*
cp retOut.zip $apsimOutput

zip -r -q acmo.zip *.csv
cp acmo.zip $AcmoOutput

cd ..

exit 0
