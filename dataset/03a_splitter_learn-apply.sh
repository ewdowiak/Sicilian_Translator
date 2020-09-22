#!/bin/bash

##  Copyright 2020 Eryk Wdowiak
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

##  Byte-Pair Encoding with Sennrich et al's "subword-nmt"
##    *  https://github.com/rsennrich/subword-nmt

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

NUM_OP=3000

BASE_DIR="sockeye_n29_sw3000"

RAW_DIR="${BASE_DIR}/parallels-raw"
FNL_DIR="${BASE_DIR}/parallels-sw3000"
TST_DIR="${BASE_DIR}/test-data"
SBW_DIR="${BASE_DIR}/subwords"

CODES_SC="${SBW_DIR}/subwords.sc"
CODES_EN="${SBW_DIR}/subwords.en"

TRAIN_VOCAB_SC="${RAW_DIR}/train-mparamu-vocab_v1-tkn.sc"
TRAIN_SC="${RAW_DIR}/train-mparamu_v1-tkn.sc"
TRAIN_EN="${RAW_DIR}/train-mparamu_v1-tkn.en"
#VALID_SC="${RAW_DIR}/valid.sc"
#VALID_EN="${RAW_DIR}/valid.en"
TEST_SC="${RAW_DIR}/test-data_AS38-AS39_v1-tkn.sc"
TEST_EN="${RAW_DIR}/test-data_AS38-AS39_v1-tkn.en"

TRAIN_BPE_SC="${FNL_DIR}/train-mparamu.sc"
TRAIN_BPE_EN="${FNL_DIR}/train-mparamu.en"
#VALID_BPE_SC="${FNL_DIR}/valid.sc"
#VALID_BPE_EN="${FNL_DIR}/valid.en"
TEST_BPE_SC="${FNL_DIR}/test-data_AS38-AS39_v2-sbw.sc"
TEST_BPE_EN="${FNL_DIR}/test-data_AS38-AS39_v2-sbw.en"

TEST_DIR_SC="${TST_DIR}/test-data_AS38-AS39_v2-sbw.sc"
TEST_DIR_EN="${TST_DIR}/test-data_AS38-AS39_v2-sbw.en"

VOCAB_SC="${FNL_DIR}/vocab_bpe.sc"
VOCAB_EN="${FNL_DIR}/vocab_bpe.en"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

subword-nmt learn-bpe -s $NUM_OP < $TRAIN_VOCAB_SC > $CODES_SC
subword-nmt learn-bpe -s $NUM_OP < $TRAIN_EN > $CODES_EN

subword-nmt apply-bpe -c $CODES_SC < $TRAIN_SC > $TRAIN_BPE_SC
subword-nmt apply-bpe -c $CODES_EN < $TRAIN_EN > $TRAIN_BPE_EN

#subword-nmt apply-bpe -c $CODES_SC < $VALID_SC > $VALID_BPE_SC
#subword-nmt apply-bpe -c $CODES_EN < $VALID_EN > $VALID_BPE_EN

subword-nmt apply-bpe -c $CODES_SC < $TEST_SC > $TEST_BPE_SC
subword-nmt apply-bpe -c $CODES_EN < $TEST_EN > $TEST_BPE_EN

cp $TEST_BPE_SC $TEST_DIR_SC
cp $TEST_BPE_EN $TEST_DIR_EN

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
