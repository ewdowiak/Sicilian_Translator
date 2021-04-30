#!/bin/bash

OTDIR="./se31_multi"

PREPENSC="data-prep-ensc"
PREPSCEN="data-prep-scen"
DATARAW="data-raw"
DATASBW="data-sbw"
DATATKN="data-tkn"
DATAM2M="data-m2m"
SUBWORDS="subwords"
PIECES="data-sbw/pieces"

rm -rf ${OTDIR}/${PREPENSC}
rm -rf ${OTDIR}/${PREPSCEN}
rm -rf ${OTDIR}/${DATARAW}
rm -rf ${OTDIR}/${DATASBW}
rm -rf ${OTDIR}/${DATATKN}
rm -rf ${OTDIR}/${DATAM2M}
#rm -rf ${OTDIR}/${SUBWORDS}
#rm -rf ${OTDIR}/${PIECES}

mkdir ${OTDIR}/${PREPENSC}
mkdir ${OTDIR}/${PREPSCEN}
mkdir ${OTDIR}/${DATARAW}
mkdir ${OTDIR}/${DATASBW}
mkdir ${OTDIR}/${DATATKN}
mkdir ${OTDIR}/${DATAM2M}
#mkdir ${OTDIR}/${SUBWORDS}
mkdir ${OTDIR}/${PIECES}
