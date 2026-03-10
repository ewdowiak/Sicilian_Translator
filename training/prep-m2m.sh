#!/bin/bash

MAX_SEQ_LEN="400"

OUTPUT="./data-prep-m2m"
UOTPUT="./data-punb-m2m"
IOTPUT="./data-pita-m2m"
SUBWORDS="./subwords"

SOURCE="./data-sbw/m2m_train_v2-sbw.src"
TARGET="./data-sbw/m2m_train_v2-sbw.tgt"

USOURC="./data-sbw/m2m_unbal_v2-sbw.src"
UTARGT="./data-sbw/m2m_unbal_v2-sbw.tgt"

ISOURC="./data-sbw/pc71_good.src"
ITARGT="./data-sbw/pc71_good.tgt"

SRC_VOCAB="${SUBWORDS}/vocab-m2m.src.json"
TGT_VOCAB="${SUBWORDS}/vocab-m2m.trg.json"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

# sockeye-prepare-data --source ${SOURCE} --target ${TARGET} \
# 		     --max-seq-len ${MAX_SEQ_LEN} \
# 		     --output ${OUTPUT} --quiet

# cp ${OUTPUT}/vocab.src.0.json ${SRC_VOCAB}
# cp ${OUTPUT}/vocab.trg.0.json ${TGT_VOCAB}

# sockeye-prepare-data --source ${SOURCE} --target ${TARGET} \
# 		     --source-vocab ${SRC_VOCAB} --target-vocab ${TGT_VOCAB} \
# 		     --max-seq-len ${MAX_SEQ_LEN} \
# 		     --output ${OUTPUT} --quiet &

sockeye-prepare-data --source ${USOURC} --target ${UTARGT} \
		     --source-vocab ${SRC_VOCAB} --target-vocab ${TGT_VOCAB} \
		     --max-seq-len ${MAX_SEQ_LEN} \
		     --output ${UOTPUT} --quiet &

# sockeye-prepare-data --source ${ISOURC} --target ${ITARGT} \
# 		     --source-vocab ${SRC_VOCAB} --target-vocab ${TGT_VOCAB} \
# 		     --max-seq-len ${MAX_SEQ_LEN} \
# 		     --output ${IOTPUT} --quiet &

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
