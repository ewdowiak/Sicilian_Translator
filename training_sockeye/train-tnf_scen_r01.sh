#!/bin/bash

##  Copyright 2019 Eryk Wdowiak
##  
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##  
##      http://www.apache.org/licenses/LICENSE-2.0
##  
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

SOURCE="scn20191201-sw2000/train.sc"
TARGET="scn20191201-sw2000/train.en"
VALID_SOURCE="scn20191201-sw2000/valid.sc"
VALID_TARGET="scn20191201-sw2000/valid.en"

OUTPUT="tnf_scen_r01"

MAX_NUM_EPOCHS="25"
CHECKPOINT_INTERVAL="400"

INITIAL_LEARNING_RATE="0.0002"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

MAX_SEQ_LEN="125"
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

sockeye-train --source ${SOURCE} --target ${TARGET} \
              --validation-source ${VALID_SOURCE} --validation-target ${VALID_TARGET} \
	      --batch-size ${BATCH_SIZE} --batch-type ${BATCH_TYPE} \
	      --output ${OUTPUT} \
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
	      --use-cpu
