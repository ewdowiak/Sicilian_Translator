#!/bin/bash

PREPPED="data-prep-scen"

VALID_SOURCE="data-sbw/m2e_valid_v2-sbw_sc-only.sc"
VALID_TARGET="data-sbw/m2e_valid_v2-sbw_sc-only.en"

PARAMS="tnf_scen_c00/params.best"
OUTPUT="tnf_scen_c01"

MAX_NUM_EPOCHS="25"
CHECKPOINT_INTERVAL="1000"

INITIAL_LEARNING_RATE="0.00025"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

MAX_SEQ_LEN="100"
#BATCH_SIZE="20"
#BATCH_TYPE="sentence"
BATCH_SIZE="1024"
BATCH_TYPE="word"

ENCODER="transformer"
DECODER="transformer"

NUM_LAYERS="4"
NUM_EMBED="384"

TRANSFORMER_MODEL_SIZE="384"
TRANSFORMER_ATTENTION_HEADS="6"
TRANSFORMER_FEED_FORWARD_NUM_HIDDEN="1536"

EMBED_DROPOUT="0.40"
TRANSFORMER_DROPOUT_ATTENTION="0.20"
TRANSFORMER_DROPOUT_ACT="0.20"
TRANSFORMER_DROPOUT_PREPOST="0.20"

LABEL_SMOOTHING="0.10"

OPTIMIZER="adam"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sockeye-train --prepared-data ${PREPPED} \
              --validation-source ${VALID_SOURCE} --validation-target ${VALID_TARGET} \
	      --output ${OUTPUT} \
 	      --params ${PARAMS} \
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
	      --quiet \
	      --use-cpu &
