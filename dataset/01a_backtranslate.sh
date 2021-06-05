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
INFILE_SC_BT="dataset/backtrans/clean_bt-scen_good_tkn.sc"
OTFILE_EN_BT="dataset/backtrans/clean_bt-scen_good_tkn.en"

##  translation models
TNF_SCEN="./se31_multi/tnf_scen_c01"
TNF_ENSC="./se31_multi/tnf_ensc_c01"

##  subwords
SUBW_SC="./se31_multi/subwords/subwords.sc"
SUBW_EN="./se31_multi/subwords/subwords.en"
SUBW_IT="./se31_multi/subwords/subwords.it"

##  binaries
SBW_NMT="${HOME}/.local/bin/subword-nmt"
SOCKEYE="${HOME}/.local/bin/sockeye-translate"

##  output type
OUTPUT_TYPE="translation"
#OUTPUT_TYPE="translation_with_score"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  translate
${SOCKEYE} --models ${TNF_SCEN} --input ${INFILE_SC_BT} --output ${OTFILE_EN_BT} --output-type ${OUTPUT_TYPE} --use-cpu --quiet

##  remove subword splitting
sed -i "s/@@\s//g;s/\s~~'s/'s/g" ${OTFILE_EN_BT}

##  extract translation
#awk -F "\t" '{print $2}' ${OTFILE_EN_BT} >> ${OTFILE_EN_BT}_extracted

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
