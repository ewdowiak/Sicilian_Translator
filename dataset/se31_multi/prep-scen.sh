#!/bin/bash

MAX_SEQ_LEN="250"

OUTPUT="data-prep-scen"
SUBWORDS="subwords"

SOURCE="data-sbw/m2e_train_v2-sbw.sc"
TARGET="data-sbw/m2e_train_v2-sbw.en"

SRC_VOCAB="${SUBWORDS}/vocab.sc.json"
TGT_VOCAB="${SUBWORDS}/vocab.en.json"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sockeye-prepare-data --source ${SOURCE} --target ${TARGET} \
		     --source-vocab ${SRC_VOCAB} --target-vocab ${TGT_VOCAB} \
		     --max-seq-len ${MAX_SEQ_LEN} \
		     --output ${OUTPUT}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
