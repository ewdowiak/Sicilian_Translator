#!/bin/bash

SETRANS="/home/soul/.local/bin/sockeye-translate"
MDL_ENSC="tnf_ensc_c01"
#CKPTS="--checkpoints 35"
CKPTS=""

INPUT_EN="test-data/test-data_AS38-AS39_v2-sbw.en"
OTPUT_SC="test-data/test-data_AS38-AS39_v4-tns.sc"

${SETRANS} --models ${MDL_ENSC} ${CKPTS} --input ${INPUT_EN} --output ${OTPUT_SC} --use-cpu 2> /dev/null
/bin/sed -i -r 's/(@@ )|(@@ ?$)//g' ${OTPUT_SC}
