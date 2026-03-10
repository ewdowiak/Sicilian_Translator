#!/bin/bash

OTDIR="./se37a_multi"

PREPM2M="data-prep"
DATARAW="data-raw"
DATASBW="data-sbw"
DATATKN="data-tkn"
#DATAM2M="data-m2m"
SUBWORDS="subwords"
PIECES="data-sbw/pieces"

rm -rf ${OTDIR}/${PREPM2M}
rm -rf ${OTDIR}/${DATARAW}
rm -rf ${OTDIR}/${DATASBW}
rm -rf ${OTDIR}/${DATATKN}
#rm -rf ${OTDIR}/${DATAM2M}
#rm -rf ${OTDIR}/${SUBWORDS}
#rm -rf ${OTDIR}/${PIECES}

mkdir ${OTDIR}/${PREPM2M}
mkdir ${OTDIR}/${DATARAW}
mkdir ${OTDIR}/${DATASBW}
mkdir ${OTDIR}/${DATATKN}
#mkdir ${OTDIR}/${DATAM2M}
#mkdir ${OTDIR}/${SUBWORDS}
mkdir ${OTDIR}/${PIECES}
