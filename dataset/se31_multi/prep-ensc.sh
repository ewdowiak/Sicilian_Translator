#!/bin/bash

MAX_SEQ_LEN="250"

OUTPUT="data-prep-ensc"
SUBWORDS="subwords"

SOURCE="data-sbw/e2m_train_v2-sbw.en"
TARGET="data-sbw/e2m_train_v2-sbw.sc"

SRC_VOCAB="${SUBWORDS}/vocab.en.json"
TGT_VOCAB="${SUBWORDS}/vocab.sc.json"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sockeye-prepare-data --source ${SOURCE} --target ${TARGET} \
		     --source-vocab ${SRC_VOCAB} --target-vocab ${TGT_VOCAB} \
		     --max-seq-len ${MAX_SEQ_LEN} \
		     --output ${OUTPUT}

#cp ${OUTPUT}/vocab.src.0.json ${SUBWORDS}/vocab.en.json
#cp ${OUTPUT}/vocab.trg.0.json ${SUBWORDS}/vocab.sc.json

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
