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
##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##
##   *  valid-m2m.sh -- scores a model's translations 
##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  input files
INFILES=(
  "./validation/m2m_valid_v2-sbw_p01-ensc.src"
  "./validation/m2m_valid_v2-sbw_p02-scen.src"
  "./validation/m2m_valid_v2-sbw_p03-iten.src"
  "./validation/m2m_valid_v2-sbw_p04-enit.src"
  "./validation/m2m_valid_v2-sbw_p05-itsc.src"
  "./validation/m2m_valid_v2-sbw_p06-scit.src"
)
##  output key
KEY="se37a03-ckpt004"

##  select checkpoint
#CKPT=""
CKPT="--checkpoints 4"

##  score file
SCORES="./bleu-chrf_${KEY}.txt"

##  translation model
TNF_M2M="../tnf_m2m_se37a03"

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

mkdir ./valid-m2m-${KEY}

for (( IDX = 0; IDX < ${#INFILES[@]}; IDX++ )) ; do
    INFILE=${INFILES[$IDX]}
    OTFILE=$(echo $INFILE | sed "s/v2-sbw/v3-tkn/;s/src/tgt/;s/validation/valid-m2m-${KEY}/")
    RFFILE=$(echo $INFILE | sed 's/v2-sbw/v3-tkn/;s/src/tgt/')

    ##  translate
    # ${SOCKEYE} --models ${TNF_M2M} ${CKPT} --input ${INFILE} --output ${OTFILE} --output-type ${OUTPUT_TYPE} --use-cpu --quiet
    ${SOCKEYE} --models ${TNF_M2M} ${CKPT} --input ${INFILE} --output ${OTFILE} --output-type ${OUTPUT_TYPE} --quiet

    ##  remove subword splitting
    sed -i "s/@@\s//g;s/\s~~'s/'s/g" ${OTFILE}

    ##  evaluate translation
    printf "${OTFILE} -- " >> ${SCORES}
    ${SE_EVAL} --references ${RFFILE} --hypotheses ${OTFILE} --quiet  >> ${SCORES}

done

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
