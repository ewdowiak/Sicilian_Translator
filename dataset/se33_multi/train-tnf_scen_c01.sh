#!/bin/bash

##  Copyright 2021 Eryk Wdowiak
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

PREPPED="data-prep-scen"

VALID_SOURCE="data-sbw/m2e_valid_v2-sbw.sc"
VALID_TARGET="data-sbw/m2e_valid_v2-sbw.en"

PARAMS="tnf_scen_c00/params.best"
OUTPUT="tnf_scen_c01"

DEVICE_IDS="-2"

MAX_NUM_EPOCHS="7"
CHECKPOINT_INTERVAL="2000"

INITIAL_LEARNING_RATE="0.00020"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

#MAX_SEQ_LEN="200"
#BATCH_SIZE="20"
#BATCH_TYPE="sentence"

MAX_SEQ_LEN="100"
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
	      --device-ids ${DEVICE_IDS} \
	      --decode-and-evaluate -1 \
	      --quiet &
