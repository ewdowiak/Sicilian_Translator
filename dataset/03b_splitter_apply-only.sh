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

E2M_TRAIN_SCEN_SC="${RAW_DIR}/e2m_train_v1-tkn_sc-en.sc"
E2M_BACKT_SCEN_SC="${RAW_DIR}/e2m_backt_v1-tkn_sc-en.sc"
E2M_VALID_SCEN_SC="${RAW_DIR}/e2m_valid_v1-tkn_sc-en.sc"

M2E_TRAIN_SCEN_SC="${RAW_DIR}/m2e_train_v1-tkn_sc-en.sc"
#M2E_BACKT_SCEN_SC="${RAW_DIR}/m2e_backt_v1-tkn_sc-en.sc"
M2E_VALID_SCEN_SC="${RAW_DIR}/m2e_valid_v1-tkn_sc-en.sc"

##  english

E2M_TRAIN_SCEN_EN="${RAW_DIR}/e2m_train_v1-tkn_sc-en.en"
E2M_BACKT_SCEN_EN="${RAW_DIR}/e2m_backt_v1-tkn_sc-en.en"
E2M_VALID_SCEN_EN="${RAW_DIR}/e2m_valid_v1-tkn_sc-en.en"

M2E_TRAIN_SCEN_EN="${RAW_DIR}/m2e_train_v1-tkn_sc-en.en"
#M2E_BACKT_SCEN_EN="${RAW_DIR}/m2e_backt_v1-tkn_sc-en.en"
M2E_VALID_SCEN_EN="${RAW_DIR}/m2e_valid_v1-tkn_sc-en.en"

E2M_TRAIN_ITEN_EN="${RAW_DIR}/e2m_train_v1-tkn_it-en.en"
#E2M_BACKT_ITEN_EN="${RAW_DIR}/e2m_backt_v1-tkn_it-en.en"
E2M_VALID_ITEN_EN="${RAW_DIR}/e2m_valid_v1-tkn_it-en.en"

M2E_TRAIN_ITEN_EN="${RAW_DIR}/m2e_train_v1-tkn_it-en.en"
#M2E_BACKT_ITEN_EN="${RAW_DIR}/m2e_backt_v1-tkn_it-en.en"
M2E_VALID_ITEN_EN="${RAW_DIR}/m2e_valid_v1-tkn_it-en.en"

##  italian

E2M_TRAIN_ITEN_IT="${RAW_DIR}/e2m_train_v1-tkn_it-en.it"
#E2M_BACKT_ITEN_IT="${RAW_DIR}/e2m_backt_v1-tkn_it-en.it"
E2M_VALID_ITEN_IT="${RAW_DIR}/e2m_valid_v1-tkn_it-en.it"

M2E_TRAIN_ITEN_IT="${RAW_DIR}/m2e_train_v1-tkn_it-en.it"
#M2E_BACKT_ITEN_IT="${RAW_DIR}/m2e_backt_v1-tkn_it-en.it"
M2E_VALID_ITEN_IT="${RAW_DIR}/m2e_valid_v1-tkn_it-en.it"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  sicilian

E2M_TRAIN_BPE_SCEN_SC="${FNL_DIR}/e2m_train_v2-sbw_sc-en.sc"
E2M_BACKT_BPE_SCEN_SC="${FNL_DIR}/e2m_backt_v2-sbw_sc-en.sc"
E2M_VALID_BPE_SCEN_SC="${FNL_DIR}/e2m_valid_v2-sbw_sc-en.sc"

M2E_TRAIN_BPE_SCEN_SC="${FNL_DIR}/m2e_train_v2-sbw_sc-en.sc"
#M2E_BACKT_BPE_SCEN_SC="${FNL_DIR}/m2e_backt_v2-sbw_sc-en.sc"
M2E_VALID_BPE_SCEN_SC="${FNL_DIR}/m2e_valid_v2-sbw_sc-en.sc"

##  english

E2M_TRAIN_BPE_SCEN_EN="${FNL_DIR}/e2m_train_v2-sbw_sc-en.en"
E2M_BACKT_BPE_SCEN_EN="${FNL_DIR}/e2m_backt_v2-sbw_sc-en.en"
E2M_VALID_BPE_SCEN_EN="${FNL_DIR}/e2m_valid_v2-sbw_sc-en.en"

M2E_TRAIN_BPE_SCEN_EN="${FNL_DIR}/m2e_train_v2-sbw_sc-en.en"
#M2E_BACKT_BPE_SCEN_EN="${FNL_DIR}/m2e_backt_v2-sbw_sc-en.en"
M2E_VALID_BPE_SCEN_EN="${FNL_DIR}/m2e_valid_v2-sbw_sc-en.en"

E2M_TRAIN_BPE_ITEN_EN="${FNL_DIR}/e2m_train_v2-sbw_it-en.en"
#E2M_BACKT_BPE_ITEN_EN="${FNL_DIR}/e2m_backt_v2-sbw_it-en.en"
E2M_VALID_BPE_ITEN_EN="${FNL_DIR}/e2m_valid_v2-sbw_it-en.en"

M2E_TRAIN_BPE_ITEN_EN="${FNL_DIR}/m2e_train_v2-sbw_it-en.en"
#M2E_BACKT_BPE_ITEN_EN="${FNL_DIR}/m2e_backt_v2-sbw_it-en.en"
M2E_VALID_BPE_ITEN_EN="${FNL_DIR}/m2e_valid_v2-sbw_it-en.en"

##  italian

E2M_TRAIN_BPE_ITEN_IT="${FNL_DIR}/e2m_train_v2-sbw_it-en.it"
#E2M_BACKT_BPE_ITEN_IT="${FNL_DIR}/e2m_backt_v2-sbw_it-en.it"
E2M_VALID_BPE_ITEN_IT="${FNL_DIR}/e2m_valid_v2-sbw_it-en.it"

M2E_TRAIN_BPE_ITEN_IT="${FNL_DIR}/m2e_train_v2-sbw_it-en.it"
#M2E_BACKT_BPE_ITEN_IT="${FNL_DIR}/m2e_backt_v2-sbw_it-en.it"
M2E_VALID_BPE_ITEN_IT="${FNL_DIR}/m2e_valid_v2-sbw_it-en.it"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  sicilian

subword-nmt apply-bpe -c $CODES_SC < $E2M_TRAIN_SCEN_SC  > $E2M_TRAIN_BPE_SCEN_SC
subword-nmt apply-bpe -c $CODES_SC < $E2M_BACKT_SCEN_SC  > $E2M_BACKT_BPE_SCEN_SC
subword-nmt apply-bpe -c $CODES_SC < $E2M_VALID_SCEN_SC  > $E2M_VALID_BPE_SCEN_SC

subword-nmt apply-bpe -c $CODES_SC < $M2E_TRAIN_SCEN_SC  > $M2E_TRAIN_BPE_SCEN_SC
#subword-nmt apply-bpe -c $CODES_SC < $M2E_BACKT_SCEN_SC  > $M2E_BACKT_BPE_SCEN_SC
subword-nmt apply-bpe -c $CODES_SC < $M2E_VALID_SCEN_SC  > $M2E_VALID_BPE_SCEN_SC

##  english

subword-nmt apply-bpe -c $CODES_EN < $E2M_TRAIN_SCEN_EN  > $E2M_TRAIN_BPE_SCEN_EN
subword-nmt apply-bpe -c $CODES_EN < $E2M_BACKT_SCEN_EN  > $E2M_BACKT_BPE_SCEN_EN
subword-nmt apply-bpe -c $CODES_EN < $E2M_VALID_SCEN_EN  > $E2M_VALID_BPE_SCEN_EN

subword-nmt apply-bpe -c $CODES_EN < $M2E_TRAIN_SCEN_EN  > $M2E_TRAIN_BPE_SCEN_EN
#subword-nmt apply-bpe -c $CODES_EN < $M2E_BACKT_SCEN_EN  > $M2E_BACKT_BPE_SCEN_EN
subword-nmt apply-bpe -c $CODES_EN < $M2E_VALID_SCEN_EN  > $M2E_VALID_BPE_SCEN_EN

subword-nmt apply-bpe -c $CODES_EN < $E2M_TRAIN_ITEN_EN  > $E2M_TRAIN_BPE_ITEN_EN
#subword-nmt apply-bpe -c $CODES_EN < $E2M_BACKT_ITEN_EN  > $E2M_BACKT_BPE_ITEN_EN
subword-nmt apply-bpe -c $CODES_EN < $E2M_VALID_ITEN_EN  > $E2M_VALID_BPE_ITEN_EN

subword-nmt apply-bpe -c $CODES_EN < $M2E_TRAIN_ITEN_EN  > $M2E_TRAIN_BPE_ITEN_EN
#subword-nmt apply-bpe -c $CODES_EN < $M2E_BACKT_ITEN_EN  > $M2E_BACKT_BPE_ITEN_EN
subword-nmt apply-bpe -c $CODES_EN < $M2E_VALID_ITEN_EN  > $M2E_VALID_BPE_ITEN_EN

##  italian

subword-nmt apply-bpe -c $CODES_IT < $E2M_TRAIN_ITEN_IT  > $E2M_TRAIN_BPE_ITEN_IT
#subword-nmt apply-bpe -c $CODES_IT < $E2M_BACKT_ITEN_IT  > $E2M_BACKT_BPE_ITEN_IT
subword-nmt apply-bpe -c $CODES_IT < $E2M_VALID_ITEN_IT  > $E2M_VALID_BPE_ITEN_IT

subword-nmt apply-bpe -c $CODES_IT < $M2E_TRAIN_ITEN_IT  > $M2E_TRAIN_BPE_ITEN_IT
#subword-nmt apply-bpe -c $CODES_IT < $M2E_BACKT_ITEN_IT  > $M2E_BACKT_BPE_ITEN_IT
subword-nmt apply-bpe -c $CODES_IT < $M2E_VALID_ITEN_IT  > $M2E_VALID_BPE_ITEN_IT
