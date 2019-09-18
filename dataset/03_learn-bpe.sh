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

NUM_OP=1500
VCB_TH=1

CODES_SC="sicilian/subwords.sc"
CODES_EN="sicilian/subwords.en"
## CODES="sicilian/subwords.scen"

TRAIN_SC="sicilian_raw/train.sc"
TRAIN_EN="sicilian_raw/train.en"
VALID_SC="sicilian_raw/valid.sc"
VALID_EN="sicilian_raw/valid.en"
TEST_SC="sicilian_raw/test.sc"
TEST_EN="sicilian_raw/test.en"

TRAIN_BPE_SC="sicilian/train.sc"
TRAIN_BPE_EN="sicilian/train.en"
VALID_BPE_SC="sicilian/valid.sc"
VALID_BPE_EN="sicilian/valid.en"
TEST_BPE_SC="sicilian/test.sc"
TEST_BPE_EN="sicilian/test.en"

VOCAB_SC="sicilian/vocab_bpe.sc"
VOCAB_EN="sicilian/vocab_bpe.en"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

subword-nmt learn-bpe -s $NUM_OP < $TRAIN_SC > $CODES_SC
subword-nmt learn-bpe -s $NUM_OP < $TRAIN_EN > $CODES_EN

subword-nmt apply-bpe -c $CODES_SC < $TRAIN_SC | subword-nmt get-vocab > $VOCAB_SC
subword-nmt apply-bpe -c $CODES_EN < $TRAIN_EN | subword-nmt get-vocab > $VOCAB_EN

subword-nmt apply-bpe -c $CODES_SC --vocabulary $VOCAB_SC --vocabulary-threshold $VCB_TH < $TRAIN_SC > $TRAIN_BPE_SC
subword-nmt apply-bpe -c $CODES_EN --vocabulary $VOCAB_EN --vocabulary-threshold $VCB_TH < $TRAIN_EN > $TRAIN_BPE_EN

subword-nmt apply-bpe -c $CODES_SC --vocabulary $VOCAB_SC --vocabulary-threshold $VCB_TH < $VALID_SC > $VALID_BPE_SC
subword-nmt apply-bpe -c $CODES_EN --vocabulary $VOCAB_EN --vocabulary-threshold $VCB_TH < $VALID_EN > $VALID_BPE_EN

subword-nmt apply-bpe -c $CODES_SC --vocabulary $VOCAB_SC --vocabulary-threshold $VCB_TH < $TEST_SC > $TEST_BPE_SC
subword-nmt apply-bpe -c $CODES_EN --vocabulary $VOCAB_EN --vocabulary-threshold $VCB_TH < $TEST_EN > $TEST_BPE_EN
