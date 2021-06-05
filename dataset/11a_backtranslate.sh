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

##  input and output files
INFILE_SC_BT="./dataset/backtrans/clean_bt-scen_good_tkn.sc"
OTFILE_IT_BT="./dataset/backtrans/clean_bt-scit_good_v6-bck-npz.it"
INFILE_TMP_SC_BT="./dataset/backtrans/clean_bt-scit_good_tkn_TMP.sc"

#INFILE_SC_BT="./dataset/assembly-up-to-n30/test-data_as38-39.sc"
#OTFILE_IT_BT="./dataset/assembly-up-to-n30/test-data_as38-39_v0-bck.it"
#INFILE_TMP_SC_BT="./dataset/assembly-up-to-n30/test-data_as38-39_TMP.sc"

#INFILE_SC_BT="./dataset/assembly-up-to-n30/mparamu-bonner.sc"
#OTFILE_IT_BT="./dataset/assembly-up-to-n30/mparamu-bonner_v0-bck.it"
#INFILE_TMP_SC_BT="./dataset/assembly-up-to-n30/mparamu-bonner_TMP.sc"

##  translation models
TNF_SCEN="./se31_multi/tnf_scen_c01"
TNF_ENSC="./se31_multi/tnf_ensc_c01"
TNF_M2M="./se32_multi/tnf_m2m_c01"

##  subwords
CODES_SC="./se32_multi/subwords/subwords.sc"
CODES_EN="./se32_multi/subwords/subwords.en"
CODES_IT="./se32_multi/subwords/subwords.it"

##  binaries
SBW_NMT="${HOME}/.local/bin/subword-nmt"
SOCKEYE="${HOME}/.local/bin/sockeye-translate"

##  output type
OUTPUT_TYPE="translation"
#OUTPUT_TYPE="translation_with_score"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  subword splitting
${SBW_NMT} apply-bpe -c ${CODES_SC} < ${INFILE_SC_BT} > ${INFILE_TMP_SC_BT}

##  add directional token
sed -i "s/^/<2it> /" ${INFILE_TMP_SC_BT}

##  translate
${SOCKEYE} --models ${TNF_M2M} --input ${INFILE_TMP_SC_BT} --output ${OTFILE_IT_BT} --output-type ${OUTPUT_TYPE} --use-cpu --quiet

##  remove temporary file
rm -f ${INFILE_TMP_SC_BT}

##  remove subword splitting
sed -i "s/@@\s//g;s/\s~~'s/'s/g" ${OTFILE_IT_BT}

##  extract translation
#awk -F "\t" '{print $2}' ${OTFILE_EN_BT} >> ${OTFILE_EN_BT}_extracted

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
