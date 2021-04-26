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

##  script to concatenate raw parallel text files

OTDIR="./se31_multi/data-raw"

M2EFILE="m2e_train_v0-raw"
M2EBACK="m2e_backt_v0-raw"
M2ETEST="m2e_valid_v0-raw"

E2MFILE="e2m_train_v0-raw"
E2MBACK="e2m_backt_v0-raw"
E2MTEST="e2m_valid_v0-raw"

DIELI="./dataset/dieli-cchiu/dieli-cchiu-vocab.txt"
E2MBACK_DIELI="e2m_trbck-dieli_v0-raw"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

SCFILES=(
    "./dataset/assembly-up-to-n30/clean-mparamu-as19-40"
    "./dataset/dieli-cchiu/manifestu"
)
ITFILES=(
    "./dataset/opus-farkas/opus-farkas_train"
    "./dataset/dieli-cchiu/numbers"
)
BKFILES=(
    "./dataset/backtrans/clean_bt-scen_good_tkn"
)

SCTEST="./dataset/assembly-up-to-n30/test-data_as38-39"
ITTEST="./dataset/opus-farkas/opus-farkas_valid"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  sicilian-english
for LG in "sc" "en"; do
    ##  get extension
    if [ ${LG} == "sc" ] ; then EXT="sc-en.sc" ; else EXT="sc-en.en" ; fi
    
    ##  remove old files
    rm -f ${OTDIR}/${M2EFILE}_${EXT}
    rm -f ${OTDIR}/${M2ETEST}_${EXT}
    rm -f ${OTDIR}/${E2MFILE}_${EXT}
    rm -f ${OTDIR}/${E2MTEST}_${EXT}
    rm -f ${OTDIR}/${E2MBACK}_${EXT}

    ##  append training data
    for (( IDX = 0; IDX < ${#SCFILES[@]}; IDX++ )) ; do
	cat ${SCFILES[$IDX]}.${LG} >> ${OTDIR}/${M2EFILE}_${EXT}
    done
    
    ##  copy parallels
    cp ${OTDIR}/${M2EFILE}_${EXT} ${OTDIR}/${E2MFILE}_${EXT}
    
    ##  append back translations
    for (( IDX = 0; IDX < ${#BKFILES[@]}; IDX++ )) ; do
	cat ${BKFILES[$IDX]}.${LG} >> ${OTDIR}/${E2MBACK}_${EXT}
    done
        
    ##  copy validation data
    cp ${SCTEST}.${LG} ${OTDIR}/${M2ETEST}_${EXT}
    cp ${SCTEST}.${LG} ${OTDIR}/${E2MTEST}_${EXT}

done

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  add Dieli list (thrice) for subword splitting
##  to the sicilian training file with back translations
cp ${OTDIR}/${E2MBACK}_sc-en.sc ${OTDIR}/${E2MBACK_DIELI}_sc-en.sc
cat ${DIELI} >> ${OTDIR}/${E2MBACK_DIELI}_sc-en.sc
cat ${DIELI} >> ${OTDIR}/${E2MBACK_DIELI}_sc-en.sc
cat ${DIELI} >> ${OTDIR}/${E2MBACK_DIELI}_sc-en.sc

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  italian-english
for LG in "it" "en"; do
    ##  get extension
    if [ ${LG} == "it" ] ; then EXT="it-en.it" ; else EXT="it-en.en" ; fi

    ##  remove old files
    rm -f ${OTDIR}/${M2EFILE}_${EXT}
    rm -f ${OTDIR}/${M2ETEST}_${EXT}
    rm -f ${OTDIR}/${E2MFILE}_${EXT}
    rm -f ${OTDIR}/${E2MTEST}_${EXT}

    ##  append training data
    for (( IDX = 0; IDX < ${#ITFILES[@]}; IDX++ )) ; do
	cat ${ITFILES[$IDX]}.${LG} >> ${OTDIR}/${M2EFILE}_${EXT}
    done

    ##  copy parallels
    cp ${OTDIR}/${M2EFILE}_${EXT} ${OTDIR}/${E2MFILE}_${EXT}
        
    ##  copy validation data
    cp ${ITTEST}.${LG} ${OTDIR}/${M2ETEST}_${EXT}
    cp ${ITTEST}.${LG} ${OTDIR}/${E2MTEST}_${EXT}

done

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

exit 0

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
