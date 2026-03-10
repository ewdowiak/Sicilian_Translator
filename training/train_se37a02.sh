#!/bin/bash

#PREPPED="./data-prep-m2m"
PREPPED="./data-punb-m2m"
#PREPPED="./data-pita-m2m"

VALID_SOURCE="./data-sbw/m2m_valid_v2-sbw.src"
VALID_TARGET="./data-sbw/m2m_valid_v2-sbw.tgt"

PARAMS="tnf_m2m_se37a01/params.best"
OUTPUT="tnf_m2m_se37a02"

#DEVICE_IDS="1"
NPROC="8"

MAX_NUM_EPOCHS="5"
CHECKPOINT_INTERVAL="10000"

INITIAL_LEARNING_RATE="0.00020"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

#MAX_SEQ_LEN="200"
#BATCH_SIZE="20"
#BATCH_TYPE="sentence"

MAX_SEQ_LEN="400"
BATCH_SIZE="1024"
BATCH_TYPE="word"

ENCODER="transformer"
DECODER="transformer"

NUM_LAYERS="4"
NUM_EMBED="512"

TRANSFORMER_MODEL_SIZE="512"
TRANSFORMER_ATTENTION_HEADS="8"
TRANSFORMER_FEED_FORWARD_NUM_HIDDEN="2048"

EMBED_DROPOUT="0.20"
TRANSFORMER_DROPOUT_ATTENTION="0.10"
TRANSFORMER_DROPOUT_ACT="0.10"
TRANSFORMER_DROPOUT_PREPOST="0.10"

LABEL_SMOOTHING="0.10"

OPTIMIZER="adam"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##	      --device-ids ${DEVICE_IDS} \
##	      --use-cpu \
##	      --layer-normalization \


## sockeye-train --prepared-data ${PREPPED} \

torchrun --nproc_per_node ${NPROC} -m sockeye.train \
	      --dist \
	      --prepared-data ${PREPPED} \
	      --params ${PARAMS} \
              --validation-source ${VALID_SOURCE} --validation-target ${VALID_TARGET} \
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
	      --weight-tying-type none \
	      --label-smoothing ${LABEL_SMOOTHING} \
	      --optimizer ${OPTIMIZER} \
	      --embed-dropout ${EMBED_DROPOUT} \
	      --transformer-dropout-attention ${TRANSFORMER_DROPOUT_ATTENTION} \
	      --transformer-dropout-act ${TRANSFORMER_DROPOUT_ACT} \
	      --transformer-dropout-prepost ${TRANSFORMER_DROPOUT_PREPOST} \
	      --decode-and-evaluate -1 \
	      --quiet &
