#!/bin/bash

##  Eryk Wdowiak
##  12 October 2024

##  script to concatenate raw parallel text files

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

OTDIR="./se37a_multi/data-raw"

S2EFILE="s2e_train_v0-raw"
S2ETEXT="s2e_textb_v0-raw"
S2ETEST="s2e_valid_v0-raw"
S2ENLLB="s2e_nllb5_v0-raw"

E2SFILE="e2s_train_v0-raw"
E2STEXT="e2s_textb_v0-raw"
E2STEST="e2s_valid_v0-raw"
E2SNLLB="e2s_nllb5_v0-raw"

I2EFILE="i2e_train_v0-raw"
I2EWIKI="i2e_wikim_v0-raw"
I2ETEXT="i2e_textb_v0-raw"
I2ETEST="i2e_valid_v0-raw"

E2IFILE="e2i_train_v0-raw"
E2IWIKI="e2i_wikim_v0-raw"
E2ITEXT="e2i_textb_v0-raw"
E2ITEST="e2i_valid_v0-raw"

E2IBACK="e2i_backt_v0-raw"
#E2IBADB="e2i_badbt_v0-raw"

I2SFILE="i2s_train_v0-raw"
I2STEXT="i2s_textb_v0-raw"
I2STEST="i2s_valid_v0-raw"
I2SWMBD="i2s_wmbad_v0-raw"

I2SBACK="i2s_backt_v0-raw"
#I2SBADB="i2s_badbt_v0-raw"

S2IFILE="s2i_train_v0-raw"
S2ITEXT="s2i_textb_v0-raw"
S2ITEST="s2i_valid_v0-raw"
S2IWMBD="s2i_wmbad_v0-raw"

S2IBACK="s2i_backt_v0-raw"
#S2IBADB="s2i_badbt_v0-raw"

S2EBACK="s2e_backt_v0-raw"
E2SBACK="e2s_backt_v0-raw"

DIELI="./dataset/dieli-cchiu/dieli-cchiu-vocab.txt"
E2S_DIELI="e2s_dieli_v0-raw"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

TEXTBOOK=(
    "./dataset/assembly-up-to-n33/mparamu-bonner"
    "./dataset/assembly-up-to-n33/numbers"
    "./dataset/assembly-with-n34/00c_links/bible-s1"
    "./parallels/magazine/gioacchino-murat"
)
DATA_SCEN=(
    "./dataset/assembly-up-to-n33/ArbaSicula-Dieli"
    ## "./dataset/dieli-cchiu/manifestu"
    "./parallels/napizia-website/wdowiak-napizia"
    "./dataset/assembly-with-n34/00c_links/as41"
    "./dataset/assembly-with-n34/00c_links/as42a"
    "./dataset/assembly-with-n34/00c_links/ms-songs"
    "./dataset/assembly-with-n34/00c_links/bible-s3"
    "./dataset/assembly-with-n34d/ls2-verbs"
    ## "./dataset/assembly-with-n34d/napizia-website"
    "./parallels/magazine/magazine-pages"
    "./parallels/magazine/peretz"
    "./parallels/magazine/valjean"
)

DATA_ITEN=(
    "./dataset/opus-farkas/opus-farkas_train"
    "./dataset/assembly-with-n34d/bible-uedin"
    "./parallels/magazine/bp02-goodt"
)
WIKI_ITEN=(
    ## "./dataset/assembly-with-n34/00c_links/wikimatrix-ei"
    "./dataset/assembly-with-n34e/wikimatrix2-ei"
)

DATA_SCIT=(
    "./dataset/assembly-with-n34/00c_links/bible-s2"
    "./dataset/assembly-with-n34/00c_links/wikimatrix-is"
    "./dataset/assembly-with-n34/00c_links/meli-lirica-one"
    "./dataset/assembly-with-n34/00c_links/meli-lirica-two"
)

#BADB_SCIT=""
#BADB_ITSC=""
#BADB_ENIT=""

BACK_ENSC=(
    "./dataset/backtrans_for-se37a/all-bt-04/mono-scn-bt-se37a"
    "./dataset/backtrans_for-se37a/all-bt-04/mono-scn-bt_cipolla"
)

BACK_SCEN="./dataset/backtrans_for-se37a/all-bt-04/mono-eng-bt-se37a"

BACK_ITSC=(
    "./dataset/backtrans_for-se37a/all-bt-04/moni-scn-bt-se37a"
    "./dataset/backtrans_for-se37a/all-bt-04/moni-scn-bt_cipolla"
)
BACK_SCIT=(
    "./dataset/backtrans_for-se37a/all-bt-04/mono-ita-bt-se37a"
)

#BACK_ITEN=""
BACK_ENIT=(
    "./parallels/magazine/bp01-backt"
    "./parallels/magazine/bp03-backt"
)


NLLB_SCEN=(
    "./dataset/nllb-napizia/nllb-napizia-50k"
)

WMBAD_SCIT=(
    "./dataset/assembly-for-se35a/wikimatrix-unchecked-makes-ascii"
)

SCTEST="./dataset/assembly-up-to-n33/test-data_as38-39"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  add Arthur Dieli's list
##  later we'll add it several times for theoretical subword splitting
##  we'll add Arthur Dieli's list seven times for "lucky seven"  ;-)
cat ${DIELI} >  ${OTDIR}/${E2S_DIELI}_sc-en.sc

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  sicilian-english
for LG in "sc" "en"; do
    ##  get extension
    if [ ${LG} == "sc" ] ; then EXT="sc-en.sc" ; else EXT="sc-en.en" ; fi
    
    ##  remove old files
    # rm -f ${OTDIR}/${S2EFILE}_${EXT}
    # rm -f ${OTDIR}/${S2ETEXT}_${EXT}
    # rm -f ${OTDIR}/${S2ETEST}_${EXT}
    # rm -f ${OTDIR}/${E2SFILE}_${EXT}
    # rm -f ${OTDIR}/${E2STEXT}_${EXT}
    # rm -f ${OTDIR}/${E2STEST}_${EXT}

    # rm -f ${OTDIR}/${E2SNLLB}_${EXT}
    # rm -f ${OTDIR}/${S2ENLLB}_${EXT}

    ##  append training data and copy it
    for (( IDX = 0; IDX < ${#DATA_SCEN[@]}; IDX++ )) ; do
	cat ${DATA_SCEN[$IDX]}.${LG} >> ${OTDIR}/${S2EFILE}_${EXT}
    done
    cp ${OTDIR}/${S2EFILE}_${EXT} ${OTDIR}/${E2SFILE}_${EXT}

    ##  append textbook and copy it
    for (( IDX = 0; IDX < ${#TEXTBOOK[@]}; IDX++ )) ; do
	cat ${TEXTBOOK[$IDX]}.${LG} >> ${OTDIR}/${S2ETEXT}_${EXT}
    done
    cp ${OTDIR}/${S2ETEXT}_${EXT} ${OTDIR}/${E2STEXT}_${EXT}

    ##  append NLLB data and copy it
    for (( IDX = 0; IDX < ${#NLLB_SCEN[@]}; IDX++ )) ; do
	cat ${NLLB_SCEN[$IDX]}.${LG} >> ${OTDIR}/${S2ENLLB}_${EXT}
    done
    cp ${OTDIR}/${S2ENLLB}_${EXT} ${OTDIR}/${E2SNLLB}_${EXT}    
    
    ##  copy back-translations
    cp ${BACK_SCEN}.${LG} ${OTDIR}/${S2EBACK}_${EXT}
    cp ${BACK_ENSC}.${LG} ${OTDIR}/${E2SBACK}_${EXT}

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
    # rm -f ${OTDIR}/${I2EFILE}_${EXT}
    # rm -f ${OTDIR}/${I2EWIKI}_${EXT}
    # rm -f ${OTDIR}/${I2ETEXT}_${EXT}
    # rm -f ${OTDIR}/${I2ETEST}_${EXT}
    
    # rm -f ${OTDIR}/${E2IFILE}_${EXT}
    # rm -f ${OTDIR}/${E2IWIKI}_${EXT}
    # rm -f ${OTDIR}/${E2ITEXT}_${EXT}
    # rm -f ${OTDIR}/${E2ITEST}_${EXT}
    
    # rm -f ${OTDIR}/${E2IBACK}_${EXT}
    # rm -f ${OTDIR}/${E2IBADB}_${EXT}

    ##  append training data and copy it
    for (( IDX = 0; IDX < ${#DATA_ITEN[@]}; IDX++ )) ; do
	cat ${DATA_ITEN[$IDX]}.${LG} >> ${OTDIR}/${I2EFILE}_${EXT}
    done
    cp ${OTDIR}/${I2EFILE}_${EXT} ${OTDIR}/${E2IFILE}_${EXT}

    ##  append wikimatrix data and copy it
    for (( IDX = 0; IDX < ${#WIKI_ITEN[@]}; IDX++ )) ; do
	cat ${WIKI_ITEN[$IDX]}.${LG} >> ${OTDIR}/${I2EWIKI}_${EXT}
    done
    cp ${OTDIR}/${I2EWIKI}_${EXT} ${OTDIR}/${E2IWIKI}_${EXT}
    
    ##  append textbook and copy it
    for (( IDX = 0; IDX < ${#TEXTBOOK[@]}; IDX++ )) ; do
	cat ${TEXTBOOK[$IDX]}.${LG} >> ${OTDIR}/${I2ETEXT}_${EXT}
    done
    cp ${OTDIR}/${I2ETEXT}_${EXT} ${OTDIR}/${E2ITEXT}_${EXT}

    ##  copy back-translations
    for (( IDX = 0; IDX < ${#BACK_ENIT[@]}; IDX++ )) ; do
	cat ${BACK_ENIT[$IDX]}.${LG} >> ${OTDIR}/${E2IBACK}_${EXT}
    done
    # cp ${BADB_ENIT}.${LG} ${OTDIR}/${E2IBADB}_${EXT}
    
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
    # rm -f ${OTDIR}/${S2IFILE}_${EXT}
    # rm -f ${OTDIR}/${S2ITEXT}_${EXT}
    # rm -f ${OTDIR}/${S2ITEST}_${EXT}
    # rm -f ${OTDIR}/${I2SFILE}_${EXT}
    # rm -f ${OTDIR}/${I2STEXT}_${EXT}
    # rm -f ${OTDIR}/${I2STEST}_${EXT}
    # rm -f ${OTDIR}/${I2SBACK}_${EXT}
    # rm -f ${OTDIR}/${I2SBADB}_${EXT}
    # #rm -f ${OTDIR}/${S2IBACK}_${EXT}

    ##  append training data and copy it
    for (( IDX = 0; IDX < ${#DATA_SCIT[@]}; IDX++ )) ; do
    	cat ${DATA_SCIT[$IDX]}.${LG} >> ${OTDIR}/${I2SFILE}_${EXT}
    done
    cp ${OTDIR}/${I2SFILE}_${EXT} ${OTDIR}/${S2IFILE}_${EXT}

    ##  append textbook and copy it
    for (( IDX = 0; IDX < ${#TEXTBOOK[@]}; IDX++ )) ; do
	cat ${TEXTBOOK[$IDX]}.${LG} >> ${OTDIR}/${I2STEXT}_${EXT}
    done
    cp ${OTDIR}/${I2STEXT}_${EXT} ${OTDIR}/${S2ITEXT}_${EXT}

    ##  append unchecked wikimatrix and copy it
    for (( IDX = 0; IDX < ${#WMBAD_SCIT[@]}; IDX++ )) ; do
	cat ${WMBAD_SCIT[$IDX]}.${LG} >> ${OTDIR}/${I2SWMBD}_${EXT}
    done
    cp ${OTDIR}/${I2SWMBD}_${EXT} ${OTDIR}/${S2IWMBD}_${EXT}
    
    ##  copy back-translations
    cp ${BACK_ITSC}.${LG} ${OTDIR}/${I2SBACK}_${EXT}
    for (( IDX = 0; IDX < ${#BACK_SCIT[@]}; IDX++ )) ; do
	cat ${BACK_SCIT[$IDX]}.${LG} >> ${OTDIR}/${S2IBACK}_${EXT}
    done
    #cp ${BADB_ITSC}.${LG} ${OTDIR}/${I2SBADB}_${EXT}
    
    ##  copy validation data
    cp ${SCTEST}.${LG} ${OTDIR}/${I2STEST}_${EXT}
    cp ${SCTEST}.${LG} ${OTDIR}/${S2ITEST}_${EXT}

done

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

exit 0

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
