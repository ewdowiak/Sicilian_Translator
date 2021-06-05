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

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

OTDIR="./se33_multi/data-raw"

S2EFILE="s2e_train_v0-raw"
S2ETEXT="s2e_textb_v0-raw"
S2ETEST="s2e_valid_v0-raw"

E2SFILE="e2s_train_v0-raw"
E2STEXT="e2s_textb_v0-raw"
E2STEST="e2s_valid_v0-raw"

I2EFILE="i2e_train_v0-raw"
I2ETEXT="i2e_textb_v0-raw"
I2ETEST="i2e_valid_v0-raw"

E2IFILE="e2i_train_v0-raw"
E2ITEXT="e2i_textb_v0-raw"
E2ITEST="e2i_valid_v0-raw"

#I2SFILE="i2s_train_v0-raw"
I2STEXT="i2s_textb_v0-raw"
I2SBACK="i2s_backt_v0-raw"
I2STEST="i2s_valid_v0-raw"

#S2IFILE="s2i_train_v0-raw"
S2ITEXT="s2i_textb_v0-raw"
S2IBACK="s2i_backt_v0-raw"
S2ITEST="s2i_valid_v0-raw"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

TEXTBOOK=(
    "./dataset/assembly-up-to-n33/mparamu-bonner"
    "./dataset/assembly-up-to-n33/numbers"
)
DATA_SCEN=(
    "./dataset/assembly-up-to-n33/ArbaSicula-Dieli"
    "./dataset/dieli-cchiu/manifestu"
)
DATA_ITEN=(
    "./dataset/opus-farkas/opus-farkas-m2m_train"
)
#DATA_SCIT=(
#)
BACK_ITSC="./dataset/backtrans/clean_bt-scit_good_tkn"
BACK_SCIT="./dataset/opus-farkas/opus-farkas-m2m_back"

SCTEST="./dataset/assembly-up-to-n33/test-data_as38-39"
#ITTEST="./dataset/opus-farkas/opus-farkas_valid"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  sicilian-english
for LG in "sc" "en"; do
    ##  get extension
    if [ ${LG} == "sc" ] ; then EXT="sc-en.sc" ; else EXT="sc-en.en" ; fi
    
    ##  remove old files
    rm -f ${OTDIR}/${S2EFILE}_${EXT}
    rm -f ${OTDIR}/${S2ETEXT}_${EXT}
    rm -f ${OTDIR}/${S2ETEST}_${EXT}
    rm -f ${OTDIR}/${E2SFILE}_${EXT}
    rm -f ${OTDIR}/${E2STEXT}_${EXT}
    rm -f ${OTDIR}/${E2STEST}_${EXT}

    ##  append training data
    for (( IDX = 0; IDX < ${#DATA_SCEN[@]}; IDX++ )) ; do
	cat ${DATA_SCEN[$IDX]}.${LG} >> ${OTDIR}/${S2EFILE}_${EXT}
    done

    ##  append textbook
    for (( IDX = 0; IDX < ${#TEXTBOOK[@]}; IDX++ )) ; do
	cat ${TEXTBOOK[$IDX]}.${LG} >> ${OTDIR}/${S2ETEXT}_${EXT}
    done    
    
    ##  copy parallels
    cp ${OTDIR}/${S2EFILE}_${EXT} ${OTDIR}/${E2SFILE}_${EXT}
    cp ${OTDIR}/${S2ETEXT}_${EXT} ${OTDIR}/${E2STEXT}_${EXT}
    
    ##  copy validation data
    cp ${SCTEST}.${LG} ${OTDIR}/${S2ETEST}_${EXT}
    cp ${SCTEST}.${LG} ${OTDIR}/${E2STEST}_${EXT}

done

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  italian-english
for LG in "it" "en"; do
    ##  get extension
    if [ ${LG} == "it" ] ; then EXT="it-en.it" ; else EXT="it-en.en" ; fi

    ##  remove old files
    rm -f ${OTDIR}/${I2EFILE}_${EXT}
    rm -f ${OTDIR}/${I2ETEXT}_${EXT}
    rm -f ${OTDIR}/${I2ETEST}_${EXT}
    rm -f ${OTDIR}/${E2IFILE}_${EXT}
    rm -f ${OTDIR}/${E2ITEXT}_${EXT}
    rm -f ${OTDIR}/${E2ITEST}_${EXT}

    ##  append training data
    for (( IDX = 0; IDX < ${#DATA_ITEN[@]}; IDX++ )) ; do
	cat ${DATA_ITEN[$IDX]}.${LG} >> ${OTDIR}/${I2EFILE}_${EXT}
    done

    ##  append textbook
    for (( IDX = 0; IDX < ${#TEXTBOOK[@]}; IDX++ )) ; do
	cat ${TEXTBOOK[$IDX]}.${LG} >> ${OTDIR}/${I2ETEXT}_${EXT}
    done
    
    ##  copy parallels
    cp ${OTDIR}/${I2EFILE}_${EXT} ${OTDIR}/${E2IFILE}_${EXT}
    cp ${OTDIR}/${I2ETEXT}_${EXT} ${OTDIR}/${E2ITEXT}_${EXT}

    ##  copy validation data
    cp ${SCTEST}.${LG} ${OTDIR}/${I2ETEST}_${EXT}
    cp ${SCTEST}.${LG} ${OTDIR}/${E2ITEST}_${EXT}

done

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  sicilian-italian
for LG in "sc" "it"; do
    ##  get extension
    if [ ${LG} == "sc" ] ; then EXT="sc-it.sc" ; else EXT="sc-it.it" ; fi
    
    ##  remove old files
    #rm -f ${OTDIR}/${S2IFILE}_${EXT}
    rm -f ${OTDIR}/${S2ITEXT}_${EXT}
    rm -f ${OTDIR}/${S2ITEST}_${EXT}
    #rm -f ${OTDIR}/${I2SFILE}_${EXT}
    rm -f ${OTDIR}/${I2STEXT}_${EXT}
    rm -f ${OTDIR}/${I2STEST}_${EXT}

    ##  append training data
    #for (( IDX = 0; IDX < ${#DATA_SCIT[@]}; IDX++ )) ; do
    #	cat ${DATA_SCIT[$IDX]}.${LG} >> ${OTDIR}/${I2SFILE}_${EXT}
    #done

    ##  append textbook
    for (( IDX = 0; IDX < ${#TEXTBOOK[@]}; IDX++ )) ; do
	cat ${TEXTBOOK[$IDX]}.${LG} >> ${OTDIR}/${I2STEXT}_${EXT}
    done
    
    ##  copy back-translations
    cp ${BACK_ITSC}.${LG} ${OTDIR}/${I2SBACK}_${EXT}
    cp ${BACK_SCIT}.${LG} ${OTDIR}/${S2IBACK}_${EXT}
    
    ##  copy parallels
    #cp ${OTDIR}/${I2SFILE}_${EXT} ${OTDIR}/${S2IFILE}_${EXT}
    cp ${OTDIR}/${I2STEXT}_${EXT} ${OTDIR}/${S2ITEXT}_${EXT}

    ##  copy validation data
    cp ${SCTEST}.${LG} ${OTDIR}/${I2STEST}_${EXT}
    cp ${SCTEST}.${LG} ${OTDIR}/${S2ITEST}_${EXT}

done

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

exit 0

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
