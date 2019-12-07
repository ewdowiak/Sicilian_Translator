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

CODES_SC="subwords/subwords.sc"
CODES_EN="subwords/subwords.en"

TEST_SC="test-data/test-data_AS38-AS39_v1-tkn.sc"
TEST_EN="test-data/test-data_AS38-AS39_v1-tkn.en"

TEST_BPE_SC="test-data/test-data_AS38-AS39_v2-sbw.sc"
TEST_BPE_EN="test-data/test-data_AS38-AS39_v2-sbw.en"

subword-nmt apply-bpe -c $CODES_SC < $TEST_SC > $TEST_BPE_SC
subword-nmt apply-bpe -c $CODES_EN < $TEST_EN > $TEST_BPE_EN
