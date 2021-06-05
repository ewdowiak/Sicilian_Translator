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
BASE_DIR="se33_multi"
RAW_DIR="${BASE_DIR}/data-tkn"
FNL_DIR="${BASE_DIR}/data-sbw/pieces"
SBW_DIR="${BASE_DIR}/subwords"

##  subwords
CODES_SC="${SBW_DIR}/subwords.sc"
CODES_EN="${SBW_DIR}/subwords.en"
CODES_IT="${SBW_DIR}/subwords.it"

##  vocabulary
VOCAB_SC="${SBW_DIR}/vocab_bpe.sc"
VOCAB_EN="${SBW_DIR}/vocab_bpe.en"
VOCAB_IT="${SBW_DIR}/vocab_bpe.it"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  sicilian

E2S_TRAIN_SCEN_SC="${RAW_DIR}/e2s_train_v1-tkn_sc-en.sc"
E2S_TEXTB_SCEN_SC="${RAW_DIR}/e2s_textb_v1-tkn_sc-en.sc"
E2S_VALID_SCEN_SC="${RAW_DIR}/e2s_valid_v1-tkn_sc-en.sc"

S2E_TRAIN_SCEN_SC="${RAW_DIR}/s2e_train_v1-tkn_sc-en.sc"
S2E_TEXTB_SCEN_SC="${RAW_DIR}/s2e_textb_v1-tkn_sc-en.sc"
S2E_VALID_SCEN_SC="${RAW_DIR}/s2e_valid_v1-tkn_sc-en.sc"

#I2S_TRAIN_SCIT_SC="${RAW_DIR}/i2s_train_v1-tkn_sc-it.sc"
I2S_BACKT_SCIT_SC="${RAW_DIR}/i2s_backt_v1-tkn_sc-it.sc"
I2S_TEXTB_SCIT_SC="${RAW_DIR}/i2s_textb_v1-tkn_sc-it.sc"
I2S_VALID_SCIT_SC="${RAW_DIR}/i2s_valid_v1-tkn_sc-it.sc"

#S2I_TRAIN_SCIT_SC="${RAW_DIR}/s2i_train_v1-tkn_sc-it.sc"
S2I_BACKT_SCIT_SC="${RAW_DIR}/s2i_backt_v1-tkn_sc-it.sc"
S2I_TEXTB_SCIT_SC="${RAW_DIR}/s2i_textb_v1-tkn_sc-it.sc"
S2I_VALID_SCIT_SC="${RAW_DIR}/s2i_valid_v1-tkn_sc-it.sc"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  english

E2S_TRAIN_SCEN_EN="${RAW_DIR}/e2s_train_v1-tkn_sc-en.en"
E2S_TEXTB_SCEN_EN="${RAW_DIR}/e2s_textb_v1-tkn_sc-en.en"
E2S_VALID_SCEN_EN="${RAW_DIR}/e2s_valid_v1-tkn_sc-en.en"

S2E_TRAIN_SCEN_EN="${RAW_DIR}/s2e_train_v1-tkn_sc-en.en"
S2E_TEXTB_SCEN_EN="${RAW_DIR}/s2e_textb_v1-tkn_sc-en.en"
S2E_VALID_SCEN_EN="${RAW_DIR}/s2e_valid_v1-tkn_sc-en.en"

I2E_TRAIN_ITEN_EN="${RAW_DIR}/i2e_train_v1-tkn_it-en.en"
I2E_TEXTB_ITEN_EN="${RAW_DIR}/i2e_textb_v1-tkn_it-en.en"
I2E_VALID_ITEN_EN="${RAW_DIR}/i2e_valid_v1-tkn_it-en.en"

E2I_TRAIN_ITEN_EN="${RAW_DIR}/e2i_train_v1-tkn_it-en.en"
E2I_TEXTB_ITEN_EN="${RAW_DIR}/e2i_textb_v1-tkn_it-en.en"
E2I_VALID_ITEN_EN="${RAW_DIR}/e2i_valid_v1-tkn_it-en.en"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  italian

E2I_TRAIN_ITEN_IT="${RAW_DIR}/e2i_train_v1-tkn_it-en.it"
E2I_TEXTB_ITEN_IT="${RAW_DIR}/e2i_textb_v1-tkn_it-en.it"
E2I_VALID_ITEN_IT="${RAW_DIR}/e2i_valid_v1-tkn_it-en.it"

I2E_TRAIN_ITEN_IT="${RAW_DIR}/i2e_train_v1-tkn_it-en.it"
I2E_TEXTB_ITEN_IT="${RAW_DIR}/i2e_textb_v1-tkn_it-en.it"
I2E_VALID_ITEN_IT="${RAW_DIR}/i2e_valid_v1-tkn_it-en.it"

#I2S_TRAIN_SCIT_IT="${RAW_DIR}/i2s_train_v1-tkn_sc-it.it"
I2S_BACKT_SCIT_IT="${RAW_DIR}/i2s_backt_v1-tkn_sc-it.it"
I2S_TEXTB_SCIT_IT="${RAW_DIR}/i2s_textb_v1-tkn_sc-it.it"
I2S_VALID_SCIT_IT="${RAW_DIR}/i2s_valid_v1-tkn_sc-it.it"

#S2I_TRAIN_SCIT_IT="${RAW_DIR}/s2i_train_v1-tkn_sc-it.it"
S2I_BACKT_SCIT_IT="${RAW_DIR}/s2i_backt_v1-tkn_sc-it.it"
S2I_TEXTB_SCIT_IT="${RAW_DIR}/s2i_textb_v1-tkn_sc-it.it"
S2I_VALID_SCIT_IT="${RAW_DIR}/s2i_valid_v1-tkn_sc-it.it"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  sicilian

E2S_TRAIN_BPE_SCEN_SC="${FNL_DIR}/e2s_train_v2-sbw_sc-en.sc"
E2S_TEXTB_BPE_SCEN_SC="${FNL_DIR}/e2s_textb_v2-sbw_sc-en.sc"
E2S_VALID_BPE_SCEN_SC="${FNL_DIR}/e2s_valid_v2-sbw_sc-en.sc"

S2E_TRAIN_BPE_SCEN_SC="${FNL_DIR}/s2e_train_v2-sbw_sc-en.sc"
S2E_TEXTB_BPE_SCEN_SC="${FNL_DIR}/s2e_textb_v2-sbw_sc-en.sc"
S2E_VALID_BPE_SCEN_SC="${FNL_DIR}/s2e_valid_v2-sbw_sc-en.sc"

#I2S_TRAIN_BPE_SCIT_SC="${FNL_DIR}/i2s_train_v2-sbw_sc-it.sc"
I2S_BACKT_BPE_SCIT_SC="${FNL_DIR}/i2s_backt_v2-sbw_sc-it.sc"
I2S_TEXTB_BPE_SCIT_SC="${FNL_DIR}/i2s_textb_v2-sbw_sc-it.sc"
I2S_VALID_BPE_SCIT_SC="${FNL_DIR}/i2s_valid_v2-sbw_sc-it.sc"

#S2I_TRAIN_BPE_SCIT_SC="${FNL_DIR}/s2i_train_v2-sbw_sc-it.sc"
S2I_BACKT_BPE_SCIT_SC="${FNL_DIR}/s2i_backt_v2-sbw_sc-it.sc"
S2I_TEXTB_BPE_SCIT_SC="${FNL_DIR}/s2i_textb_v2-sbw_sc-it.sc"
S2I_VALID_BPE_SCIT_SC="${FNL_DIR}/s2i_valid_v2-sbw_sc-it.sc"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  english

E2S_TRAIN_BPE_SCEN_EN="${FNL_DIR}/e2s_train_v2-sbw_sc-en.en"
E2S_TEXTB_BPE_SCEN_EN="${FNL_DIR}/e2s_textb_v2-sbw_sc-en.en"
E2S_VALID_BPE_SCEN_EN="${FNL_DIR}/e2s_valid_v2-sbw_sc-en.en"

S2E_TRAIN_BPE_SCEN_EN="${FNL_DIR}/s2e_train_v2-sbw_sc-en.en"
S2E_TEXTB_BPE_SCEN_EN="${FNL_DIR}/s2e_textb_v2-sbw_sc-en.en"
S2E_VALID_BPE_SCEN_EN="${FNL_DIR}/s2e_valid_v2-sbw_sc-en.en"

I2E_TRAIN_BPE_ITEN_EN="${FNL_DIR}/i2e_train_v2-sbw_it-en.en"
I2E_TEXTB_BPE_ITEN_EN="${FNL_DIR}/i2e_textb_v2-sbw_it-en.en"
I2E_VALID_BPE_ITEN_EN="${FNL_DIR}/i2e_valid_v2-sbw_it-en.en"

E2I_TRAIN_BPE_ITEN_EN="${FNL_DIR}/e2i_train_v2-sbw_it-en.en"
E2I_TEXTB_BPE_ITEN_EN="${FNL_DIR}/e2i_textb_v2-sbw_it-en.en"
E2I_VALID_BPE_ITEN_EN="${FNL_DIR}/e2i_valid_v2-sbw_it-en.en"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  italian

E2I_TRAIN_BPE_ITEN_IT="${FNL_DIR}/e2i_train_v2-sbw_it-en.it"
E2I_TEXTB_BPE_ITEN_IT="${FNL_DIR}/e2i_textb_v2-sbw_it-en.it"
E2I_VALID_BPE_ITEN_IT="${FNL_DIR}/e2i_valid_v2-sbw_it-en.it"

I2E_TRAIN_BPE_ITEN_IT="${FNL_DIR}/i2e_train_v2-sbw_it-en.it"
I2E_TEXTB_BPE_ITEN_IT="${FNL_DIR}/i2e_textb_v2-sbw_it-en.it"
I2E_VALID_BPE_ITEN_IT="${FNL_DIR}/i2e_valid_v2-sbw_it-en.it"

#I2S_TRAIN_BPE_SCIT_IT="${FNL_DIR}/i2s_train_v2-sbw_sc-it.it"
I2S_BACKT_BPE_SCIT_IT="${FNL_DIR}/i2s_backt_v2-sbw_sc-it.it"
I2S_TEXTB_BPE_SCIT_IT="${FNL_DIR}/i2s_textb_v2-sbw_sc-it.it"
I2S_VALID_BPE_SCIT_IT="${FNL_DIR}/i2s_valid_v2-sbw_sc-it.it"

#S2I_TRAIN_BPE_SCIT_IT="${FNL_DIR}/s2i_train_v2-sbw_sc-it.it"
S2I_BACKT_BPE_SCIT_IT="${FNL_DIR}/s2i_backt_v2-sbw_sc-it.it"
S2I_TEXTB_BPE_SCIT_IT="${FNL_DIR}/s2i_textb_v2-sbw_sc-it.it"
S2I_VALID_BPE_SCIT_IT="${FNL_DIR}/s2i_valid_v2-sbw_sc-it.it"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  sicilian

subword-nmt apply-bpe -c $CODES_SC < $E2S_TRAIN_SCEN_SC  > $E2S_TRAIN_BPE_SCEN_SC
subword-nmt apply-bpe -c $CODES_SC < $E2S_TEXTB_SCEN_SC  > $E2S_TEXTB_BPE_SCEN_SC
subword-nmt apply-bpe -c $CODES_SC < $E2S_VALID_SCEN_SC  > $E2S_VALID_BPE_SCEN_SC

subword-nmt apply-bpe -c $CODES_SC < $S2E_TRAIN_SCEN_SC  > $S2E_TRAIN_BPE_SCEN_SC
subword-nmt apply-bpe -c $CODES_SC < $S2E_TEXTB_SCEN_SC  > $S2E_TEXTB_BPE_SCEN_SC
subword-nmt apply-bpe -c $CODES_SC < $S2E_VALID_SCEN_SC  > $S2E_VALID_BPE_SCEN_SC

#subword-nmt apply-bpe -c $CODES_SC < $I2S_TRAIN_SCIT_SC  > $I2S_TRAIN_BPE_SCIT_SC
subword-nmt apply-bpe -c $CODES_SC < $I2S_BACKT_SCIT_SC  > $I2S_BACKT_BPE_SCIT_SC
subword-nmt apply-bpe -c $CODES_SC < $I2S_TEXTB_SCIT_SC  > $I2S_TEXTB_BPE_SCIT_SC
subword-nmt apply-bpe -c $CODES_SC < $I2S_VALID_SCIT_SC  > $I2S_VALID_BPE_SCIT_SC

#subword-nmt apply-bpe -c $CODES_SC < $S2I_TRAIN_SCIT_SC  > $S2I_TRAIN_BPE_SCIT_SC
subword-nmt apply-bpe -c $CODES_SC < $S2I_BACKT_SCIT_SC  > $S2I_BACKT_BPE_SCIT_SC
subword-nmt apply-bpe -c $CODES_SC < $S2I_TEXTB_SCIT_SC  > $S2I_TEXTB_BPE_SCIT_SC
subword-nmt apply-bpe -c $CODES_SC < $S2I_VALID_SCIT_SC  > $S2I_VALID_BPE_SCIT_SC

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  english

subword-nmt apply-bpe -c $CODES_EN < $E2S_TRAIN_SCEN_EN  > $E2S_TRAIN_BPE_SCEN_EN
subword-nmt apply-bpe -c $CODES_EN < $E2S_TEXTB_SCEN_EN  > $E2S_TEXTB_BPE_SCEN_EN
subword-nmt apply-bpe -c $CODES_EN < $E2S_VALID_SCEN_EN  > $E2S_VALID_BPE_SCEN_EN

subword-nmt apply-bpe -c $CODES_EN < $S2E_TRAIN_SCEN_EN  > $S2E_TRAIN_BPE_SCEN_EN
subword-nmt apply-bpe -c $CODES_EN < $S2E_TEXTB_SCEN_EN  > $S2E_TEXTB_BPE_SCEN_EN
subword-nmt apply-bpe -c $CODES_EN < $S2E_VALID_SCEN_EN  > $S2E_VALID_BPE_SCEN_EN

subword-nmt apply-bpe -c $CODES_EN < $I2E_TRAIN_ITEN_EN  > $I2E_TRAIN_BPE_ITEN_EN
subword-nmt apply-bpe -c $CODES_EN < $I2E_TEXTB_ITEN_EN  > $I2E_TEXTB_BPE_ITEN_EN
subword-nmt apply-bpe -c $CODES_EN < $I2E_VALID_ITEN_EN  > $I2E_VALID_BPE_ITEN_EN

subword-nmt apply-bpe -c $CODES_EN < $E2I_TRAIN_ITEN_EN  > $E2I_TRAIN_BPE_ITEN_EN
subword-nmt apply-bpe -c $CODES_EN < $E2I_TEXTB_ITEN_EN  > $E2I_TEXTB_BPE_ITEN_EN
subword-nmt apply-bpe -c $CODES_EN < $E2I_VALID_ITEN_EN  > $E2I_VALID_BPE_ITEN_EN

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  italian

subword-nmt apply-bpe -c $CODES_IT < $E2I_TRAIN_ITEN_IT  > $E2I_TRAIN_BPE_ITEN_IT
subword-nmt apply-bpe -c $CODES_IT < $E2I_TEXTB_ITEN_IT  > $E2I_TEXTB_BPE_ITEN_IT
subword-nmt apply-bpe -c $CODES_IT < $E2I_VALID_ITEN_IT  > $E2I_VALID_BPE_ITEN_IT

subword-nmt apply-bpe -c $CODES_IT < $I2E_TRAIN_ITEN_IT  > $I2E_TRAIN_BPE_ITEN_IT
subword-nmt apply-bpe -c $CODES_IT < $I2E_TEXTB_ITEN_IT  > $I2E_TEXTB_BPE_ITEN_IT
subword-nmt apply-bpe -c $CODES_IT < $I2E_VALID_ITEN_IT  > $I2E_VALID_BPE_ITEN_IT

#subword-nmt apply-bpe -c $CODES_IT < $I2S_TRAIN_SCIT_IT  > $I2S_TRAIN_BPE_SCIT_IT
subword-nmt apply-bpe -c $CODES_IT < $I2S_BACKT_SCIT_IT  > $I2S_BACKT_BPE_SCIT_IT
subword-nmt apply-bpe -c $CODES_IT < $I2S_TEXTB_SCIT_IT  > $I2S_TEXTB_BPE_SCIT_IT
subword-nmt apply-bpe -c $CODES_IT < $I2S_VALID_SCIT_IT  > $I2S_VALID_BPE_SCIT_IT

#subword-nmt apply-bpe -c $CODES_IT < $S2I_TRAIN_SCIT_IT  > $S2I_TRAIN_BPE_SCIT_IT
subword-nmt apply-bpe -c $CODES_IT < $S2I_BACKT_SCIT_IT  > $S2I_BACKT_BPE_SCIT_IT
subword-nmt apply-bpe -c $CODES_IT < $S2I_TEXTB_SCIT_IT  > $S2I_TEXTB_BPE_SCIT_IT
subword-nmt apply-bpe -c $CODES_IT < $S2I_VALID_SCIT_IT  > $S2I_VALID_BPE_SCIT_IT
