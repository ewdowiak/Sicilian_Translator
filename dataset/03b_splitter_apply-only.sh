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
BASE_DIR="se31_multi"
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
# VOCAB_SC_JSON="${FNL_DIR}/vocab.sc.json"
# VOCAB_EN_JSON="${FNL_DIR}/vocab.en.json"
# VOCAB_IT_JSON="${FNL_DIR}/vocab.it.json"

##  ##  ##  ##  ##  ##  ##  ##  ##  #
#  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  training data with Sicilian vocabulary
TRAIN_VOCAB_SC="${RAW_DIR}/e2m_trbck-dieli_v1-tkn_sc-en.sc"

##  tokenized training data
BACKT_E2M_SCEN_SC="${RAW_DIR}/e2m_backt_v1-tkn_sc-en.sc"
BACKT_E2M_SCEN_EN="${RAW_DIR}/e2m_backt_v1-tkn_sc-en.en"

TRAIN_E2M_SCEN_SC="${RAW_DIR}/e2m_train_v1-tkn_sc-en.sc"
TRAIN_E2M_SCEN_EN="${RAW_DIR}/e2m_train_v1-tkn_sc-en.en"
TRAIN_E2M_ITEN_EN="${RAW_DIR}/e2m_train_v1-tkn_it-en.en"
TRAIN_E2M_ITEN_IT="${RAW_DIR}/e2m_train_v1-tkn_it-en.it"
			                               
TRAIN_M2E_SCEN_SC="${RAW_DIR}/m2e_train_v1-tkn_sc-en.sc"
TRAIN_M2E_SCEN_EN="${RAW_DIR}/m2e_train_v1-tkn_sc-en.en"
TRAIN_M2E_ITEN_EN="${RAW_DIR}/m2e_train_v1-tkn_it-en.en"
TRAIN_M2E_ITEN_IT="${RAW_DIR}/m2e_train_v1-tkn_it-en.it"
			                               
##  tokenized validation data	                               
VALID_E2M_SCEN_SC="${RAW_DIR}/e2m_valid_v1-tkn_sc-en.sc"
VALID_E2M_SCEN_EN="${RAW_DIR}/e2m_valid_v1-tkn_sc-en.en"
VALID_E2M_ITEN_EN="${RAW_DIR}/e2m_valid_v1-tkn_it-en.en"
VALID_E2M_ITEN_IT="${RAW_DIR}/e2m_valid_v1-tkn_it-en.it"
			                               
VALID_M2E_SCEN_SC="${RAW_DIR}/m2e_valid_v1-tkn_sc-en.sc"
VALID_M2E_SCEN_EN="${RAW_DIR}/m2e_valid_v1-tkn_sc-en.en"
VALID_M2E_ITEN_EN="${RAW_DIR}/m2e_valid_v1-tkn_it-en.en"
VALID_M2E_ITEN_IT="${RAW_DIR}/m2e_valid_v1-tkn_it-en.it"

##  ##  ##  ##  ##

##  subword split training data
BACKT_BPE_E2M_SCEN_SC="${FNL_DIR}/e2m_backt_v2-sbw_sc-en.sc"
BACKT_BPE_E2M_SCEN_EN="${FNL_DIR}/e2m_backt_v2-sbw_sc-en.en"

TRAIN_BPE_E2M_SCEN_SC="${FNL_DIR}/e2m_train_v2-sbw_sc-en.sc"
TRAIN_BPE_E2M_SCEN_EN="${FNL_DIR}/e2m_train_v2-sbw_sc-en.en"
TRAIN_BPE_E2M_ITEN_EN="${FNL_DIR}/e2m_train_v2-sbw_it-en.en"
TRAIN_BPE_E2M_ITEN_IT="${FNL_DIR}/e2m_train_v2-sbw_it-en.it"

TRAIN_BPE_M2E_SCEN_SC="${FNL_DIR}/m2e_train_v2-sbw_sc-en.sc"
TRAIN_BPE_M2E_SCEN_EN="${FNL_DIR}/m2e_train_v2-sbw_sc-en.en"
TRAIN_BPE_M2E_ITEN_EN="${FNL_DIR}/m2e_train_v2-sbw_it-en.en"
TRAIN_BPE_M2E_ITEN_IT="${FNL_DIR}/m2e_train_v2-sbw_it-en.it"
				                           
##  subword split validation data
VALID_BPE_E2M_SCEN_SC="${FNL_DIR}/e2m_valid_v2-sbw_sc-en.sc"
VALID_BPE_E2M_SCEN_EN="${FNL_DIR}/e2m_valid_v2-sbw_sc-en.en"
VALID_BPE_E2M_ITEN_EN="${FNL_DIR}/e2m_valid_v2-sbw_it-en.en"
VALID_BPE_E2M_ITEN_IT="${FNL_DIR}/e2m_valid_v2-sbw_it-en.it"

VALID_BPE_M2E_SCEN_SC="${FNL_DIR}/m2e_valid_v2-sbw_sc-en.sc"
VALID_BPE_M2E_SCEN_EN="${FNL_DIR}/m2e_valid_v2-sbw_sc-en.en"
VALID_BPE_M2E_ITEN_EN="${FNL_DIR}/m2e_valid_v2-sbw_it-en.en"
VALID_BPE_M2E_ITEN_IT="${FNL_DIR}/m2e_valid_v2-sbw_it-en.it"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

# subword-nmt learn-bpe -s $NUM_OP_SC < $TRAIN_VOCAB_SC    > $CODES_SC
# subword-nmt learn-bpe -s $NUM_OP_IT < $TRAIN_E2M_ITEN_IT > $CODES_IT
# cat $TRAIN_E2M_SCEN_EN $TRAIN_E2M_ITEN_EN | subword-nmt learn-bpe -s $NUM_OP_EN > $CODES_EN

# subword-nmt apply-bpe -c $CODES_SC < $TRAIN_VOCAB_SC     | subword-nmt get-vocab > $VOCAB_SC
# subword-nmt apply-bpe -c $CODES_IT < $TRAIN_E2M_ITEN_IT  | subword-nmt get-vocab > $VOCAB_IT
# cat $TRAIN_E2M_SCEN_EN $TRAIN_E2M_ITEN_EN | subword-nmt apply-bpe -c $CODES_EN | subword-nmt get-vocab > $VOCAB_EN

subword-nmt apply-bpe -c $CODES_SC < $BACKT_E2M_SCEN_SC > $BACKT_BPE_E2M_SCEN_SC
subword-nmt apply-bpe -c $CODES_EN < $BACKT_E2M_SCEN_EN > $BACKT_BPE_E2M_SCEN_EN

subword-nmt apply-bpe -c $CODES_SC < $TRAIN_E2M_SCEN_SC > $TRAIN_BPE_E2M_SCEN_SC
subword-nmt apply-bpe -c $CODES_EN < $TRAIN_E2M_SCEN_EN > $TRAIN_BPE_E2M_SCEN_EN
subword-nmt apply-bpe -c $CODES_EN < $TRAIN_E2M_ITEN_EN > $TRAIN_BPE_E2M_ITEN_EN
subword-nmt apply-bpe -c $CODES_IT < $TRAIN_E2M_ITEN_IT > $TRAIN_BPE_E2M_ITEN_IT

subword-nmt apply-bpe -c $CODES_SC < $TRAIN_M2E_SCEN_SC > $TRAIN_BPE_M2E_SCEN_SC
subword-nmt apply-bpe -c $CODES_EN < $TRAIN_M2E_SCEN_EN > $TRAIN_BPE_M2E_SCEN_EN
subword-nmt apply-bpe -c $CODES_EN < $TRAIN_M2E_ITEN_EN > $TRAIN_BPE_M2E_ITEN_EN
subword-nmt apply-bpe -c $CODES_IT < $TRAIN_M2E_ITEN_IT > $TRAIN_BPE_M2E_ITEN_IT

subword-nmt apply-bpe -c $CODES_SC < $VALID_E2M_SCEN_SC > $VALID_BPE_E2M_SCEN_SC
subword-nmt apply-bpe -c $CODES_EN < $VALID_E2M_SCEN_EN > $VALID_BPE_E2M_SCEN_EN
subword-nmt apply-bpe -c $CODES_EN < $VALID_E2M_ITEN_EN > $VALID_BPE_E2M_ITEN_EN
subword-nmt apply-bpe -c $CODES_IT < $VALID_E2M_ITEN_IT > $VALID_BPE_E2M_ITEN_IT

subword-nmt apply-bpe -c $CODES_SC < $VALID_M2E_SCEN_SC > $VALID_BPE_M2E_SCEN_SC
subword-nmt apply-bpe -c $CODES_EN < $VALID_M2E_SCEN_EN > $VALID_BPE_M2E_SCEN_EN
subword-nmt apply-bpe -c $CODES_EN < $VALID_M2E_ITEN_EN > $VALID_BPE_M2E_ITEN_EN
subword-nmt apply-bpe -c $CODES_IT < $VALID_M2E_ITEN_IT > $VALID_BPE_M2E_ITEN_IT

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

# subword-nmt learn-bpe -s $NUM_OP < $TRAIN_VOCAB_SC > $CODES_SC
# subword-nmt learn-bpe -s $NUM_OP < $TRAIN_E2M_EN   > $CODES_EN

# subword-nmt apply-bpe -c $CODES_SC --vocabulary-threshold $VCB_TH < $TRAIN_VOCAB_SC | subword-nmt get-vocab > $VOCAB_SC
# subword-nmt apply-bpe -c $CODES_EN --vocabulary-threshold $VCB_TH < $TRAIN_E2M_EN   | subword-nmt get-vocab > $VOCAB_EN  

# subword-nmt apply-bpe -c $CODES_SC --vocabulary $VOCAB_SC --vocabulary-threshold $VCB_TH < $TRAIN_E2M_SC > $TRAIN_BPE_E2M_SC
# subword-nmt apply-bpe -c $CODES_EN --vocabulary $VOCAB_EN --vocabulary-threshold $VCB_TH < $TRAIN_E2M_EN > $TRAIN_BPE_E2M_EN

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

# echo "{" > ${VOCAB_SC_JSON}
# echo "{" > ${VOCAB_EN_JSON}
# echo "{" > ${VOCAB_IT_JSON}
# sed 's/"/\\"/g;s/\s/\": /;s/$/,/;s/^/    \"/' ${VOCAB_SC} >> ${VOCAB_SC_JSON}
# sed 's/"/\\"/g;s/\s/\": /;s/$/,/;s/^/    \"/' ${VOCAB_EN} >> ${VOCAB_EN_JSON}
# sed 's/"/\\"/g;s/\s/\": /;s/$/,/;s/^/    \"/' ${VOCAB_IT} >> ${VOCAB_IT_JSON}
# echo "}" >> ${VOCAB_SC_JSON}
# echo "}" >> ${VOCAB_EN_JSON}
# echo "}" >> ${VOCAB_IT_JSON}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
