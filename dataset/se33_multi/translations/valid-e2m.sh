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

##  input files
INFILES=(
  "./validation/m2m_valid_v2-sbw_p01-ensc.src"
  "./validation/m2m_valid_v2-sbw_p04-enit.src"
)
##  score file
SCORES="./bleu-chrf_e2m-c01.txt"

##  translation models
TNF_SCEN="../tnf_scen_c01"
TNF_ENSC="../tnf_ensc_c01"
TNF_M2M="../tnf_m2m_c02"

##  subwords
CODES_SC="../subwords/subwords.sc"
CODES_EN="../subwords/subwords.en"
CODES_IT="../subwords/subwords.it"

##  binaries
SBW_NMT="${HOME}/.local/bin/subword-nmt"
SOCKEYE="${HOME}/.local/bin/sockeye-translate"
SE_EVAL="${HOME}/.local/bin/sockeye-evaluate"

##  output type
OUTPUT_TYPE="translation"
#OUTPUT_TYPE="translation_with_score"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

for (( IDX = 0; IDX < ${#INFILES[@]}; IDX++ )) ; do
    INFILE=${INFILES[$IDX]}
    OTFILE=$(echo $INFILE | sed 's/v2-sbw/v3-tkn/;s/src/tgt/;s/validation/valid-out/')
    RFFILE=$(echo $INFILE | sed 's/v2-sbw/v3-tkn/;s/src/tgt/')

    ##  translate
    ${SOCKEYE} --models ${TNF_ENSC} --input ${INFILE} --output ${OTFILE} --output-type ${OUTPUT_TYPE} --quiet

    ##  remove subword splitting
    sed -i "s/@@\s//g;s/\s~~'s/'s/g" ${OTFILE}

    ##  evaluate translation
    printf "${OTFILE} -- " >> ${SCORES}
    ${SE_EVAL} --references ${RFFILE} --hypotheses ${OTFILE} --quiet  >> ${SCORES}

done

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
