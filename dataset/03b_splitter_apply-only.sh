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

##  Byte-Pair Encoding with Sennrich et al's "subword-nmt"
##    *  https://github.com/rsennrich/subword-nmt

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

NUM_OP=3000
VCB_TH=6

RAW_DIR="sockeye_n28_sw3000/scn20200906-raw"
FNL_DIR="sockeye_n28_sw3000/scn20200906-sw3000"
TST_DIR="sockeye_n28_sw3000/test-data"

CODES_SC="${FNL_DIR}/subwords.sc"
CODES_EN="${FNL_DIR}/subwords.en"

TRAIN_SC="${RAW_DIR}/train-mparamu_v1-tkn.sc"
#TRAIN_SC="${RAW_DIR}/train-mparamu-vocab_v1-tkn.sc"
TRAIN_EN="${RAW_DIR}/train-mparamu_v1-tkn.en"
#VALID_SC="${RAW_DIR}/valid.sc"
#VALID_EN="${RAW_DIR}/valid.en"
TEST_SC="${RAW_DIR}/test-data_AS38-AS39_v1-tkn.sc"
TEST_EN="${RAW_DIR}/test-data_AS38-AS39_v1-tkn.en"

TRAIN_BPE_SC="${FNL_DIR}/train-mparamu.sc"
#TRAIN_BPE_SC="${FNL_DIR}/train-mparamu-vocab.sc"
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

#subword-nmt learn-bpe -s $NUM_OP < $TRAIN_SC > $CODES_SC
#subword-nmt learn-bpe -s $NUM_OP < $TRAIN_EN > $CODES_EN

#subword-nmt apply-bpe -c $CODES_SC < $TRAIN_SC | subword-nmt get-vocab > $VOCAB_SC
#subword-nmt apply-bpe -c $CODES_EN < $TRAIN_EN | subword-nmt get-vocab > $VOCAB_EN

subword-nmt apply-bpe -c $CODES_SC --vocabulary $VOCAB_SC --vocabulary-threshold $VCB_TH < $TRAIN_SC > $TRAIN_BPE_SC
subword-nmt apply-bpe -c $CODES_EN --vocabulary $VOCAB_EN --vocabulary-threshold $VCB_TH < $TRAIN_EN > $TRAIN_BPE_EN

#subword-nmt apply-bpe -c $CODES_SC --vocabulary $VOCAB_SC --vocabulary-threshold $VCB_TH < $VALID_SC > $VALID_BPE_SC
#subword-nmt apply-bpe -c $CODES_EN --vocabulary $VOCAB_EN --vocabulary-threshold $VCB_TH < $VALID_EN > $VALID_BPE_EN

subword-nmt apply-bpe -c $CODES_SC --vocabulary $VOCAB_SC --vocabulary-threshold $VCB_TH < $TEST_SC > $TEST_BPE_SC
subword-nmt apply-bpe -c $CODES_EN --vocabulary $VOCAB_EN --vocabulary-threshold $VCB_TH < $TEST_EN > $TEST_BPE_EN

cp $TEST_BPE_SC $TEST_DIR_SC
cp $TEST_BPE_EN $TEST_DIR_EN
