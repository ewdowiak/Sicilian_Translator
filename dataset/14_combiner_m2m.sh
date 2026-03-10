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

##  combine files into datasets for training and validation

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  directories
BASE_DIR="./se37a_multi"
PCS_DIR="${BASE_DIR}/data-sbw/pieces"
FNL_DIR="${BASE_DIR}/data-sbw"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  sicilian

E2S_TRAIN_BPE_SCEN_SC="${PCS_DIR}/e2s_train_v2-sbw_sc-en.sc"
E2S_TEXTB_BPE_SCEN_SC="${PCS_DIR}/e2s_textb_v2-sbw_sc-en.sc"
E2S_VALID_BPE_SCEN_SC="${PCS_DIR}/e2s_valid_v2-sbw_sc-en.sc"

S2E_TRAIN_BPE_SCEN_SC="${PCS_DIR}/s2e_train_v2-sbw_sc-en.sc"
S2E_TEXTB_BPE_SCEN_SC="${PCS_DIR}/s2e_textb_v2-sbw_sc-en.sc"
S2E_VALID_BPE_SCEN_SC="${PCS_DIR}/s2e_valid_v2-sbw_sc-en.sc"

I2S_TRAIN_BPE_SCIT_SC="${PCS_DIR}/i2s_train_v2-sbw_sc-it.sc"
I2S_BACKT_BPE_SCIT_SC="${PCS_DIR}/i2s_backt_v2-sbw_sc-it.sc"
# I2S_BADBT_BPE_SCIT_SC="${PCS_DIR}/i2s_badbt_v2-sbw_sc-it.sc"
I2S_TEXTB_BPE_SCIT_SC="${PCS_DIR}/i2s_textb_v2-sbw_sc-it.sc"
I2S_VALID_BPE_SCIT_SC="${PCS_DIR}/i2s_valid_v2-sbw_sc-it.sc"

S2I_TRAIN_BPE_SCIT_SC="${PCS_DIR}/s2i_train_v2-sbw_sc-it.sc"
S2I_BACKT_BPE_SCIT_SC="${PCS_DIR}/s2i_backt_v2-sbw_sc-it.sc"
S2I_TEXTB_BPE_SCIT_SC="${PCS_DIR}/s2i_textb_v2-sbw_sc-it.sc"
S2I_VALID_BPE_SCIT_SC="${PCS_DIR}/s2i_valid_v2-sbw_sc-it.sc"

##  unchecked NLLB 50k and unchecked WikiMatrix
E2S_NLLB5_BPE_SCEN_SC="${PCS_DIR}/e2s_nllb5_v2-sbw_sc-en.sc"
S2E_NLLB5_BPE_SCEN_SC="${PCS_DIR}/s2e_nllb5_v2-sbw_sc-en.sc"

I2S_WMBAD_BPE_SCIT_SC="${PCS_DIR}/i2s_wmbad_v2-sbw_sc-it.sc"
S2I_WMBAD_BPE_SCIT_SC="${PCS_DIR}/s2i_wmbad_v2-sbw_sc-it.sc"

##
E2S_BACKT_BPE_SCEN_SC="${PCS_DIR}/e2s_backt_v2-sbw_sc-en.sc"
S2E_BACKT_BPE_SCEN_SC="${PCS_DIR}/s2e_backt_v2-sbw_sc-en.sc"

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

##  back translations and unchecked NLLB 50k
E2I_BACKT_BPE_ITEN_EN="${PCS_DIR}/e2i_backt_v2-sbw_it-en.en"
# E2I_BADBT_BPE_ITEN_EN="${PCS_DIR}/e2i_badbt_v2-sbw_it-en.en"

E2S_NLLB5_BPE_SCEN_EN="${PCS_DIR}/e2s_nllb5_v2-sbw_sc-en.en"
S2E_NLLB5_BPE_SCEN_EN="${PCS_DIR}/s2e_nllb5_v2-sbw_sc-en.en"


E2I_WIKIM_BPE_ITEN_EN="${PCS_DIR}/e2i_wikim_v2-sbw_it-en.en"
I2E_WIKIM_BPE_ITEN_EN="${PCS_DIR}/i2e_wikim_v2-sbw_it-en.en"

##
E2S_BACKT_BPE_SCEN_EN="${PCS_DIR}/e2s_backt_v2-sbw_sc-en.en"
S2E_BACKT_BPE_SCEN_EN="${PCS_DIR}/s2e_backt_v2-sbw_sc-en.en"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  italian

E2I_TRAIN_BPE_ITEN_IT="${PCS_DIR}/e2i_train_v2-sbw_it-en.it"
E2I_TEXTB_BPE_ITEN_IT="${PCS_DIR}/e2i_textb_v2-sbw_it-en.it"
E2I_VALID_BPE_ITEN_IT="${PCS_DIR}/e2i_valid_v2-sbw_it-en.it"

I2E_TRAIN_BPE_ITEN_IT="${PCS_DIR}/i2e_train_v2-sbw_it-en.it"
I2E_TEXTB_BPE_ITEN_IT="${PCS_DIR}/i2e_textb_v2-sbw_it-en.it"
I2E_VALID_BPE_ITEN_IT="${PCS_DIR}/i2e_valid_v2-sbw_it-en.it"

I2S_TRAIN_BPE_SCIT_IT="${PCS_DIR}/i2s_train_v2-sbw_sc-it.it"
I2S_BACKT_BPE_SCIT_IT="${PCS_DIR}/i2s_backt_v2-sbw_sc-it.it"
#I2S_BADBT_BPE_SCIT_IT="${PCS_DIR}/i2s_badbt_v2-sbw_sc-it.it"
I2S_TEXTB_BPE_SCIT_IT="${PCS_DIR}/i2s_textb_v2-sbw_sc-it.it"
I2S_VALID_BPE_SCIT_IT="${PCS_DIR}/i2s_valid_v2-sbw_sc-it.it"

S2I_TRAIN_BPE_SCIT_IT="${PCS_DIR}/s2i_train_v2-sbw_sc-it.it"
S2I_BACKT_BPE_SCIT_IT="${PCS_DIR}/s2i_backt_v2-sbw_sc-it.it"
S2I_TEXTB_BPE_SCIT_IT="${PCS_DIR}/s2i_textb_v2-sbw_sc-it.it"
S2I_VALID_BPE_SCIT_IT="${PCS_DIR}/s2i_valid_v2-sbw_sc-it.it"

##  back translations and unchecked WikiMatrix
E2I_BACKT_BPE_ITEN_IT="${PCS_DIR}/e2i_backt_v2-sbw_it-en.it"
#E2I_BADBT_BPE_ITEN_IT="${PCS_DIR}/e2i_badbt_v2-sbw_it-en.it"

I2S_WMBAD_BPE_SCIT_IT="${PCS_DIR}/i2s_wmbad_v2-sbw_sc-it.it"
S2I_WMBAD_BPE_SCIT_IT="${PCS_DIR}/s2i_wmbad_v2-sbw_sc-it.it"

E2I_WIKIM_BPE_ITEN_IT="${PCS_DIR}/e2i_wikim_v2-sbw_it-en.it"
I2E_WIKIM_BPE_ITEN_IT="${PCS_DIR}/i2e_wikim_v2-sbw_it-en.it"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  combined training data
TRAIN_M2M_SRC="${FNL_DIR}/m2m_train_v2-sbw.src"
TRAIN_M2M_TGT="${FNL_DIR}/m2m_train_v2-sbw.tgt"

UNBAL_M2M_SRC="${FNL_DIR}/m2m_unbal_v2-sbw.src"
UNBAL_M2M_TGT="${FNL_DIR}/m2m_unbal_v2-sbw.tgt"

##  combined validation data
VALID_M2M_SRC="${FNL_DIR}/m2m_valid_v2-sbw.src"
VALID_M2M_TGT="${FNL_DIR}/m2m_valid_v2-sbw.tgt"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  TARGET (balanced)

##  combine training data (without directional token)

##  sicilian

cat $E2S_TEXTB_BPE_SCEN_SC >  $TRAIN_M2M_TGT
cat $I2S_TEXTB_BPE_SCIT_SC >> $TRAIN_M2M_TGT

for i in {1..6} ; do
    cat $E2S_TRAIN_BPE_SCEN_SC >> $TRAIN_M2M_TGT
done

for i in {1..5} ; do
    cat $I2S_TRAIN_BPE_SCIT_SC >> $TRAIN_M2M_TGT
done

##  english

cat $S2E_TEXTB_BPE_SCEN_EN >> $TRAIN_M2M_TGT
cat $I2E_TEXTB_BPE_ITEN_EN >> $TRAIN_M2M_TGT

cat $S2E_TRAIN_BPE_SCEN_EN >> $TRAIN_M2M_TGT
cat $I2E_TRAIN_BPE_ITEN_EN >> $TRAIN_M2M_TGT

##  italian

cat $S2I_TEXTB_BPE_SCIT_IT >> $TRAIN_M2M_TGT
cat $E2I_TEXTB_BPE_ITEN_IT >> $TRAIN_M2M_TGT

for i in {1..3} ; do
    cat $S2I_TRAIN_BPE_SCIT_IT >> $TRAIN_M2M_TGT
done

cat $E2I_TRAIN_BPE_ITEN_IT >> $TRAIN_M2M_TGT


##  combine validation data (without directional token)
cat $E2S_VALID_BPE_SCEN_SC >  $VALID_M2M_TGT
cat $S2E_VALID_BPE_SCEN_EN >> $VALID_M2M_TGT

cat $I2E_VALID_BPE_ITEN_EN >> $VALID_M2M_TGT
cat $E2I_VALID_BPE_ITEN_IT >> $VALID_M2M_TGT

cat $I2S_VALID_BPE_SCIT_SC >> $VALID_M2M_TGT
cat $S2I_VALID_BPE_SCIT_IT >> $VALID_M2M_TGT

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SOURCE (balanced)

##  add directional token to training data

##  sicilian

perl -nle '{chomp; print "<2sc> " . $_ ;}'  $E2S_TEXTB_BPE_SCEN_EN >  $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2sc> " . $_ ;}'  $I2S_TEXTB_BPE_SCIT_IT >> $TRAIN_M2M_SRC

for i in {1..6} ; do
    perl -nle '{chomp; print "<2sc> " . $_ ;}'  $E2S_TRAIN_BPE_SCEN_EN >> $TRAIN_M2M_SRC
done

for i in {1..5} ; do
    perl -nle '{chomp; print "<2sc> " . $_ ;}'  $I2S_TRAIN_BPE_SCIT_IT >> $TRAIN_M2M_SRC
done

##  english

perl -nle '{chomp; print "<2en> " . $_ ;}'  $S2E_TEXTB_BPE_SCEN_SC >> $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2en> " . $_ ;}'  $I2E_TEXTB_BPE_ITEN_IT >> $TRAIN_M2M_SRC

perl -nle '{chomp; print "<2en> " . $_ ;}'  $S2E_TRAIN_BPE_SCEN_SC >> $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2en> " . $_ ;}'  $I2E_TRAIN_BPE_ITEN_IT >> $TRAIN_M2M_SRC

##  italian

perl -nle '{chomp; print "<2it> " . $_ ;}'  $S2I_TEXTB_BPE_SCIT_SC >> $TRAIN_M2M_SRC
perl -nle '{chomp; print "<2it> " . $_ ;}'  $E2I_TEXTB_BPE_ITEN_EN >> $TRAIN_M2M_SRC

for i in {1..3} ; do
    perl -nle '{chomp; print "<2it> " . $_ ;}'  $S2I_TRAIN_BPE_SCIT_SC >> $TRAIN_M2M_SRC
done

perl -nle '{chomp; print "<2it> " . $_ ;}'  $E2I_TRAIN_BPE_ITEN_EN >> $TRAIN_M2M_SRC


##  add directional token to validation data
perl -nle '{chomp; print "<2sc> " . $_ ;}'  $E2S_VALID_BPE_SCEN_EN >  $VALID_M2M_SRC
perl -nle '{chomp; print "<2en> " . $_ ;}'  $S2E_VALID_BPE_SCEN_SC >> $VALID_M2M_SRC

perl -nle '{chomp; print "<2en> " . $_ ;}'  $I2E_VALID_BPE_ITEN_IT >> $VALID_M2M_SRC
perl -nle '{chomp; print "<2it> " . $_ ;}'  $E2I_VALID_BPE_ITEN_EN >> $VALID_M2M_SRC

perl -nle '{chomp; print "<2sc> " . $_ ;}'  $I2S_VALID_BPE_SCIT_IT >> $VALID_M2M_SRC
perl -nle '{chomp; print "<2it> " . $_ ;}'  $S2I_VALID_BPE_SCIT_SC >> $VALID_M2M_SRC

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  TARGET (unbalanced)

##  combine training data (without directional token)

##  sicilian
cat $E2S_BACKT_BPE_SCEN_SC  > $UNBAL_M2M_TGT
cat $E2S_NLLB5_BPE_SCEN_SC >> $UNBAL_M2M_TGT
cat $I2S_WMBAD_BPE_SCIT_SC >> $UNBAL_M2M_TGT
cat $I2S_BACKT_BPE_SCIT_SC >> $UNBAL_M2M_TGT

##  english
cat $S2E_BACKT_BPE_SCEN_EN >> $UNBAL_M2M_TGT
cat $S2E_NLLB5_BPE_SCEN_EN >> $UNBAL_M2M_TGT
cat $I2E_WIKIM_BPE_ITEN_EN >> $UNBAL_M2M_TGT

##  italian
cat $E2I_BACKT_BPE_ITEN_IT >> $UNBAL_M2M_TGT
cat $S2I_BACKT_BPE_SCIT_IT >> $UNBAL_M2M_TGT
cat $S2I_WMBAD_BPE_SCIT_IT >> $UNBAL_M2M_TGT
cat $E2I_WIKIM_BPE_ITEN_IT >> $UNBAL_M2M_TGT



##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SOURCE (unbalanced)

##  add directional token to training data

##  sicilian
perl -nle '{chomp; print "<2sc> " . $_ ;}'  $E2S_BACKT_BPE_SCEN_EN  > $UNBAL_M2M_SRC
perl -nle '{chomp; print "<2sc> " . $_ ;}'  $E2S_NLLB5_BPE_SCEN_EN >> $UNBAL_M2M_SRC
perl -nle '{chomp; print "<2sc> " . $_ ;}'  $I2S_WMBAD_BPE_SCIT_IT >> $UNBAL_M2M_SRC
perl -nle '{chomp; print "<2sc> " . $_ ;}'  $I2S_BACKT_BPE_SCIT_IT >> $UNBAL_M2M_SRC

##  english
perl -nle '{chomp; print "<2en> " . $_ ;}'  $S2E_BACKT_BPE_SCEN_SC >> $UNBAL_M2M_SRC
perl -nle '{chomp; print "<2en> " . $_ ;}'  $S2E_NLLB5_BPE_SCEN_SC >> $UNBAL_M2M_SRC
perl -nle '{chomp; print "<2en> " . $_ ;}'  $I2E_WIKIM_BPE_ITEN_IT >> $UNBAL_M2M_SRC

##  italian
perl -nle '{chomp; print "<2it> " . $_ ;}'  $E2I_BACKT_BPE_ITEN_EN >> $UNBAL_M2M_SRC
perl -nle '{chomp; print "<2it> " . $_ ;}'  $S2I_BACKT_BPE_SCIT_SC >> $UNBAL_M2M_SRC
perl -nle '{chomp; print "<2it> " . $_ ;}'  $S2I_WMBAD_BPE_SCIT_SC >> $UNBAL_M2M_SRC
perl -nle '{chomp; print "<2it> " . $_ ;}'  $E2I_WIKIM_BPE_ITEN_EN >> $UNBAL_M2M_SRC


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  ##  SCRAPS
##  ##  ======

##  offsets
#SCOFF="14163"
#ITOFF="8991"

##  # head -n ${SCOFF} $E2S_TRAIN_BPE_SCEN_SC >> $TRAIN_M2M_TGT
##  # head -n ${ITOFF} $E2I_TRAIN_BPE_ITEN_IT >> $TRAIN_M2M_TGT

##  # head -n ${SCOFF} $E2S_TRAIN_BPE_SCEN_EN | perl -nle '{chomp; print "<2sc> " . $_ ;}'  >> $TRAIN_M2M_SRC
##  # head -n ${ITOFF} $E2I_TRAIN_BPE_ITEN_EN | perl -nle '{chomp; print "<2it> " . $_ ;}'  >> $TRAIN_M2M_SRC

##  # perl -nle '{chomp; print "<2it> " . $_ ;}'  $S2I_BACKT_BPE_SCIT_SC >> $TRAIN_M2M_SRC
