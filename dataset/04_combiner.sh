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
FNL_DIR="${BASE_DIR}/data-sbw"

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
TRAIN_E2M_EN="${FNL_DIR}/e2m_train_v2-sbw.en"
TRAIN_E2M_SC="${FNL_DIR}/e2m_train_v2-sbw.sc"

TRAIN_M2E_EN="${FNL_DIR}/m2e_train_v2-sbw.en"
TRAIN_M2E_SC="${FNL_DIR}/m2e_train_v2-sbw.sc"

##  combined validation data
VALID_E2M_EN="${FNL_DIR}/e2m_valid_v2-sbw.en"
VALID_E2M_SC="${FNL_DIR}/e2m_valid_v2-sbw.sc"

VALID_M2E_EN="${FNL_DIR}/m2e_valid_v2-sbw.en"
VALID_M2E_SC="${FNL_DIR}/m2e_valid_v2-sbw.sc"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  multi to english, so do not need directional tokens here

##  combine training data
cat  $TRAIN_BPE_M2E_SCEN_EN  $TRAIN_BPE_M2E_SCEN_EN  $TRAIN_BPE_M2E_ITEN_EN  >  $TRAIN_M2E_EN
cat  $TRAIN_BPE_M2E_SCEN_SC  $TRAIN_BPE_M2E_SCEN_SC  $TRAIN_BPE_M2E_ITEN_IT  >  $TRAIN_M2E_SC

##  combine validation data
cat  $VALID_BPE_M2E_SCEN_EN  $VALID_BPE_M2E_ITEN_EN  >  $VALID_M2E_EN
cat  $VALID_BPE_M2E_SCEN_SC  $VALID_BPE_M2E_ITEN_IT  >  $VALID_M2E_SC

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  english to multi

##  do not need directional tokens on the outputs
cat  $TRAIN_BPE_E2M_SCEN_SC  $TRAIN_BPE_E2M_SCEN_SC  $BACKT_BPE_E2M_SCEN_SC  $TRAIN_BPE_E2M_ITEN_IT  >  $TRAIN_E2M_SC
cat  $VALID_BPE_E2M_SCEN_SC  $VALID_BPE_E2M_ITEN_IT  >  $VALID_E2M_SC

##  add directional token to training data
perl -nle '{chomp; print "<2sc> " . $_ ;}' $TRAIN_BPE_E2M_SCEN_EN  >   $TRAIN_E2M_EN
perl -nle '{chomp; print "<2sc> " . $_ ;}' $TRAIN_BPE_E2M_SCEN_EN  >>  $TRAIN_E2M_EN
perl -nle '{chomp; print "<2sc> " . $_ ;}' $BACKT_BPE_E2M_SCEN_EN  >>  $TRAIN_E2M_EN
perl -nle '{chomp; print "<2it> " . $_ ;}' $TRAIN_BPE_E2M_ITEN_EN  >>  $TRAIN_E2M_EN

##  add directional token to validation data
perl -nle '{chomp; print "<2sc> " . $_ ;}' $VALID_BPE_E2M_SCEN_EN  >   $VALID_E2M_EN
perl -nle '{chomp; print "<2it> " . $_ ;}' $VALID_BPE_E2M_ITEN_EN  >>  $VALID_E2M_EN

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
