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

##  combine files into datasets for training and validation

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  directories
BASE_DIR="se31_multi"
PCS_DIR="${BASE_DIR}/data-sbw/pieces"
FNL_DIR="${BASE_DIR}/data-m2m"

##  subword split training data
BACKT_BPE_E2M_SCEN_SC="${PCS_DIR}/e2m_backt_v2-sbw_sc-en.sc"
BACKT_BPE_E2M_SCEN_EN="${PCS_DIR}/e2m_backt_v2-sbw_sc-en.en"

TRAIN_BPE_E2M_SCEN_SC="${PCS_DIR}/e2m_train_v2-sbw_sc-en.sc"
TRAIN_BPE_E2M_SCEN_EN="${PCS_DIR}/e2m_train_v2-sbw_sc-en.en"
TRAIN_BPE_E2M_ITEN_EN="${PCS_DIR}/e2m_train_v2-sbw_it-en.en"
TRAIN_BPE_E2M_ITEN_IT="${PCS_DIR}/e2m_train_v2-sbw_it-en.it"

TRAIN_BPE_M2E_SCEN_SC="${PCS_DIR}/m2e_train_v2-sbw_sc-en.sc"
TRAIN_BPE_M2E_SCEN_EN="${PCS_DIR}/m2e_train_v2-sbw_sc-en.en"
TRAIN_BPE_M2E_ITEN_EN="${PCS_DIR}/m2e_train_v2-sbw_it-en.en"
TRAIN_BPE_M2E_ITEN_IT="${PCS_DIR}/m2e_train_v2-sbw_it-en.it"
				                           
##  subword split validation data
VALID_BPE_E2M_SCEN_SC="${PCS_DIR}/e2m_valid_v2-sbw_sc-en.sc"
VALID_BPE_E2M_SCEN_EN="${PCS_DIR}/e2m_valid_v2-sbw_sc-en.en"
VALID_BPE_E2M_ITEN_EN="${PCS_DIR}/e2m_valid_v2-sbw_it-en.en"
VALID_BPE_E2M_ITEN_IT="${PCS_DIR}/e2m_valid_v2-sbw_it-en.it"

VALID_BPE_M2E_SCEN_SC="${PCS_DIR}/m2e_valid_v2-sbw_sc-en.sc"
VALID_BPE_M2E_SCEN_EN="${PCS_DIR}/m2e_valid_v2-sbw_sc-en.en"
VALID_BPE_M2E_ITEN_EN="${PCS_DIR}/m2e_valid_v2-sbw_it-en.en"
VALID_BPE_M2E_ITEN_IT="${PCS_DIR}/m2e_valid_v2-sbw_it-en.it"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  combined training data
TRAIN_M2M_SRC="${FNL_DIR}/m2m_train_v2-sbw.src"
TRAIN_M2M_TGT="${FNL_DIR}/m2m_train_v2-sbw.tgt"

##  combined validation data
VALID_M2M_SRC="${FNL_DIR}/m2m_valid_v2-sbw.src"
VALID_M2M_TGT="${FNL_DIR}/m2m_valid_v2-sbw.tgt"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  TARGET

##  combine training data (without directional token)
cat $BACKT_BPE_E2M_SCEN_SC >  $TRAIN_M2M_TGT
cat $TRAIN_BPE_E2M_SCEN_SC >> $TRAIN_M2M_TGT
cat $TRAIN_BPE_E2M_ITEN_IT >> $TRAIN_M2M_TGT

cat $TRAIN_BPE_M2E_SCEN_EN >> $TRAIN_M2M_TGT
cat $TRAIN_BPE_M2E_ITEN_EN >> $TRAIN_M2M_TGT

##  combine validation data (without directional token)
cat $VALID_BPE_E2M_SCEN_SC >  $VALID_M2M_TGT
cat $VALID_BPE_E2M_ITEN_IT >> $VALID_M2M_TGT

cat $VALID_BPE_M2E_SCEN_EN >> $VALID_M2M_TGT
cat $VALID_BPE_M2E_ITEN_EN >> $VALID_M2M_TGT

##  SOURCE

##  add directional token to training data
perl -nle '{chomp; print "<2sc> " . $_ ;}' $BACKT_BPE_E2M_SCEN_EN >  $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2sc> " . $_ ;}' $TRAIN_BPE_E2M_SCEN_EN >> $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2it> " . $_ ;}' $TRAIN_BPE_E2M_ITEN_EN >> $TRAIN_M2M_SRC

perl -nle '{chomp; print "<2en> " . $_ ;}' $TRAIN_BPE_M2E_SCEN_SC >> $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2en> " . $_ ;}' $TRAIN_BPE_M2E_ITEN_IT >> $TRAIN_M2M_SRC

##  add directional token to validation data
perl -nle '{chomp; print "<2sc> " . $_ ;}' $VALID_BPE_E2M_SCEN_EN >  $VALID_M2M_SRC
perl -nle '{chomp; print "<2it> " . $_ ;}' $VALID_BPE_E2M_ITEN_EN >> $VALID_M2M_SRC

perl -nle '{chomp; print "<2en> " . $_ ;}' $VALID_BPE_M2E_SCEN_SC >> $VALID_M2M_SRC
perl -nle '{chomp; print "<2en> " . $_ ;}' $VALID_BPE_M2E_ITEN_IT >> $VALID_M2M_SRC

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
