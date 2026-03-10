#!/bin/bash

##  remove conversions from UTF-8 to ASCII

UTF8=(
    "./se37a_multi/data-tkn/e2i_wikim_v1-tkn_it-en.en"
    "./se37a_multi/data-tkn/e2i_wikim_v1-tkn_it-en.it"
    "./se37a_multi/data-tkn/i2e_wikim_v1-tkn_it-en.en"
    "./se37a_multi/data-tkn/i2e_wikim_v1-tkn_it-en.it"
)

##  convert data
for (( IDX = 0; IDX < ${#UTF8[@]}; IDX++ )) ; do
    rm -f  ${UTF8[$IDX]}.BKP  ${UTF8[$IDX]}.diff
done
