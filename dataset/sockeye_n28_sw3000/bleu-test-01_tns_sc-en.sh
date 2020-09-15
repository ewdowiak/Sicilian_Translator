#!/bin/bash

SETRANS="/home/soul/.local/bin/sockeye-translate"
MDL_SCEN="tnf_scen_c01"
#CKPTS="--checkpoints 35"
CKPTS=""

INPUT_SC="test-data/test-data_AS38-AS39_v2-sbw.sc"
OTPUT_EN="test-data/test-data_AS38-AS39_v4-tns.en"

${SETRANS} --models ${MDL_SCEN} ${CKPTS} --input ${INPUT_SC} --output ${OTPUT_EN} --use-cpu 2> /dev/null
/bin/sed -i -r 's/(@@ )|(@@ ?$)//g' ${OTPUT_EN}
