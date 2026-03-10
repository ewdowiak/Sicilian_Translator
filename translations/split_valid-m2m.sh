#!/bin/bash

##  Copyright 2021-2026 Eryk Wdowiak
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

##  parameters
NUM_OP_SC=5000
NUM_OP_EN=7500
NUM_OP_IT=5000
#VCB_TH=10

##  ##  ##  ##  ##  ##  ##  ##  ##  #
#  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  directories
BASE_DIR="./"
RAW_DIR="${BASE_DIR}/validation"
FNL_DIR="${BASE_DIR}/validation"
SBW_DIR="../subwords"

##  subwords
CODES_SC="${SBW_DIR}/subwords.sc"
CODES_EN="${SBW_DIR}/subwords.en"
CODES_IT="${SBW_DIR}/subwords.it"

##  vocabulary
VOCAB_SC="${SBW_DIR}/vocab_bpe.sc"
VOCAB_EN="${SBW_DIR}/vocab_bpe.en"
VOCAB_IT="${SBW_DIR}/vocab_bpe.it"

##  input files
E2S_VALID_SCEN_EN="${RAW_DIR}/m2m_valid_v1-tkn_p01-ensc.src"
S2E_VALID_SCEN_SC="${RAW_DIR}/m2m_valid_v1-tkn_p02-scen.src"
I2E_VALID_ITEN_IT="${RAW_DIR}/m2m_valid_v1-tkn_p03-iten.src"
E2I_VALID_ITEN_EN="${RAW_DIR}/m2m_valid_v1-tkn_p04-enit.src"
I2S_VALID_SCIT_IT="${RAW_DIR}/m2m_valid_v1-tkn_p05-itsc.src"
S2I_VALID_SCIT_SC="${RAW_DIR}/m2m_valid_v1-tkn_p06-scit.src"

##  output files
E2S_VALID_BPE_SCEN_EN="${FNL_DIR}/m2m_valid_v2-sbw_p01-ensc.src"
S2E_VALID_BPE_SCEN_SC="${FNL_DIR}/m2m_valid_v2-sbw_p02-scen.src"
I2E_VALID_BPE_ITEN_IT="${FNL_DIR}/m2m_valid_v2-sbw_p03-iten.src"
E2I_VALID_BPE_ITEN_EN="${FNL_DIR}/m2m_valid_v2-sbw_p04-enit.src"
I2S_VALID_BPE_SCIT_IT="${FNL_DIR}/m2m_valid_v2-sbw_p05-itsc.src"
S2I_VALID_BPE_SCIT_SC="${FNL_DIR}/m2m_valid_v2-sbw_p06-scit.src"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  apply byte-pair encoding

subword-nmt apply-bpe -c $CODES_EN < $E2S_VALID_SCEN_EN  > $E2S_VALID_BPE_SCEN_EN
subword-nmt apply-bpe -c $CODES_SC < $S2E_VALID_SCEN_SC  > $S2E_VALID_BPE_SCEN_SC

subword-nmt apply-bpe -c $CODES_IT < $I2E_VALID_ITEN_IT  > $I2E_VALID_BPE_ITEN_IT
subword-nmt apply-bpe -c $CODES_EN < $E2I_VALID_ITEN_EN  > $E2I_VALID_BPE_ITEN_EN

subword-nmt apply-bpe -c $CODES_IT < $I2S_VALID_SCIT_IT  > $I2S_VALID_BPE_SCIT_IT
subword-nmt apply-bpe -c $CODES_SC < $S2I_VALID_SCIT_SC  > $S2I_VALID_BPE_SCIT_SC

##  fix the directional token

sed -i 's/<@@ 2@@ sc@@ >/<2sc>/;s/<@@ 2@@ en@@ >/<2en>/;s/<@@ 2@@ it@@ >/<2it>/;s/<@@ 2@@ i@@ t@@ >/<2it>/' $E2S_VALID_BPE_SCEN_EN
sed -i 's/<@@ 2@@ sc@@ >/<2sc>/;s/<@@ 2@@ en@@ >/<2en>/;s/<@@ 2@@ it@@ >/<2it>/;s/<@@ 2@@ i@@ t@@ >/<2it>/' $S2E_VALID_BPE_SCEN_SC

sed -i 's/<@@ 2@@ sc@@ >/<2sc>/;s/<@@ 2@@ en@@ >/<2en>/;s/<@@ 2@@ it@@ >/<2it>/;s/<@@ 2@@ i@@ t@@ >/<2it>/' $I2E_VALID_BPE_ITEN_IT
sed -i 's/<@@ 2@@ sc@@ >/<2sc>/;s/<@@ 2@@ en@@ >/<2en>/;s/<@@ 2@@ it@@ >/<2it>/;s/<@@ 2@@ i@@ t@@ >/<2it>/' $E2I_VALID_BPE_ITEN_EN

sed -i 's/<@@ 2@@ sc@@ >/<2sc>/;s/<@@ 2@@ en@@ >/<2en>/;s/<@@ 2@@ it@@ >/<2it>/;s/<@@ 2@@ i@@ t@@ >/<2it>/' $I2S_VALID_BPE_SCIT_IT
sed -i 's/<@@ 2@@ sc@@ >/<2sc>/;s/<@@ 2@@ en@@ >/<2en>/;s/<@@ 2@@ it@@ >/<2it>/;s/<@@ 2@@ i@@ t@@ >/<2it>/' $S2I_VALID_BPE_SCIT_SC
