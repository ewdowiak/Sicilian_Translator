#!/bin/bash

SOURCE="scn20200906-sw3000/train-mparamu.en"
TARGET="scn20200906-sw3000/train-mparamu.sc"

SRC_VOCAB="tnf_ensc_c00/vocab.src.0.json"
TGT_VOCAB="tnf_ensc_c00/vocab.trg.0.json"

MAX_SEQ_LEN="200"

OUTPUT="scn20200906-prep-ensc"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sockeye-prepare-data --source ${SOURCE} --target ${TARGET} \
		     --source-vocab ${SRC_VOCAB} --target-vocab ${TGT_VOCAB} \
		     --max-seq-len ${MAX_SEQ_LEN} \
		     --output ${OUTPUT}
