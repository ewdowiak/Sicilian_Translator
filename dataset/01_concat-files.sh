#!/bin/bash

##  Eryk Wdowiak
##  04 August 2020

##  script to concatenate raw parallel text files

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

INDIR="dataset"
OTDIR="sockeye_n30_sw3000/parallels-raw"

TESTFL="test-data_AS38-AS39_v0-raw"
INFILES=(
    "AS27-40-dieli_v0-raw"
    "cheats"
    "mparamu_2020-02-08_v0-raw"
    "mparamu_2020-05-03_v0-raw"
    "bonner-b01_2020-08-22_v0-raw"
    "bonner-b02_2020-09-05_v0-raw"
    "AS-ext03-b01_2020-08-04_v0-raw"
    "AS-ext03-b02_2020-08-22_v0-raw"
    "AS-ext03-b03_2020-08-30_v0-raw"
    "AS-ext03-b04_2020-09-06_v0-raw"
)
OTFILE="train-mparamu_v0-raw"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

for LG in "sc" "en"; do
    cp ${INDIR}/${TESTFL}.${LG} ${OTDIR}/${TESTFL}.${LG}
    rm -f ${OTDIR}/${OTFILE}.${LG}
    for (( IDX = 0; IDX < ${#INFILES[@]}; IDX++ )) ; do
	cat ${INDIR}/${INFILES[$IDX]}.${LG} >> ${OTDIR}/${OTFILE}.${LG}
    done
done

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

exit 0
