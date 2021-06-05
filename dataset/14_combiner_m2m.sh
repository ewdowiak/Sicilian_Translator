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
BASE_DIR="se33_multi"
PCS_DIR="${BASE_DIR}/data-sbw/pieces"
FNL_DIR="${BASE_DIR}/data-sbw"

##  offsets
SCOFF="14163"
ITOFF="8991"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  sicilian

E2S_TRAIN_BPE_SCEN_SC="${PCS_DIR}/e2s_train_v2-sbw_sc-en.sc"
E2S_TEXTB_BPE_SCEN_SC="${PCS_DIR}/e2s_textb_v2-sbw_sc-en.sc"
E2S_VALID_BPE_SCEN_SC="${PCS_DIR}/e2s_valid_v2-sbw_sc-en.sc"

S2E_TRAIN_BPE_SCEN_SC="${PCS_DIR}/s2e_train_v2-sbw_sc-en.sc"
S2E_TEXTB_BPE_SCEN_SC="${PCS_DIR}/s2e_textb_v2-sbw_sc-en.sc"
S2E_VALID_BPE_SCEN_SC="${PCS_DIR}/s2e_valid_v2-sbw_sc-en.sc"

#I2S_TRAIN_BPE_SCIT_SC="${PCS_DIR}/i2s_train_v2-sbw_sc-it.sc"
I2S_BACKT_BPE_SCIT_SC="${PCS_DIR}/i2s_backt_v2-sbw_sc-it.sc"
I2S_TEXTB_BPE_SCIT_SC="${PCS_DIR}/i2s_textb_v2-sbw_sc-it.sc"
I2S_VALID_BPE_SCIT_SC="${PCS_DIR}/i2s_valid_v2-sbw_sc-it.sc"

#S2I_TRAIN_BPE_SCIT_SC="${PCS_DIR}/s2i_train_v2-sbw_sc-it.sc"
S2I_BACKT_BPE_SCIT_SC="${PCS_DIR}/s2i_backt_v2-sbw_sc-it.sc"
S2I_TEXTB_BPE_SCIT_SC="${PCS_DIR}/s2i_textb_v2-sbw_sc-it.sc"
S2I_VALID_BPE_SCIT_SC="${PCS_DIR}/s2i_valid_v2-sbw_sc-it.sc"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  english

E2S_TRAIN_BPE_SCEN_EN="${PCS_DIR}/e2s_train_v2-sbw_sc-en.en"
E2S_TEXTB_BPE_SCEN_EN="${PCS_DIR}/e2s_textb_v2-sbw_sc-en.en"
E2S_VALID_BPE_SCEN_EN="${PCS_DIR}/e2s_valid_v2-sbw_sc-en.en"

S2E_TRAIN_BPE_SCEN_EN="${PCS_DIR}/s2e_train_v2-sbw_sc-en.en"
S2E_TEXTB_BPE_SCEN_EN="${PCS_DIR}/s2e_textb_v2-sbw_sc-en.en"
S2E_VALID_BPE_SCEN_EN="${PCS_DIR}/s2e_valid_v2-sbw_sc-en.en"

I2E_TRAIN_BPE_ITEN_EN="${PCS_DIR}/i2e_train_v2-sbw_it-en.en"
I2E_TEXTB_BPE_ITEN_EN="${PCS_DIR}/i2e_textb_v2-sbw_it-en.en"
I2E_VALID_BPE_ITEN_EN="${PCS_DIR}/i2e_valid_v2-sbw_it-en.en"

E2I_TRAIN_BPE_ITEN_EN="${PCS_DIR}/e2i_train_v2-sbw_it-en.en"
E2I_TEXTB_BPE_ITEN_EN="${PCS_DIR}/e2i_textb_v2-sbw_it-en.en"
E2I_VALID_BPE_ITEN_EN="${PCS_DIR}/e2i_valid_v2-sbw_it-en.en"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  italian

E2I_TRAIN_BPE_ITEN_IT="${PCS_DIR}/e2i_train_v2-sbw_it-en.it"
E2I_TEXTB_BPE_ITEN_IT="${PCS_DIR}/e2i_textb_v2-sbw_it-en.it"
E2I_VALID_BPE_ITEN_IT="${PCS_DIR}/e2i_valid_v2-sbw_it-en.it"

I2E_TRAIN_BPE_ITEN_IT="${PCS_DIR}/i2e_train_v2-sbw_it-en.it"
I2E_TEXTB_BPE_ITEN_IT="${PCS_DIR}/i2e_textb_v2-sbw_it-en.it"
I2E_VALID_BPE_ITEN_IT="${PCS_DIR}/i2e_valid_v2-sbw_it-en.it"

#I2S_TRAIN_BPE_SCIT_IT="${PCS_DIR}/i2s_train_v2-sbw_sc-it.it"
I2S_BACKT_BPE_SCIT_IT="${PCS_DIR}/i2s_backt_v2-sbw_sc-it.it"
I2S_TEXTB_BPE_SCIT_IT="${PCS_DIR}/i2s_textb_v2-sbw_sc-it.it"
I2S_VALID_BPE_SCIT_IT="${PCS_DIR}/i2s_valid_v2-sbw_sc-it.it"

#S2I_TRAIN_BPE_SCIT_IT="${PCS_DIR}/s2i_train_v2-sbw_sc-it.it"
S2I_BACKT_BPE_SCIT_IT="${PCS_DIR}/s2i_backt_v2-sbw_sc-it.it"
S2I_TEXTB_BPE_SCIT_IT="${PCS_DIR}/s2i_textb_v2-sbw_sc-it.it"
S2I_VALID_BPE_SCIT_IT="${PCS_DIR}/s2i_valid_v2-sbw_sc-it.it"


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
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
cat $E2S_TEXTB_BPE_SCEN_SC >  $TRAIN_M2M_TGT
cat $I2S_TEXTB_BPE_SCIT_SC >> $TRAIN_M2M_TGT
cat $E2S_TRAIN_BPE_SCEN_SC >> $TRAIN_M2M_TGT
cat $E2S_TRAIN_BPE_SCEN_SC >> $TRAIN_M2M_TGT
head -n ${SCOFF} $E2S_TRAIN_BPE_SCEN_SC >> $TRAIN_M2M_TGT
cat $I2S_BACKT_BPE_SCIT_SC >> $TRAIN_M2M_TGT

cat $S2E_TEXTB_BPE_SCEN_EN >> $TRAIN_M2M_TGT
cat $I2E_TEXTB_BPE_ITEN_EN >> $TRAIN_M2M_TGT
cat $S2E_TRAIN_BPE_SCEN_EN >> $TRAIN_M2M_TGT
cat $I2E_TRAIN_BPE_ITEN_EN >> $TRAIN_M2M_TGT

cat $S2I_TEXTB_BPE_SCIT_IT >> $TRAIN_M2M_TGT
cat $E2I_TEXTB_BPE_ITEN_IT >> $TRAIN_M2M_TGT
cat $E2I_TRAIN_BPE_ITEN_IT >> $TRAIN_M2M_TGT
head -n ${ITOFF} $E2I_TRAIN_BPE_ITEN_IT >> $TRAIN_M2M_TGT
cat $S2I_BACKT_BPE_SCIT_IT >> $TRAIN_M2M_TGT

##  combine validation data (without directional token)
cat $E2S_VALID_BPE_SCEN_SC >  $VALID_M2M_TGT
cat $S2E_VALID_BPE_SCEN_EN >> $VALID_M2M_TGT

cat $I2E_VALID_BPE_ITEN_EN >> $VALID_M2M_TGT
cat $E2I_VALID_BPE_ITEN_IT >> $VALID_M2M_TGT

cat $I2S_VALID_BPE_SCIT_SC >> $VALID_M2M_TGT
cat $S2I_VALID_BPE_SCIT_IT >> $VALID_M2M_TGT

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SOURCE

##  add directional token to training data
perl -nle '{chomp; print "<2sc> " . $_ ;}'  $E2S_TEXTB_BPE_SCEN_EN >  $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2sc> " . $_ ;}'  $I2S_TEXTB_BPE_SCIT_IT >> $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2sc> " . $_ ;}'  $E2S_TRAIN_BPE_SCEN_EN >> $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2sc> " . $_ ;}'  $E2S_TRAIN_BPE_SCEN_EN >> $TRAIN_M2M_SRC
head -n ${SCOFF} $E2S_TRAIN_BPE_SCEN_EN | perl -nle '{chomp; print "<2sc> " . $_ ;}'  >> $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2sc> " . $_ ;}'  $I2S_BACKT_BPE_SCIT_IT >> $TRAIN_M2M_SRC

perl -nle '{chomp; print "<2en> " . $_ ;}'  $S2E_TEXTB_BPE_SCEN_SC >> $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2en> " . $_ ;}'  $I2E_TEXTB_BPE_ITEN_IT >> $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2en> " . $_ ;}'  $S2E_TRAIN_BPE_SCEN_SC >> $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2en> " . $_ ;}'  $I2E_TRAIN_BPE_ITEN_IT >> $TRAIN_M2M_SRC

perl -nle '{chomp; print "<2it> " . $_ ;}'  $S2I_TEXTB_BPE_SCIT_SC >> $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2it> " . $_ ;}'  $E2I_TEXTB_BPE_ITEN_EN >> $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2it> " . $_ ;}'  $E2I_TRAIN_BPE_ITEN_EN >> $TRAIN_M2M_SRC
head -n ${ITOFF} $E2I_TRAIN_BPE_ITEN_EN | perl -nle '{chomp; print "<2it> " . $_ ;}'  >> $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2it> " . $_ ;}'  $S2I_BACKT_BPE_SCIT_SC >> $TRAIN_M2M_SRC

##  add directional token to validation data
perl -nle '{chomp; print "<2sc> " . $_ ;}'  $E2S_VALID_BPE_SCEN_EN >  $VALID_M2M_SRC
perl -nle '{chomp; print "<2en> " . $_ ;}'  $S2E_VALID_BPE_SCEN_SC >> $VALID_M2M_SRC

perl -nle '{chomp; print "<2en> " . $_ ;}'  $I2E_VALID_BPE_ITEN_IT >> $VALID_M2M_SRC
perl -nle '{chomp; print "<2it> " . $_ ;}'  $E2I_VALID_BPE_ITEN_EN >> $VALID_M2M_SRC

perl -nle '{chomp; print "<2sc> " . $_ ;}'  $I2S_VALID_BPE_SCIT_IT >> $VALID_M2M_SRC
perl -nle '{chomp; print "<2it> " . $_ ;}'  $S2I_VALID_BPE_SCIT_SC >> $VALID_M2M_SRC

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
