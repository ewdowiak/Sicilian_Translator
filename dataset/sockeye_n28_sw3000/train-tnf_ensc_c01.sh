#!/bin/bash

PREPPED="scn20200906-prep-ensc"

VALID_SOURCE="scn20200906-sw3000/test-data_AS38-AS39_v2-sbw.en"
VALID_TARGET="scn20200906-sw3000/test-data_AS38-AS39_v2-sbw.sc"

PARAMS="tnf_ensc_c00/params.best"
OUTPUT="tnf_ensc_c01"

MAX_NUM_EPOCHS="20"
CHECKPOINT_INTERVAL="725"

INITIAL_LEARNING_RATE="0.00015"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

MAX_SEQ_LEN="200"
BATCH_SIZE="20"
BATCH_TYPE="sentence"

ENCODER="transformer"
DECODER="transformer"

NUM_LAYERS="3"
NUM_EMBED="256"

TRANSFORMER_MODEL_SIZE="256"
TRANSFORMER_ATTENTION_HEADS="4"
TRANSFORMER_FEED_FORWARD_NUM_HIDDEN="1024"

EMBED_DROPOUT="0.50"
TRANSFORMER_DROPOUT_ATTENTION="0.25"
TRANSFORMER_DROPOUT_ACT="0.25"
TRANSFORMER_DROPOUT_PREPOST="0.25"

LABEL_SMOOTHING="0.10"

OPTIMIZER="adam"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sockeye-train --prepared-data ${PREPPED} \
              --validation-source ${VALID_SOURCE} --validation-target ${VALID_TARGET} \
	      --params ${PARAMS} \
	      --output ${OUTPUT} \
	      --batch-size ${BATCH_SIZE} --batch-type ${BATCH_TYPE} \
	      --max-num-epochs ${MAX_NUM_EPOCHS} \
	      --checkpoint-interval ${CHECKPOINT_INTERVAL} \
	      --encoder ${ENCODER} --decoder ${DECODER} \
	      --max-seq-len ${MAX_SEQ_LEN} \
	      --transformer-model-size ${TRANSFORMER_MODEL_SIZE} \
	      --transformer-attention-heads ${TRANSFORMER_ATTENTION_HEADS} \
	      --transformer-feed-forward-num-hidden ${TRANSFORMER_FEED_FORWARD_NUM_HIDDEN} \
	      --num-embed ${NUM_EMBED} \
	      --num-layers ${NUM_LAYERS} \
	      --initial-learning-rate ${INITIAL_LEARNING_RATE} \
	      --layer-normalization \
	      --label-smoothing ${LABEL_SMOOTHING} \
	      --optimizer ${OPTIMIZER} \
	      --embed-dropout ${EMBED_DROPOUT} \
	      --transformer-dropout-attention ${TRANSFORMER_DROPOUT_ATTENTION} \
	      --transformer-dropout-act ${TRANSFORMER_DROPOUT_ACT} \
	      --transformer-dropout-prepost ${TRANSFORMER_DROPOUT_PREPOST} \
	      --use-cpu &
